/**
 * @file fpga_system.cpp
 * @brief Implementation of system-level FPGA management operations
 */

#include "fpga_system.h"
#include "fpga_config.h"
#include "fpga_device_ops.h"
#include <iostream>
#include <cstdlib>
#include <string>
#include <limits>
#include <unistd.h>

bool rescanPCIeBus() {
    // Reset PCI device to ensure clean state
    std::cout << "Removing PCI device...\n";
    system("echo '1' > /sys/bus/pci/devices/0000:03:00.0/remove");

    std::cout << "Rescanning PCI bus...\n";
    system("echo '1' > /sys/bus/pci/rescan");

    std::cout << "Loading XDMA driver...\n";
    std::string driver_cmd = "cd " + std::string(get_xdma_driver_path()) + " && sudo ./load_driver.sh";
    int ret = system(driver_cmd.c_str());
    if (ret != 0) {
        std::cerr << "Warning: Driver load failed. Make sure XDMA_DRIVER_PATH is set correctly." << std::endl;
    }

    return true;
}

void programFPGA(const std::string& bitstream) {
    rescanPCIeBus();
    WriteDATAtoDevice(DEV_SHUTDOWN_AXI_GPIO_CH1_ADDR, {0xFFFF'FFFF});

    sleep(1);
    
    // Construct bitstream path based on type
    std::string bitstreamPath;
    std::string bitstreamDir = get_bitstream_dir();
    
    if (bitstream == "static") {
        bitstreamPath = bitstreamDir + "/" + STATIC_BITSTREAM_PATH;
        std::cout << "Programming static design..." << std::endl;
    } else if (bitstream == "partial") {
        bitstreamPath = bitstreamDir + "/" + PARTIAL_BITSTREAM_PATH;
        std::cout << "Programming partial reconfiguration module..." << std::endl;
    } else {
        // Assume it's a full path
        bitstreamPath = bitstream;
    }
    
    std::string scriptPath = "program_fpga.tcl";
    std::string vivadoCmd = std::string(get_vivado_path()) + 
                           " -mode tcl -nolog -nojournal -source " + 
                           scriptPath + " -tclargs " + bitstreamPath + " " + FPGA_DEVICE;

    std::cout << "Executing: " << vivadoCmd << std::endl;
    int ret = std::system(vivadoCmd.c_str());
    if (ret != 0) {
        std::cerr << "Error: Vivado script execution failed with code " << ret << std::endl;
    } else {
        std::cout << "FPGA programmed successfully with " << bitstreamPath << std::endl;
    }

    WriteDATAtoDevice(DEV_SHUTDOWN_AXI_GPIO_CH1_ADDR, {0});

    rescanPCIeBus();
    std::cout << "FPGA reprogramming done" << std::endl;
}

bool part_reconfig_Device(uint64_t mem_addr) {
    WriteDATAtoDevice(mem_addr, {0xFFFFFFFF});

    /* user input required */
    char userInput = '\0';

    // Wait for user to press 'y' (case-insensitive)
    std::cout << std::endl;
    std::cout << "Upload bitstream for the reconfigurable partition now!" << std::endl;
    std::cout << "Then come back and press 'y' and '<Enter>' to continue..." << std::endl;

    // Keep asking until user presses 'y' or 'Y'
    while (true) {
        std::cin >> userInput;

        // Check if the user pressed 'y' or 'Y'
        if (userInput == 'y' || userInput == 'Y') {
            break;  // Exit loop if valid input
        } else {
            std::cout << "Invalid input. Press 'y' and '<Enter>'to continue..." << std::endl;
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');  // Clear buffer
        }
    }

    return true;
}
