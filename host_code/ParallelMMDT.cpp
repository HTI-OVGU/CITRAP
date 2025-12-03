#ifndef MMDTPARALLELIZATION_H
#define MMDTPARALLELIZATION_H

#include <fcntl.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <time.h>
#include <vector>
#include <iostream>
#include <stdexcept>
#include <unistd.h> // for close()
#include <mutex> // for std::mutex
#include <type_traits>
#include "DMAUtils.h"

#define DEVICE_WRITE_PREFIX "xdma0_h2c"
#define DEVICE_READ_PREFIX "xdma0_c2h"
#define SIZE_DEFAULT (1)
#define COUNT_DEFAULT (1)
#define RW_MAX_SIZE 0x7ffff000

static std::mutex console_mutex;
static DMAUtils dmaUtils;
static bool printData = false;
static bool printBufferData = false;

/**
 * @brief helper struct for splitting data
 * 
 * @tparam T - datatype of the data being written/read
 */
template<typename T>
struct ThreadData {
    std::vector<T> data;
    uint64_t address;
    std::string device_name;
};

/**
 * @brief Function to handle data transfer to FPGA for each thread
 * 
 * @tparam T - type of data being written
 * @param arg 
 * @return void* 
 */
template<typename T>
void* sendToFPGASingle(void* arg) {
    auto* tdata = static_cast<ThreadData<T>*>(arg);
    const auto& data = tdata->data;
    uint64_t address = tdata->address;
    const std::string& devname = tdata->device_name;

    size_t size = data.size() * sizeof(T);
    char* buffer = nullptr;
    char* allocated = nullptr;
    size_t bytes_done = 0;
    int fpga_fd = open(devname.c_str(), O_RDWR);

    if (fpga_fd < 0) {
        std::cerr << "Unable to open device " << devname << std::endl;
        perror("open device");
        pthread_exit((void*)-EINVAL);
    }

    int rc = posix_memalign((void**)&allocated, 4096, size + 4096);
    if (rc != 0) {
        std::cerr << "OOM " << size + 4096 << std::endl;
        close(fpga_fd);
        pthread_exit((void*)-ENOMEM);
    }

    buffer = allocated;
    memcpy(buffer, data.data(), size);

    {
        std::lock_guard<std::mutex> lock(console_mutex);
        if(printBufferData) {
            std::cout << "Buffer contents for " << devname << ": ";
            for (size_t i = 0; i < size; ++i) {
                printf("%02x ", (unsigned char)buffer[i]);
            }
            std::cout << std::endl;
        }

    }

    rc = dmaUtils.writeFromBuffer(devname.c_str(), fpga_fd, buffer, size, address);
    if (rc < 0) {
        std::cerr << "Failed to write to buffer." << std::endl;
        free(allocated);
        close(fpga_fd);
        return reinterpret_cast<void*>(static_cast<intptr_t>(rc));
    }
    bytes_done = rc;
    if (bytes_done < size) {
        std::cout << "Underflow " << bytes_done << "/" << size << "." << std::endl;
    }

    free(allocated);
    close(fpga_fd);
    return reinterpret_cast<void*>(static_cast<intptr_t>(rc));
}

/**
 * @brief Function to handle data transfer from FPGA for each thread
 * 
 * @tparam T - type of data being read
 * @param arg 
 * @return void* 
 */
