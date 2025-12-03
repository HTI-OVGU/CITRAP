/**
 * @file fpga_device_ops.h
 * @brief Low-level FPGA device I/O operations
 */

#ifndef FPGA_DEVICE_OPS_H
#define FPGA_DEVICE_OPS_H

#include <vector>
#include <cstdint>
#include "xaxidma.h"
#include "xil_types.h"
#include "fpga_config.h"

// Global AXI DMA instance
extern XAxiDma AxiDma;

/**
 * @brief Generate a random vector of uint32_t values
 * @param size Number of random values to generate
 * @return Vector of random uint32_t values
 */
std::vector<uint32_t> generateRandomVector(size_t size);

/**
 * @brief Read data from FPGA device memory
 * @param mem_addr Memory address to read from
 * @param num_val Number of values to read (default: 1)
 * @return true on success, false on failure
 */
bool ReadDATAfromDevice(uint64_t mem_addr, uint64_t num_val = 1);

/**
 * @brief Write data to FPGA device memory
 * @param mem_addr Memory address to write to
 * @param data Vector of data to write
 * @param num_val Number of values to write (default: 1)
 * @return true on success, false on failure
 */
bool WriteDATAtoDevice(uint64_t mem_addr, std::vector<uint32_t> data, uint64_t num_val = 1);

/**
 * @brief Send a 64-word test vector via AXI DMA (MM2S)
 * @return true on success, false on failure
 */
bool sendVector64ViaAxiDma0();

/**
 * @brief Configure AXI DMA for simple polling mode
 * @param BaseAddress Base address of the AXI DMA instance
 * @return XST_SUCCESS on success, XST_FAILURE on failure
 */
int XAxiDma_Configuration(UINTPTR BaseAddress);

#endif // FPGA_DEVICE_OPS_H
