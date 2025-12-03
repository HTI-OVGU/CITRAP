#ifndef SINGLELINEMMDT_H
#define SINGLELINEMMDT_H

#include <fcntl.h>
#include <unistd.h> // for POSIX API functions
#include <cerrno> // for error codes
#include <iostream>
#include <vector>
#include <ctime>
#include <cstring> // for memcpy
#include <cstdint>
#include "ParallelMMDT.cpp"
#define SIZE_DEFAULT (1)
#define COUNT_DEFAULT (1)

/**
 * @brief Class provides functionality to do memory mapped data transfer to and from FPGA. 
 * The channel to use for the data transfer can be specified. It makes use of a single line.
 * \skipline ----------------------------
 * Example usage :
 * \skipline ----------------------------
 * SingleLineMMDT singleLineMMDT; // Instatiate the class variable.
 * \skipline ----------------------------
 * typedef float dataType; // Specify the desired data type in place of float
 * \skipline ----------------------------
 * std::vector<dataType> data = {255.23, -15.1, 429.5, 15.433}; // Create a array of data
 * \skipline ----------------------------
 * std::string data = "test string"; // In case of string data
 * \skipline ----------------------------
 * singleLineMMDT.sendToFPGA(data, dataSize, address, DEVICE_NAME_WRITE);
 */
class SingleLineMMDT {

public:

    /**
     * @brief Function to transfer array data from the host machine to FPGA
     * 
     * @tparam T - data type of the values being written
     * @param data - the array containing the data to be written
     * @param dataSize - number of values to be written to fpga
     * @param address - the starting address to which the data has to be written
     * @param devname - specify the device to use to write eg. "/dev/xdma0_h2c_0"
     * @return int - notifies if the write suceeded or failed
     */
    template <typename T>
    int sendToFPGA(const std::vector<T>& data, uint64_t dataSize, uint64_t address, const char* devname) {
        if (data.size() < dataSize)
        {
            std::cerr << "Trying to write more values than that are provided in the array " << std::endl;
            return -1;
        }
        if(printData) {
            std::cout << "Input Data: ";
            dmaUtils.printArray(data, dataSize);
        }
        char *buffer = nullptr;
        char *allocated = nullptr;
        uint64_t size = dataSize * sizeof(T);
        uint64_t count = COUNT_DEFAULT;
        size_t bytes_done = 0;
        int fpga_fd = open(devname, O_RDWR);

        if (fpga_fd < 0) {
            std::cerr << "unable to open device " << devname << ", " << fpga_fd << ".\n";
            perror("open device");
            return -EINVAL;
        }

        int rc = posix_memalign((void **)&allocated, 4096 /*alignment*/, size + 4096);
        if (rc != 0) {
            std::cerr << "OOM " << size + 4096 << ".\n";
            close(fpga_fd);
            return -ENOMEM;
        }

        buffer = allocated;
        memcpy(buffer, data.data(), size);
        if (printBufferData) {
            std::cout << "Send to FPGA Buffer: ";
            for (size_t i = 0; i < size; ++i) {
                printf("%02x ", (unsigned char)buffer[i]);
            }
            std::cout << std::endl;
        }

        for (uint64_t i = 0; i < count; i++) {
            rc = dmaUtils.writeFromBuffer(devname, fpga_fd, buffer, size, address);
            if (rc < 0) {
                // std::cerr << "Failed to write to buffer.\n";
                break;
            }
            bytes_done = rc;
            if (bytes_done < size) {
                std::cout << "#" << i << ": underflow " << bytes_done << "/" << size << ".\n";
            }
        }

        free(allocated);
        close(fpga_fd);

        return rc;
    }

    /**
     * @brief Overloaded function to transfer string data from the host machine to FPGA
     * 
     * @param data - the string containing data to be written
     * @param dataSize - number of characters to be written to fpga
     * @param address - the starting address to which the data has to be written
     * @param devname - specify the device to use to write eg. "/dev/xdma0_h2c_0"
     * @return int - notifies if the write suceeded or failed
     */
    int sendToFPGA(const std::string& data, uint64_t dataSize, uint64_t address, const char* devname) {
        if (data.size() < dataSize)
        {
            std::cerr << "Trying to write more characters than that is provided " << std::endl;
            return -1;
        }
        std::cout << "Input data: " << data;

        char *buffer = nullptr;
        char *allocated = nullptr;
        uint64_t size = dataSize;
        uint64_t count = COUNT_DEFAULT;
        size_t bytes_done = 0;
        int fpga_fd = open(devname, O_RDWR);

        if (fpga_fd < 0) {
            std::cerr << "unable to open device " << devname << ", " << fpga_fd << ".\n";
            perror("open device");
            return -EINVAL;
        }

        int rc = posix_memalign((void **)&allocated, 4096 /*alignment*/, size + 4096);
        if (rc != 0) {
            std::cerr << "OOM " << size + 4096 << ".\n";
            close(fpga_fd);
            return -ENOMEM;
        }

        buffer = allocated;
        memcpy(buffer, data.data(), size);
        
        if (printBufferData) {
            std::cout << "Send to FPGA Buffer: ";
            for (size_t i = 0; i < size; ++i) {
                printf("%02x ", (unsigned char)buffer[i]);
            }
            std::cout << std::endl;
        }

        for (uint64_t i = 0; i < count; i++) {
            rc = dmaUtils.writeFromBuffer(devname, fpga_fd, buffer, size, address);
            if (rc < 0) {
                // std::cerr << "Failed to write to buffer.\n";
                break;
            }
            bytes_done = rc;
            if (bytes_done < size) {
                std::cout << "#" << i << ": underflow " << bytes_done << "/" << size << ".\n";
            }
        }

        free(allocated);
        close(fpga_fd);

        return rc;
    }

