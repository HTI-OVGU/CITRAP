/**
 * @file fpga_system.h
 * @brief System-level FPGA management operations
 */

#ifndef FPGA_SYSTEM_H
#define FPGA_SYSTEM_H

#include <string>
#include <cstdint>

/**
 * @brief Rescan PCIe bus and reload XDMA driver
 * @return true on success, false on failure
 */
bool rescanPCIeBus();

/**
 * @brief Program the FPGA with a bitstream file
 * @param bitstream Bitstream identifier ("static", "partial") or full path
 */
void programFPGA(const std::string& bitstream);

/**
 * @brief Perform dynamic partial reconfiguration
 * @param mem_addr Memory address for reconfiguration control
 * @return true on success, false on failure
 */
bool part_reconfig_Device(uint64_t mem_addr);

#endif // FPGA_SYSTEM_H
