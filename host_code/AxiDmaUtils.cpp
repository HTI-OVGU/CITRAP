#include "AxiDmaUtils.h"
#include "xaxidma.h"
#include <cstdio>

namespace AxiDmaUtils {

int Configure(XAxiDma* instance, UINTPTR baseAddress) {
    XAxiDma_Config* cfg = XAxiDma_LookupConfigBaseAddr(baseAddress);
    if (!cfg) {
        std::printf("AxiDma: No config found for base 0x%lX\n", (unsigned long)baseAddress);
        return XST_FAILURE;
    }
    int status = XAxiDma_CfgInitialize(instance, cfg);
    if (status != XST_SUCCESS) {
        std::printf("AxiDma: CfgInitialize failed %d\n", status);
        return status;
    }
    if (XAxiDma_HasSg(instance)) {
        std::printf("AxiDma: Device configured in SG mode (expected simple)\n");
        return XST_FAILURE;
    }
    XAxiDma_IntrDisable(instance, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
    XAxiDma_IntrDisable(instance, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);
    return XST_SUCCESS;
}

static int waitFor(XAxiDma* instance, int dir, int timeoutIters) {
    while (timeoutIters--) {
        if (!XAxiDma_Busy(instance, dir)) return XST_SUCCESS;
    }
    return XST_FAILURE;
}

int SendMm2S(XAxiDma* instance, UINTPTR srcAddr, std::size_t byteCount, int timeoutIters) {
    int status = XAxiDma_SimpleTransfer(instance, (UINTPTR)srcAddr, (int)byteCount, XAXIDMA_DMA_TO_DEVICE);
    if (status != XST_SUCCESS) return status;
    return waitFor(instance, XAXIDMA_DMA_TO_DEVICE, timeoutIters);
}

int RecvS2Mm(XAxiDma* instance, UINTPTR dstAddr, std::size_t byteCount, int timeoutIters) {
    int status = XAxiDma_SimpleTransfer(instance, (UINTPTR)dstAddr, (int)byteCount, XAXIDMA_DEVICE_TO_DMA);
    if (status != XST_SUCCESS) return status;
    return waitFor(instance, XAXIDMA_DEVICE_TO_DMA, timeoutIters);
}

} // namespace AxiDmaUtils