    /**
     * @brief Function to read array data from FPGA to the host machine
     * @tparam T - data type of the values being read
     * @param data - the output array where the data to be read is stored
     * @param dataSize - number of values to be read from fpga
     * @param address - the starting address from which the data has to be read
     * @param devname - specify the device to use to read eg. "/dev/xdma0_c2h_0"
     * @return int - notifies if the write suceeded or failed
     */
    template <typename T>
    int readFromFPGA(std::vector<T>& data, uint64_t dataSize, uint64_t address, const char* devname) {
        ssize_t rc = 0;
        char *buffer = nullptr;
        char *allocated = nullptr;
        uint64_t size = dataSize * sizeof(T);
        int fpga_fd = open(devname, O_RDWR | O_TRUNC);

        data.resize(dataSize);
        if (fpga_fd < 0) {
            std::cerr << "unable to open device " << devname << ", " << fpga_fd << ".\n";
            perror("open device");
            return -EINVAL;
        }

        rc = posix_memalign((void **)&allocated, 4096 /*alignment*/, size + 4096);
        if (rc != 0) {
            std::cerr << "OOM " << size + 4096 << ".\n";
            close(fpga_fd);
            return -ENOMEM;
        }

        buffer = allocated;
        rc = dmaUtils.readToBuffer(devname, fpga_fd, buffer, size, address);
        if (rc < 0) {
            // std::cerr << "Failed to read from buffer.\n";
            free(allocated);
            close(fpga_fd);
            return rc;
        }

        if (printBufferData) {
            std::cout << "Total Bytes to read: " << size << std::endl;

            std::cout << "Read from FPGA: ";
            for (size_t i = 0; i < size; ++i) {
                printf("%02x ", (unsigned char)buffer[i]);
            }
            std::cout << std::endl;
        }

        memcpy(data.data(), buffer, size);

        free(allocated);
        close(fpga_fd);
        if(printData) {
            std::cout << "Output Data: ";
            dmaUtils.printArray(data);
        }
        return 0;
    }

    /**
     * @brief Overloaded function to read string data from FPGA to the host machine
     * 
     * @param data - the output array where the data to be read is stored
     * @param dataSize - number of values to be read from fpga
     * @param address - the starting address from which the data has to be read
     * @param devname - specify the device to use to read eg. "/dev/xdma0_c2h_0"
     * @return int - notifies if the write suceeded or failed
     */
    int readFromFPGA(std::string& data, size_t size , uint64_t address, const char* devname) {
        ssize_t rc = 0;
        char *buffer = nullptr;
        char *allocated = nullptr;
        int fpga_fd = open(devname, O_RDWR | O_TRUNC);

        if (fpga_fd < 0) {
            std::cerr << "unable to open device " << devname << ", " << fpga_fd << ".\n";
            perror("open device");
            return -EINVAL;
        }

        rc = posix_memalign((void **)&allocated, 4096 /*alignment*/, size + 4096);
        if (rc != 0) {
            std::cerr << "OOM " << size + 4096 << ".\n";
            close(fpga_fd);
            return -ENOMEM;
        }

        buffer = allocated;
        rc = dmaUtils.readToBuffer(devname, fpga_fd, buffer, size, address);
        if (rc < 0) {
            std::cerr << "Failed to read from buffer.\n";
            free(allocated);
            close(fpga_fd);
            return rc;
        }
        if (printBufferData) {
            std::cout << "Total Bytes to read: " << size << ":\n";

            std::cout << "Read from FPGA: ";
            for (size_t i = 0; i < size; ++i) {
                printf("%02x ", (unsigned char)buffer[i]);
            }
            std::cout << std::endl;
        }

        data.assign(buffer, size);

        free(allocated);
        close(fpga_fd);

        std::cout << "Output Data: " << data;

        return 0;
    }
};

#endif // SINGLELINEMMDT_H
