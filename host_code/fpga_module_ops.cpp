/**
 * @file fpga_module_ops.cpp
 * @brief Implementation of application-specific FPGA module operations
 */

#include "fpga_module_ops.h"
#include "fpga_config.h"
#include "fpga_device_ops.h"
#include <iostream>
#include <iomanip>
#include <vector>

bool run_module() {
    const int t_len = 10;

    // 1) create random values
    std::vector<uint32_t> datavec = generateRandomVector(t_len);
    for (size_t i = 0; i < datavec.size(); ++i) {
        std::cout << std::hex << std::setw(8) << std::setfill('0') 
                  << std::uppercase << datavec[i] << " ";
    }
    std::cout << std::endl;

    // 2) transfer values to DRAM
    WriteDATAtoDevice(DEV_DDR_BASE_ADDR, datavec, t_len);
    ReadDATAfromDevice(DEV_DDR_BASE_ADDR, t_len);

    // 3) set GPIO to START 'processing module'
    WriteDATAtoDevice(DEV_SHUTDOWN_AXI_GPIO_CH1_ADDR, {0x1});

    // 4) check if GPIO says : wait for module 'DONE'
    // (placeholder for future implementation)

    // 5) transfer results
    ReadDATAfromDevice(DEV_AXI_BRAM0_CTRL_ADDR, t_len);

    return true;
}