template<typename T>
void* readFromFPGASingle(void* arg) {
    auto* tdata = static_cast<ThreadData<T>*>(arg);
    auto& data = tdata->data;
    uint64_t address = tdata->address;
    const std::string& devname = tdata->device_name;

    ssize_t rc = 0;
    char* buffer = nullptr;
    char* allocated = nullptr;
    size_t size = data.size() * sizeof(T);
    int fpga_fd = open(devname.c_str(), O_RDWR | O_TRUNC);

    if (fpga_fd < 0) {
        std::cerr << "Unable to open device " << devname << std::endl;
        perror("open device");
        pthread_exit((void*)-EINVAL);
    }

    rc = posix_memalign((void**)&allocated, 4096, size + 4096);
    if (rc != 0) {
        std::cerr << "OOM " << size + 4096 << std::endl;
        close(fpga_fd);
        pthread_exit((void*)-ENOMEM);
    }

    buffer = allocated;
    rc = dmaUtils.readToBuffer(devname.c_str(), fpga_fd, buffer, size, address);
    if (rc < 0) {
        std::cerr << "Failed to read from buffer." << std::endl;
        free(allocated);
        close(fpga_fd);
        pthread_exit((void*)rc);
    }

    {
        std::lock_guard<std::mutex> lock(console_mutex);
        if(printBufferData) {
            std::cout << "Total Bytes to read from " << devname << ": " << size << std::endl;
            std::cout << "Read from FPGA: ";
            for (size_t i = 0; i < size; ++i) {
                printf("%02x ", (unsigned char)buffer[i]);
            }
            std::cout << std::endl;
        }
    }

    memcpy(data.data(), buffer, size);

    free(allocated);
    close(fpga_fd);
    pthread_exit((void*)0);
}

/**
 * @brief Class provides functionality to do memory mapped data transfer to and from FPGA. 
 * It makes use of all available channels to read and write in parallel.
 * \skipline ----------------------------
 * Example usage :
 * \skipline ----------------------------
 * ParallelMMDT parallelMMDT; // Instatiate the class variable.
 * \skipline ----------------------------
 * typedef float dataType; // Specify the desired data type in place of float
 * \skipline ----------------------------
 * std::vector<dataType> data = {255.23, -15.1, 429.5, 15.433}; // Create a vector of data
 * \skipline ----------------------------
 * std::string data = "test string"; // In case of string data
 * \skipline ----------------------------
 * parallelMMDT.readFromFPGA(data, dataSize, address);
 */
class ParallelMMDT {

public: 

    /**
     * @brief method to check the number of devices available
     * 
     * @param device_prefix - the type of device to search for eg. "xdma0_h2c"
     * @return uint32_t - number of devices
     */
    uint32_t countXDMADevices(const std::string& device_prefix) {
        struct dirent* entry;
        DIR* dp;
        uint32_t count = 0;

        dp = opendir("/dev");
        if (dp == nullptr) {
            perror("opendir");
            return 0;
        }

        while ((entry = readdir(dp))) {
            if (strncmp(entry->d_name, device_prefix.c_str(), device_prefix.size()) == 0) {
                count++;
            }
        }

        closedir(dp);

        std::cout << "Number of " << device_prefix << " channels: " << count << std::endl;
        return count;
    }


    /**
     * @brief Function to transfer array data from the host machine to FPGA
     * 
     * @tparam T - data type of the values being written
     * @param data - the array containing the data to be written
     * @param dataSize - number of values to be written to fpga
     * @param address - the starting address to which the data has to be written
     * @return int - notifies if the write suceeded or failed
     */
    template<typename T>
    int sendToFPGA(const std::vector<T>& data, uint64_t dataSize, uint64_t address) {
        if (data.size() < dataSize)
        {
            std::cerr << "Trying to write more values than that are present in the array " << std::endl;
            return -1;
        }

        if(printData){
            std::cout << "Input data: " ;
            dmaUtils.printArray(data);
        }

        std::cout << "H2C Transfer Begin.........." << std::endl;

        int num_devices = countXDMADevices(DEVICE_WRITE_PREFIX);
        if (num_devices < 1) {
            std::cerr << "No XDMA devices found." << std::endl;
            return -1;
        }

        std::vector<pthread_t> threads(num_devices);
        std::vector<ThreadData<T>> tdata(num_devices);
        std::vector<std::string> device_names(num_devices);
        uint32_t remainder = dataSize % num_devices;
        int rc;

        for (int i = 0; i < num_devices; ++i) {
            device_names[i] = "/dev/xdma0_h2c_" + std::to_string(i);
            size_t start = i * (dataSize / num_devices);
            size_t end = (i < num_devices - 1) ? start + (dataSize / num_devices) : start + (dataSize / num_devices) + remainder;
            tdata[i] = {std::vector<T>(data.begin() + start, data.begin() + end), address + (i * (dataSize / num_devices) * sizeof(T)), device_names[i]};
        }

        for (int i = 0; i < num_devices; ++i) {
            rc = pthread_create(&threads[i], nullptr, sendToFPGASingle<T>, (void*)&tdata[i]);
            if (rc) {
                std::cerr << "Error creating thread " << i << std::endl;
                return -1;
            }
        }

        for (int i = 0; i < num_devices; ++i) {
            void* status;
            rc = pthread_join(threads[i], &status);
            if (rc) {
                std::cerr << "Error joining thread " << i << std::endl;
                return -1;
            }
            if ((intptr_t)status < 0) {
                std::cerr << "Thread " << i << " failed" << std::endl;
                return -1;
            }
        }

        std::cout << "H2C Transfer Completed.........." << std::endl;

        return 0;
    }

