/**
 * @file AxiDmaUtils.h
 * @brief Utility functions for AXI DMA operations in simple (non-scatter-gather) mode
 * 
 * This file provides a simplified interface to configure and operate the Xilinx
 * AXI DMA IP core in simple mode with polling for completion.
 */

#ifndef AXI_DMA_UTILS_H
#define AXI_DMA_UTILS_H

#include "xaxidma.h"
#include "xdebug.h"
#include <cstddef>
#include <cstdint>

/**
 * @namespace AxiDmaUtils
 * @brief Namespace containing utility functions for AXI DMA operations
 */
namespace AxiDmaUtils {

/**
 * @brief Configure an AXI DMA instance at the provided base address
 * 
 * Initializes the AXI DMA core in simple (non-scatter-gather) mode with
 * interrupts disabled for polling-based operation.
 * 
 * @param instance Pointer to XAxiDma instance to configure
 * @param baseAddress Physical base address of the AXI DMA peripheral
 * @return XST_SUCCESS on success, XST_FAILURE on failure
 */
int Configure(XAxiDma* instance, UINTPTR baseAddress);

/**
 * @brief Start a Memory-Mapped to Stream (MM2S) transfer and wait for completion
 * 
 * Initiates a DMA transfer from system memory to the AXI Stream interface
 * (DMA_TO_DEVICE direction) and polls for completion.
 * 
 * @param instance Pointer to configured XAxiDma instance
 * @param srcAddr Physical address of source buffer in memory
 * @param byteCount Number of bytes to transfer
 * @param timeoutIters Maximum number of polling iterations before timeout (default: 1000000)
 * @return XST_SUCCESS on success, XST_FAILURE on timeout or error
 */
int SendMm2S(XAxiDma* instance, UINTPTR srcAddr, std::size_t byteCount, int timeoutIters = 1000000);

/**
 * @brief Start a Stream to Memory-Mapped (S2MM) transfer and wait for completion
 * 
 * Initiates a DMA transfer from the AXI Stream interface to system memory
 * (DEVICE_TO_DMA direction) and polls for completion.
 * 
 * @param instance Pointer to configured XAxiDma instance
 * @param dstAddr Physical address of destination buffer in memory
 * @param byteCount Number of bytes to receive
 * @param timeoutIters Maximum number of polling iterations before timeout (default: 1000000)
 * @return XST_SUCCESS on success, XST_FAILURE on timeout or error
 */
int RecvS2Mm(XAxiDma* instance, UINTPTR dstAddr, std::size_t byteCount, int timeoutIters = 1000000);

} // namespace AxiDmaUtils

#endif // AXI_DMA_UTILS_H
