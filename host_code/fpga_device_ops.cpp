/**
 * @file fpga_device_ops.cpp
 * @brief Implementation of low-level FPGA device I/O operations
 */

#include "fpga_device_ops.h"
#include "SingleLineMMDT.cpp"
#include "xdma_config.h"
#include "AxiDmaUtils.h"
#include "xparameters.h"
#include "xdebug.h"
#include <iostream>
#include <iomanip>
#include <random>
#include <cstdio>

// Global AXI DMA instance
XAxiDma AxiDma;

std::vector<uint32_t> generateRandomVector(size_t size) {
    std::vector<uint32_t> datavec;
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<uint32_t> dist(0, 0xFFFFFFFF);

    for (size_t i = 0; i < size; ++i) {
        uint32_t randomWord = dist(gen);
        datavec.push_back(randomWord);
    }
    return datavec;
}

bool ReadDATAfromDevice(uint64_t mem_addr, uint64_t num_val) {
    SingleLineMMDT singleLineMMDT;
    std::vector<dataType> data;

    int rc = singleLineMMDT.readFromFPGA(
                data, num_val, mem_addr, XDMA_DEVICE_NAME_READ);
    printf("\n" "readFromFPGA() mem_addr 0x%llX\r\n", (unsigned long long)mem_addr);
    
    if (rc < 0) {
        std::cerr << "readFromFPGA failed.\n";
    } else {
        std::cout << "Read: " << num_val << " ";
        for (size_t i = 0; i < num_val; ++i) {
            std::cout << std::hex << std::setw(8) << std::setfill('0') 
                      << std::uppercase << data[i] << " ";
        }
    }
    std::cout << std::endl;

    return true;
}

bool WriteDATAtoDevice(uint64_t mem_addr, std::vector<uint32_t> data, uint64_t num_val) {
    SingleLineMMDT singleLineMMDT;

    int rc = singleLineMMDT.sendToFPGA(
                data, num_val, mem_addr, XDMA_DEVICE_NAME_WRITE);
    printf("\n" "sendToFPGA() mem_addr 0x%llX\r\n", (unsigned long long)mem_addr);
    
    if (rc < 0) {
        std::cerr << "sendToFPGA failed ------------------------" << mem_addr << std::endl;
        return false;
    }
    std::cout << std::endl;

    return true;
}

bool sendVector64ViaAxiDma0() {
    // 1) Prepare data 1..64 (32-bit words)
    std::vector<uint32_t> vec;
    vec.reserve(64);
    for (uint32_t i = 1; i <= 64; ++i) vec.push_back(i);

    // 2) Write data to device memory for DMA source
    if (!WriteDATAtoDevice(DEV_DDR_BASE_ADDR, vec, vec.size())) {
        std::cerr << "WriteDATAtoDevice failed for DMA source" << std::endl;
        return false;
    }

    // 3) Configure AXI DMA at AXI_DMA_0_BASEADDR (simple mode, polling)
    int status = AxiDmaUtils::Configure(&AxiDma, AXI_DMA_0_BASEADDR);
    if (status != XST_SUCCESS) {
        std::cerr << "AxiDma configure failed" << std::endl;
        return false;
    }

    // 4) Kick MM2S transfer and wait for completion
    const std::size_t byteCount = vec.size() * sizeof(uint32_t);
    std::cout << "Starting AXI DMA0 MM2S transfer of " << byteCount << " bytes..." << std::endl;

    status = AxiDmaUtils::SendMm2S(&AxiDma, (UINTPTR)DEV_DDR_BASE_ADDR, byteCount);
    if (status != XST_SUCCESS) {
        std::cerr << "AxiDma MM2S transfer failed" << std::endl;
        return false;
    }

    status = AxiDmaUtils::RecvS2Mm(&AxiDma, (UINTPTR)(DEV_DDR_BASE_ADDR + 0x10000), byteCount);

    std::cout << "AXI DMA0 MM2S sent " << byteCount << " bytes from 0x" 
              << std::hex << DEV_DDR_BASE_ADDR << std::dec << std::endl;
    return true;
}

int XAxiDma_Configuration(UINTPTR BaseAddress) {
    XAxiDma_Config *CfgPtr;
    int Status;
    printf("\r\n--- Entering XAxiDma_SimplePoll() --- \r\n");

    /* Initialize the XAxiDma device. */
    CfgPtr = XAxiDma_LookupConfigBaseAddr(BaseAddress);
    if (!CfgPtr) {
        printf("No config found for %ld\r\n", BaseAddress);
        return XST_FAILURE;
    }

    Status = XAxiDma_CfgInitialize(&AxiDma, CfgPtr);
    if (Status != XST_SUCCESS) {
        printf("Initialization failed %d\r\n", Status);
        return XST_FAILURE;
    }

    if (XAxiDma_HasSg(&AxiDma)) {
        printf("Device configured as SG mode \r\n");
        return XST_FAILURE;
    }

    /* Disable interrupts, we use polling mode */
    XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
    XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);

    return XST_SUCCESS;
}