    /**
     * @brief Overloaded function to transfer string data from the host machine to FPGA
     * 
     * @param data - the string containing data to be written
     * @param dataSize - number of characters to be written to fpga
     * @param address - the starting address to which the data has to be written
     * @return int - notifies if the write suceeded or failed
     */
    int sendToFPGA(const std::string& data, uint64_t dataSize, uint64_t address) {
        if (data.size() < dataSize)
        {
            std::cerr << "Trying to write more characters than that is provided " << std::endl;
            return -1;
        }

        if(printData){
            std::cout << "Input Data: " << data;
        }

        std::cout << "H2C Transfer Begin.........." << std::endl;

        int num_devices = countXDMADevices(DEVICE_WRITE_PREFIX);
        if (num_devices < 1) {
            std::cerr << "No XDMA devices found." << std::endl;
            return -1;
        }

        std::vector<pthread_t> threads(num_devices);
        std::vector<ThreadData<char>> tdata(num_devices);
        std::vector<std::string> device_names(num_devices);
        uint32_t remainder = dataSize % num_devices;
        int rc;

        for (int i = 0; i < num_devices; ++i) {
            device_names[i] = "/dev/xdma0_h2c_" + std::to_string(i);
            size_t start = i * (dataSize / num_devices);
            size_t end = (i < num_devices - 1) ? start + (dataSize / num_devices) : start + (dataSize / num_devices) + remainder;
            tdata[i] = {std::vector<char>(data.begin() + start, data.begin() + end), address + (i * (dataSize / num_devices) * sizeof(char)), device_names[i]};
        }

        for (int i = 0; i < num_devices; ++i) {
            rc = pthread_create(&threads[i], nullptr, sendToFPGASingle<char>, (void*)&tdata[i]);
            if (rc) {
                std::cerr << "Error creating thread " << i << std::endl;
                return -1;
            }
        }

        for (int i = 0; i < num_devices; ++i) {
            void* status;
            rc = pthread_join(threads[i], &status);
            if (rc) {
                std::cerr << "Error joining thread " << i << std::endl;
                return -1;
            }
            if ((intptr_t)status < 0) {
                std::cerr << "Thread " << i << " failed" << std::endl;
                return -1;
            }
        }

        std::cout << "H2C Transfer Completed.........." << std::endl;

        return 0;
    }


