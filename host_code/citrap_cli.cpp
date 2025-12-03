/**
 * @file citrap_cli.cpp
 * @brief Main entry point for CITRAP FPGA host control utility
 * 
 * Command-line interface for testing FPGA designs with:
 * - AXI DMA transfers (MM2S and S2MM)
 * - GPIO control for FPGA modules
 * - DDR and BRAM memory access
 * - Dynamic partial reconfiguration support
 * - FPGA programming via Vivado
 */

#include "fpga_config.h"
#include "fpga_device_ops.h"
#include "fpga_system.h"
#include "fpga_module_ops.h"
#include "xil_types.h"
#include <iostream>
#include <cstdio>
#include <getopt.h>

void print_usage(const char* prog_name) {
    printf("Usage: %s [OPTIONS]\n", prog_name);
    printf("FPGA device control and test utility\n\n");
    printf("Options:\n");
    printf("  -p, --program           Program FPGA (use 'static' or 'partial')\n");
    printf("  -s, --rescan            Rescan PCIe bus and reload XDMA driver\n");
    printf("  -r, --run-module        Run processing module\n");
    printf("  -R, --reconfig          Dynamic reconfiguration\n");
    printf("  -g, --read-gpio0        Read from GPIO0\n");
    printf("  -G, --write-gpio0       Write to GPIO0\n");
    printf("  -b, --read-bram         Read from BRAM\n");
    printf("  -B, --write-bram        Write to BRAM\n");
    printf("  -d, --read-ddr          Read from DDR\n");
    printf("  -D, --write-ddr         Write to DDR\n");
    printf("  -m, --send-dma          Send 64-word vector via AXI DMA0\n");
    printf("  -h, --help              Show this help message\n");
    printf("  -v, --version           Show version information\n\n");
    printf("Environment Variables:\n");
    printf("  XDMA_DRIVER_PATH        Path to XDMA driver directory\n");
    printf("  BITSTREAM_DIR           Path to bitstream directory (default: ../citrap/citrap.runs)\n");
    printf("  VIVADO_PATH             Path to Vivado executable (default: vivado)\n\n");
    printf("Examples:\n");
    printf("  %s --program static     Program FPGA with static design\n", prog_name);
    printf("  %s --program partial    Program partial reconfiguration module\n", prog_name);
    printf("  %s -r                   Run module\n", prog_name);
    printf("  %s --send-dma           Send DMA test vector\n", prog_name);
}

void print_version() {
    printf("FPGA Device Control Utility v1.0\n");
    printf("Built on %s %s\n", __DATE__, __TIME__);
}

int parse_and_execute(int argc, char* argv[]) {
    int opt;
    int option_index = 0;
    bool action_taken = false;
    
    static struct option long_options[] = {
        {"program",     no_argument, 0, 'p'},
        {"rescan",      no_argument, 0, 's'},
        {"run-module",  no_argument, 0, 'r'},
        {"reconfig",    no_argument, 0, 'R'},
        {"read-gpio0",  no_argument, 0, 'g'},
        {"write-gpio0", no_argument, 0, 'G'},
        {"read-bram",   no_argument, 0, 'b'},
        {"write-bram",  no_argument, 0, 'B'},
        {"read-ddr",    no_argument, 0, 'd'},
        {"write-ddr",   no_argument, 0, 'D'},
        {"send-dma",    no_argument, 0, 'm'},
        {"help",        no_argument, 0, 'h'},
        {"version",     no_argument, 0, 'v'},
        {0, 0, 0, 0}
    };

    if (argc == 1) {
        print_usage(argv[0]);
        return XST_SUCCESS;
    }

    while ((opt = getopt_long(argc, argv, "psrRgGbBdDmhv", long_options, &option_index)) != -1) {
        action_taken = true;
        
        switch (opt) {
        case 'p':
            std::cout << "\r\n--- Running programFPGA() --- \r\n" << std::endl;
            // Default to static bitstream, or use next argument if provided
            if (optind < argc) {
                programFPGA(argv[optind]);
            } else {
                programFPGA("static");
            }
            break;
            
        case 's':
            std::cout << "\r\n--- Running rescanPCIeBus() --- \r\n" << std::endl;
            rescanPCIeBus();
            break;
            
        case 'r':
            std::cout << "\r\n--- Running run_module() --- \r\n" << std::endl;
            run_module();
            break;
            
        case 'R':
            std::cout << "\r\n--- Running part_reconfig_Device() --- \r\n" << std::endl;
            part_reconfig_Device(DEV_SHUTDOWN_AXI_GPIO_CH1_ADDR);
            break;
            
        case 'g':
            std::cout << "\r\n--- Running ReadDATAfromDevice() --- \r\n" << std::endl;
            ReadDATAfromDevice(DEV_SHUTDOWN_AXI_GPIO_CH1_ADDR);
            break;
            
        case 'G':
            std::cout << "\r\n--- Running WriteDATAtoDevice() --- \r\n" << std::endl;
            WriteDATAtoDevice(DEV_SHUTDOWN_AXI_GPIO_CH1_ADDR, {0xF});
            break;
            
        case 'b':
            std::cout << "\r\n--- Running ReadDATAfromDevice() --- \r\n" << std::endl;
            ReadDATAfromDevice(DEV_AXI_BRAM0_CTRL_ADDR, 2);
            break;
            
        case 'B':
            std::cout << "\r\n--- Running WriteDATAtoDevice() --- \r\n" << std::endl;
            WriteDATAtoDevice(DEV_AXI_BRAM0_CTRL_ADDR, {0xFFFF'FFFF, 0xFFFF'0000}, 2);
            break;
            
        case 'd':
            std::cout << "\r\n--- Running ReadDATAfromDevice() --- \r\n" << std::endl;
            ReadDATAfromDevice(DEV_DDR_BASE_ADDR, 12);
            break;
            
        case 'D':
            std::cout << "\r\n--- Running WriteDATAtoDevice() --- \r\n" << std::endl;
            WriteDATAtoDevice(DEV_DDR_BASE_ADDR, {0xFF00'FF00, 0xFFFF'0000}, 2);
            break;
            
        case 'm':
            std::cout << "\r\n--- Sending 64-word vector via AXI DMA0 (MM2S) --- \r\n" << std::endl;
            sendVector64ViaAxiDma0();
            break;
            
        case 'h':
            print_usage(argv[0]);
            return XST_SUCCESS;
            
        case 'v':
            print_version();
            return XST_SUCCESS;
            
        case '?':
            // getopt_long already printed an error message
            print_usage(argv[0]);
            return XST_FAILURE;
            
        default:
            print_usage(argv[0]);
            return XST_FAILURE;
        }
    }

    if (action_taken) {
        printf("--- DONE: Exiting main() --- \r\n");
    }
    
    return XST_SUCCESS;
}

/**
 * @brief Main entry point
 * @param argc Argument count
 * @param argv Argument vector
 * @return XST_SUCCESS on success, XST_FAILURE on failure
 */
int main(int argc, char* argv[]) {
    return parse_and_execute(argc, argv);
}
