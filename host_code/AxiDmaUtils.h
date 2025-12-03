#ifndef AXI_DMA_UTILS_H
#define AXI_DMA_UTILS_H

#include "xaxidma.h"
#include "xdebug.h"
#include <cstddef>
#include <cstdint>

namespace AxiDmaUtils {

// Configure an AXI DMA instance at the provided base address (simple mode, polling)
int Configure(XAxiDma* instance, UINTPTR baseAddress);

// Start a simple transfer on the MM2S (DMA_TO_DEVICE) channel and poll for completion
int SendMm2S(XAxiDma* instance, UINTPTR srcAddr, std::size_t byteCount, int timeoutIters = 1000000);

// Start a simple transfer on the S2MM (DEVICE_TO_DMA) channel and poll for completion
int RecvS2Mm(XAxiDma* instance, UINTPTR dstAddr, std::size_t byteCount, int timeoutIters = 1000000);

} // namespace AxiDmaUtils

#endif // AXI_DMA_UTILS_H