    /**
     * @brief Function to read array data from FPGA to the host machine
     * @tparam T - data type of the values being read
     * @param data - the output array where the data to be read is stored
     * @param dataSize - number of values to be read from fpga
     * @param address - the starting address from which the data has to be read
     * @return int - notifies if the write suceeded or failed
     */
    template<typename T>
    int readFromFPGA(std::vector<T>& data, uint64_t dataSize, uint64_t address) {
        std::cout << "C2H Transfer Begin.........." << std::endl;

        data.resize(dataSize);
        int num_devices = countXDMADevices(DEVICE_READ_PREFIX);
        if (num_devices < 1) {
            std::cerr << "No XDMA devices found." << std::endl;
            return -1;
        }

        std::vector<pthread_t> threads(num_devices);
        std::vector<ThreadData<T>> tdata(num_devices);
        std::vector<std::string> device_names(num_devices);
        uint32_t remainder = dataSize % num_devices;
        int rc;

        for (int i = 0; i < num_devices; ++i) {
            device_names[i] = "/dev/xdma0_c2h_" + std::to_string(i);
            size_t start = i * (dataSize / num_devices);
            size_t end = (i < num_devices - 1) ? start + (dataSize / num_devices) : start + (dataSize / num_devices) + remainder;
            tdata[i] = {std::vector<T>(data.begin() + start, data.begin() + end), address + (i * (dataSize / num_devices) * sizeof(T)), device_names[i]};
        }

        for (int i = 0; i < num_devices; ++i) {
            rc = pthread_create(&threads[i], nullptr, readFromFPGASingle<T>, (void*)&tdata[i]);
            if (rc) {
                std::cerr << "Error creating thread " << i << std::endl;
                return -1;
            }
        }

        for (int i = 0; i < num_devices; ++i) {
            void* status;
            rc = pthread_join(threads[i], &status);
            if (rc) {
                std::cerr << "Error joining thread " << i << std::endl;
                return -1;
            }
            if ((intptr_t)status < 0) {
                std::cerr << "Thread " << i << " failed" << std::endl;
                return -1;
            }
        }

        // Merge results from all threads into the main data array
        for (int i = 0; i < num_devices; ++i) {
            size_t start = i * (dataSize / num_devices);
            size_t end = (i < num_devices - 1) ? start + (dataSize / num_devices) : start + (dataSize / num_devices) + remainder;
            std::copy(tdata[i].data.begin(), tdata[i].data.end(), data.begin() + start);
        }

        if(printData){
            std::cout << "Output Data: ";
            dmaUtils.printArray(data);
        }
        
        std::cout << "C2H Transfer Completed.........." << std::endl;

        return 0;
    }

    /**
     * @brief Overloaded function to read string data from FPGA to the host machine
     * 
     * @param data - the output array where the data to be read is stored
     * @param dataSize - number of values to be read from fpga
     * @param address - the starting address from which the data has to be read
     * @return int - notifies if the write suceeded or failed
     */
    int readFromFPGA(std::string& data, uint64_t dataSize, uint64_t address) {
        std::cout << "C2H Transfer Begin.........." << std::endl;

        int num_devices = countXDMADevices(DEVICE_READ_PREFIX);
        if (num_devices < 1) {
            std::cerr << "No XDMA devices found." << std::endl;
            return -1;
        }

        std::vector<pthread_t> threads(num_devices);
        std::vector<ThreadData<char>> tdata(num_devices);
        std::vector<std::string> device_names(num_devices);
        uint32_t remainder = dataSize % num_devices;
        int rc;
        data.resize(dataSize);
        for (int i = 0; i < num_devices; ++i) {
            device_names[i] = "/dev/xdma0_c2h_" + std::to_string(i);
            size_t start = i * (dataSize / num_devices);
            size_t end = (i < num_devices - 1) ? start + (dataSize / num_devices) : start + (dataSize / num_devices) + remainder;
            tdata[i] = {std::vector<char>(data.begin() + start, data.begin() + end), address + (i * (dataSize / num_devices) * sizeof(char)), device_names[i]};
        }

        for (int i = 0; i < num_devices; ++i) {
            rc = pthread_create(&threads[i], nullptr, readFromFPGASingle<char>, (void*)&tdata[i]);
            if (rc) {
                std::cerr << "Error creating thread " << i << std::endl;
                return -1;
            }
        }

        for (int i = 0; i < num_devices; ++i) {
            void* status;
            rc = pthread_join(threads[i], &status);
            if (rc) {
                std::cerr << "Error joining thread " << i << std::endl;
                return -1;
            }
            if ((intptr_t)status < 0) {
                std::cerr << "Thread " << i << " failed" << std::endl;
                return -1;
            }
        }

        // Merge results from all threads into the main data array
        for (int i = 0; i < num_devices; ++i) {
            size_t start = i * (dataSize / num_devices);
            std::copy(tdata[i].data.begin(), tdata[i].data.end(), data.begin() + start);
        }

        if(printData){
            std::cout << "Output Data: " << data;
        }

        std::cout << "C2H Transfer Completed.........." << std::endl;

        return 0;
    }
    
};

#endif // MMDTPARALLELIZATION_H