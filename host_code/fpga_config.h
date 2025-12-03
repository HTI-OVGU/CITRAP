/**
 * @file fpga_config.h
 * @brief Configuration constants and environment variables for FPGA host code
 */

#ifndef FPGA_CONFIG_H
#define FPGA_CONFIG_H

#include <cstdlib>
#include <cstdint>

// ============================================================================
// ENVIRONMENT VARIABLE HELPERS
// ============================================================================

// Get XDMA driver path from environment or use default
static inline const char* get_xdma_driver_path() {
    const char* env_path = std::getenv("XDMA_DRIVER_PATH");
    return env_path ? env_path : "../../dma_ip_drivers-master/XDMA/linux-kernel/tests";
}

// Get bitstream directory from environment or use CITRAP project default
static inline const char* get_bitstream_dir() {
    const char* env_path = std::getenv("BITSTREAM_DIR");
    return env_path ? env_path : "../citrap/citrap.runs";
}

// Get Vivado path from environment or use default
static inline const char* get_vivado_path() {
    const char* env_path = std::getenv("VIVADO_PATH");
    return env_path ? env_path : "/tools/Xilinx/Vivado/2024.2/bin/vivado";
}

// ============================================================================
// BITSTREAM CONFIGURATION
// ============================================================================

// Bitstream paths for CITRAP project
#define STATIC_BITSTREAM_PATH "impl_1/top.bit"
#define PARTIAL_BITSTREAM_PATH "child_0_impl_1/dfx_test_partition_wrapper_i_debug_partition_partial.bit"

// FPGA device type - modify this for your target device
// This value you can find in the Vivado hw_manager after programming static design
#define FPGA_DEVICE "xc7z045_1"

// ============================================================================
// MEMORY ADDRESS DEFINITIONS
// ============================================================================

// AXI DMA base address
#define AXI_DMA_0_BASEADDR 0x00001000

// GPIO addresses
#define DEV_SHUTDOWN_AXI_GPIO_CH1_ADDR  0x8000'0000   // Shutdown-GPIO Addr

// BRAM addresses
#define DEV_AXI_BRAM0_CTRL_ADDR     0x0000'0000

// DDR addresses
#define DEV_DDR_BASE_ADDR           0x14'0000'0000
#ifndef DDR_BASE_ADDR
#warning CHECK FOR THE VALID DDR ADDRESS IN XPARAMETERS.H, DEFAULT SET TO 0x01000000
#define MEM_BASE_ADDR    0x14'0000'0000
#else
#define MEM_BASE_ADDR    (DDR_BASE_ADDR + 0x1000000)
#endif

#define TX_BUFFER_BASE   (MEM_BASE_ADDR + 0x00000000)
#define RX_BUFFER_BASE   (MEM_BASE_ADDR + 0x00000000)
#define RX_BUFFER_HIGH   (MEM_BASE_ADDR + 0x3FFFFFFF)

// ============================================================================
// TYPE DEFINITIONS
// ============================================================================

typedef uint32_t dataType;

#endif // FPGA_CONFIG_H
