#ifndef DMAUTILS_H
#define DMAUTILS_H

#include <fcntl.h>
#include <unistd.h> // for POSIX API functions
#include <cerrno> // for error codes
#include <iostream>
#include <cstring> // for memcpy
#include <cstdint>
#include <vector>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <linux/types.h>
#include <poll.h>
#include <chrono>
#include <random>
#include <limits>

#define RW_MAX_SIZE 0x7ffff000

/**
 * @brief Provides helper classes to write/read data to/from FPGA/buffer
 * 
 */
class DMAUtils {
    public:
       
       /**
        * @brief Function to copy data from file into the buffer
        * 
        * @param fname - device name eg. /dev/xdma0_c2h_0
        * @param fd - file descriptor to read from
        * @param buffer - buffer where the data read to be stored
        * @param size - how many bytes of data to read
        * @param base - starting address to read data from
        * @return ssize_t - return success or failure
        */
       ssize_t readToBuffer(const char *fname, int fd, char *buffer, uint64_t size, uint64_t base) {
        ssize_t rc;
        uint64_t count = 0;
        char *buf = buffer;
        off_t offset = base;
        int loop = 0;

        while (count < size) {
            ssize_t bytes = size - count;

            if (bytes > RW_MAX_SIZE)
                bytes = RW_MAX_SIZE;

            if (offset) {
                rc = lseek(fd, offset, SEEK_SET);
                if (rc != offset) {
                    fprintf(stderr, "%s, seek off 0x%lx != 0x%lx.\n", fname, rc, offset);
                    perror("seek file");
                    return -EIO;
                }
            }

            rc = read(fd, buf, bytes);
            if (rc < 0) {
                fprintf(stderr, "%s, read 0x%lx @ 0x%lx failed %ld.\n", fname, bytes, offset, rc);
                perror("read file");
                return -EIO;
            }

            count += rc;
            if (rc != bytes) {
                fprintf(stderr, "%s, read underflow 0x%lx/0x%lx @ 0x%lx.\n", fname, rc, bytes, offset);
                break;
            }

            buf += bytes;
            offset += bytes;
            loop++;
        }

        if (count != size && loop)
            fprintf(stderr, "%s, read underflow 0x%lx/0x%lx.\n", fname, count, size);
        return count;
    }

       /**
        * @brief Function to copy data from buffer into the file i.e. FPGA
        * 
        * @param fname - device name eg. /dev/xdma0_h2c_0
        * @param fd - file descriptor to read from
        * @param buffer - buffer containing data to be written to device
        * @param size - how many bytes of data to be written
        * @param base - starting address to write data from
        * @return ssize_t - return success or failure
        */
    ssize_t writeFromBuffer(const char *fname, int fd, const char *buffer, uint64_t size, uint64_t base) {
        ssize_t rc;
        uint64_t count = 0;
        const char *buf = buffer;
        off_t offset = base;
        int loop = 0;

        while (count < size) {
            ssize_t bytes = size - count;

            if (bytes > RW_MAX_SIZE)
                bytes = RW_MAX_SIZE;

            if (offset) {
                rc = lseek(fd, offset, SEEK_SET);
                if (rc != offset) {
                    fprintf(stderr, "%s, seek off 0x%lx != 0x%lx.\n", fname, rc, offset);
                    perror("seek file");
                    return -EIO;
                }
            }

            rc = write(fd, buf, bytes);
            if (rc < 0) {
                fprintf(stderr, "%s, write 0x%lx @ 0x%lx failed %ld.\n", fname, bytes, offset, rc);
                perror("write file");
                return -EIO;
            }

            count += rc;
            if (rc != bytes) {
                fprintf(stderr, "%s, write underflow 0x%lx/0x%lx @ 0x%lx.\n", fname, rc, bytes, offset);
                break;
            }
            buf += bytes;
            offset += bytes;

            loop++;
        }

        if (count != size && loop)
            fprintf(stderr, "%s, write underflow 0x%lx/0x%lx.\n", fname, count, size);

        return count;
    }

    /**
     * @brief Print elements of a vector
     * 
     * @tparam T - data type of the values
     * @param data - vector to be printed
     * @param dataSize - size of the data to be printed (optional)
     */
    template<typename T>
    void printArray(const std::vector<T>& data, size_t dataSize = 0) {
        size_t size = dataSize ? dataSize : data.size();
        for(size_t i = 0; i < size; i++)
        {
            std::cout << data[i] << " ";
        }
        std::cout << std::endl;
    }

    /**
     * @brief Read a value from a memory-mapped register
     * 
     * @param dma_mmap - pointer to the memory-mapped DMA region
     * @param offset - offset of the register to read from
     * @return uint32_t - value read from the register
     */
    uint32_t readRegister(void* dma_mmap, uint32_t offset) {
        return *reinterpret_cast<volatile uint32_t*>(static_cast<char*>(dma_mmap) + offset);
    }

    /**
     * @brief Write a value to a memory-mapped register
     * 
     * @param dma_mmap - pointer to the memory-mapped DMA region
     * @param offset - offset of the register to write to
     * @param value - value to write to the register
     */
    void writeRegister(void* dma_mmap, uint32_t offset, uint32_t value) {
        *reinterpret_cast<volatile uint32_t*>(static_cast<char*>(dma_mmap) + offset) = value;
    }
    
    /**
     * @brief Generate a vector of random integers of specified size in megabytes - FOR TEST PURPOSE
     * 
     * @param dataSizeMB - size of the vector in megabytes
     * @return std::vector<int> - vector containing random integers
     */
    std::vector<int> generateTestIntegerVector(size_t dataSizeMB) {
        const size_t target_size_bytes = dataSizeMB * 1024 * 1024; // 200 MB
        const size_t int_size = sizeof(int);
        const size_t num_integers = target_size_bytes / int_size;

        std::vector<int> data;
        data.reserve(num_integers);

        // Use a random number generator for filling the vector
        unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
        std::default_random_engine generator(seed);
        std::uniform_int_distribution<int> distribution(std::numeric_limits<int>::min(), std::numeric_limits<int>::max());

        for (size_t i = 0; i < num_integers; ++i) {
            data.push_back(distribution(generator));
        }

        return data;
    }

    /**
     * @brief Template function to generate random data -- FOR TEST PURPOSE
     * 
     * @tparam T - type of data to be generated
     * @param data - output array to which the generated data is written
     * @param min_value - minimum range for value generation
     * @param max_value - maximum range for value generation
     * @return std::enable_if<std::is_integral<T>::value, void>::type 
     */
    template<typename T>
    void generateRandomData(std::vector<T>& data, size_t dataSize, T min_value, T max_value) {
        srand(time(NULL));
        data.resize(dataSize);
        for (auto& val : data) {
            val = static_cast<T>((rand() % (max_value - min_value + 1)) + min_value);
        }
    }
};

#endif // DMAUTILS_H
