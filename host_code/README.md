# FPGA Host Code Examples

Generic host code for FPGA development using AXI DMA, GPIO, and memory-mapped I/O. This code provides a command-line interface for testing and controlling FPGA designs.

## Features

- **AXI DMA Transfers**: Memory-to-Stream (MM2S) and Stream-to-Memory (S2MM) operations
- **GPIO Control**: Read/write GPIO registers for FPGA module control
- **Memory Access**: Direct DDR and BRAM read/write operations via XDMA
- **FPGA Programming**: Program static and partial reconfiguration bitstreams via Vivado
- **Dynamic Partial Reconfiguration**: Support for DFX workflows
- **PCIe Management**: Rescan PCIe bus and reload XDMA drivers

## Prerequisites

### Hardware
- FPGA board with PCIe interface (e.g., Xilinx ZC706, AU250)
- PCIe connection to host system

### Software
- Linux host system with PCIe support
- Xilinx Vivado (for FPGA programming)
- XDMA drivers installed ([Xilinx DMA IP Drivers](https://github.com/Xilinx/dma_ip_drivers))
- XDMA_DRIVER_PATH environment variable set to XDMA driver directory or XDMA driver directory must be cloned next to the CITRAP project folder
- GCC/G++ compiler

### System Packages
```bash
sudo apt-get install build-essential
```

## Quick Start

### 1. Build the Project

```bash
cd host_code
make
```

This creates the executable at `build/citrap_cli`.

### 3. Using Makefile Targets

The Makefile provides convenient targets with pre-configured environment variables:

```bash
# Build and run with default environment variables
make run ARGS="--help"

# Build and run with sudo (preserves environment variables)
make run-sudo ARGS="-b -B"

# Override environment variables
make run XDMA_DRIVER_PATH=/custom/path ARGS="--program static"

# Just build without running
make
```

**Default environment variables in Makefile:**
- `XDMA_DRIVER_PATH` = `../../../dma_ip_drivers-master/XDMA/linux-kernel/tests`
- `BITSTREAM_DIR` = `../citrap/citrap.runs`
- `VIVADO_PATH` = `/tools/Xilinx/Vivado/2024.2/bin/vivado`

### 4. Set Environment Variables (Optional - Alternative Method)

If not using Makefile targets, you can manually export environment variables:

```bash
# Path to XDMA driver directory
export XDMA_DRIVER_PATH="/path/to/dma_ip_drivers/XDMA/linux-kernel/tests"

# Path to bitstream directory (default: ../citrap/citrap.runs)
export BITSTREAM_DIR="../citrap/citrap.runs"

# Path to Vivado executable (default: vivado in PATH)
export VIVADO_PATH="/tools/Xilinx/Vivado/2024.2/bin/vivado"
```

### 5. Run Examples

```bash
# Show help
./build/citrap_cli --help

# Program FPGA with static design
./build/citrap_cli --program static

# Program partial reconfiguration module
./build/citrap_cli --program partial

# Rescan PCIe bus and reload driver
./build/citrap_cli --rescan

# Run processing module
./build/citrap_cli --run-module

# Send test data via AXI DMA
./build/citrap_cli --send-dma
```

## Command-Line Options
These options are used for testing and controlling the FPGA design to prove that it works. You may create your own options for your own design.
| Option | Long Form | Description |
|--------|-----------|-------------|
| `-p` | `--program` | Program FPGA (use 'static' or 'partial') |
| `-s` | `--rescan` | Rescan PCIe bus and reload XDMA driver |
| `-r` | `--run-module` | Run processing module |
| `-R` | `--reconfig` | Dynamic reconfiguration |
| `-g` | `--read-gpio0` | Read from GPIO0 |
| `-G` | `--write-gpio0` | Write to GPIO0 |
| `-b` | `--read-bram` | Read from BRAM |
| `-B` | `--write-bram` | Write to BRAM |
| `-d` | `--read-ddr` | Read from DDR |
| `-D` | `--write-ddr` | Write to DDR |
| `-m` | `--send-dma` | Send 64-word vector via AXI DMA0 |
| `-h` | `--help` | Show help message |
| `-v` | `--version` | Show version information |

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `XDMA_DRIVER_PATH` | Path to XDMA driver directory | `/path/to/dma_ip_drivers/XDMA/linux-kernel/tests` |
| `BITSTREAM_DIR` | Path to bitstream directory | `../citrap/citrap.runs` |
| `VIVADO_PATH` | Path to Vivado executable | `vivado` (from PATH) |

## Usage Examples

### Memory-Mapped Data Transfer (MMDT)

For detailed examples of memory-mapped data transfer using XDMA, see [MMDT.md](MMDT.md).

#### Example: Write and Read DDR Memory

```bash
# Write test data to DDR
./build/citrap_cli --write-ddr

# Read data back from DDR
./build/citrap_cli --read-ddr
```

#### Example: BRAM Access

```bash
# Write to BRAM
./build/citrap_cli --write-bram

# Read from BRAM
./build/citrap_cli --read-bram
```

### AXI DMA Operations

```bash
# Send 64-word test vector via AXI DMA (MM2S)
./build/citrap_cli --send-dma
```

### GPIO Control

```bash
# Read GPIO0 status
./build/citrap_cli --read-gpio0

# Write to GPIO0
./build/citrap_cli --write-gpio0

# Read GPIO2 status
./build/citrap_cli --read-gpio2

# Write to GPIO2
./build/citrap_cli --write-gpio2
```

### FPGA Programming

```bash
# Program static design
./build/citrap_cli --program static

# Program partial reconfiguration module
./build/citrap_cli --program partial

# Program with custom bitstream path
./build/citrap_cli --program /path/to/custom.bit
```

## Configuration

### Memory Addresses

The following memory addresses are defined in `citrap_cli.cpp` and can be modified for your design:
All configuration parameters are centralized in `fpga_config.h` for easy customization.

### FPGA Device Type

The target FPGA device is configured in `fpga_config.h`:

```cpp
// FPGA device type - modify this for your target device
// This value you can find in the Vivado hw_manager after programming static design
#define FPGA_DEVICE "xc7z045_1"
```

**How to find your device identifier:**
1. Open Vivado Hardware Manager
2. Connect to your FPGA board
3. The device name will be shown in the Hardware window (e.g., `xc7z045_1`, `xcvu9p_0`, etc.)
4. Use this exact string in the `FPGA_DEVICE` define

**Example device identifiers:**
- `xc7z045_1` - Zynq-7000 SoC (ZC706 board)
- `xcu250_0` - Virtex UltraScale+ (AU250 board)

This value is passed to `program_fpga.tcl` when programming the FPGA via Vivado.

### Bitstream Paths

Configure bitstream paths in `fpga_config.h`:

```cpp
// Bitstream paths for CITRAP project
#define STATIC_BITSTREAM_PATH "impl_1/top.bit"
#define PARTIAL_BITSTREAM_PATH "child_0_impl_1/dfx_test_partition_wrapper_i_debug_partition_partial.bit"
```

These paths are relative to the `BITSTREAM_DIR` environment variable (default: `../citrap/citrap.runs`).

### Memory Addresses

All memory-mapped addresses are defined in `fpga_config.h` and can be modified for your FPGA design:

#### AXI DMA
```cpp
#define AXI_DMA_0_BASEADDR 0x00001000
```

#### GPIO Addresses
```cpp
#define DEV_SHUTDOWN_AXI_GPIO_CH1_ADDR  0x8000'0000   // Shutdown GPIO
```

#### BRAM Addresses
```cpp
#define DEV_AXI_BRAM0_CTRL_ADDR     0x0000'0000
```

#### DDR Addresses
```cpp
#define DEV_DDR_BASE_ADDR           0x14'0000'0000
```

**Note:** These addresses must match your FPGA design's address map. Check your Vivado Address Editor for the correct values.

### Environment Variables

You can override default paths using environment variables (defined in `fpga_config.h`):

| Variable | Default | Purpose |
|----------|---------|---------|
| `XDMA_DRIVER_PATH` | `../../dma_ip_drivers-master/XDMA/linux-kernel/tests` | Path to XDMA driver |
| `BITSTREAM_DIR` | `../citrap/citrap.runs` | Bitstream directory |
| `VIVADO_PATH` | `/tools/Xilinx/Vivado/2024.2/bin/vivado` | Vivado executable |

## Troubleshooting

### XDMA Driver Not Found

```bash
# Set the correct path to XDMA drivers
export XDMA_DRIVER_PATH="/path/to/dma_ip_drivers/XDMA/linux-kernel/tests"

# Rescan PCIe bus
./build/citrap_cli --rescan
```

### Vivado Not Found

```bash
# Add Vivado to PATH
source /tools/Xilinx/Vivado/2024.2/settings64.sh

# Or set VIVADO_PATH
export VIVADO_PATH="/tools/Xilinx/Vivado/2024.2/bin/vivado"
```

### Permission Denied for PCIe Operations

```bash
# Run with sudo for PCIe operations
sudo ./build/citrap_cli --rescan
```

### Bitstream Not Found

```bash
# Check bitstream directory
ls -la ../citrap/citrap.runs/impl_1/
ls -la ../citrap/citrap.runs/child_0_impl_1/

# Or set custom bitstream directory
export BITSTREAM_DIR="/path/to/your/bitstreams"
```

## Project Structure

```
host_code/
├── citrap_cli.cpp              # Main application entry point with CLI
├── fpga_config.h               # Configuration constants and defines
├── fpga_device_ops.cpp/.h      # Device I/O operations (memory, DMA)
├── fpga_system.cpp/.h          # System management (PCIe, FPGA programming)
├── fpga_module_ops.cpp/.h      # Application-specific workflows
├── AxiDmaUtils.cpp/.h          # AXI DMA utility functions
├── DMAUtils.h                  # DMA helper utilities
├── SingleLineMMDT.cpp          # Single-channel MMDT implementation
├── ParallelMMDT.cpp            # Multi-channel MMDT implementation
├── xaxidma/                    # Xilinx AXI DMA driver files
│   ├── xaxidma*.cpp/.h
├── program_fpga.tcl            # Vivado TCL script for programming
├── Makefile                    # Build configuration
├── README.md                   # This file
└── MMDT.md                     # Memory-mapped data transfer examples
```

## Notes

- **xparameters.h**: Generated by Vivado during design creation. Do not modify manually.
- **xaxidma_g.cpp**: Must be updated based on xparameters.h configurations.
- **Maximum Transfer Length**: As of December 2025, the maximum AXI DMA transfer length is 26-bit width (67,108,863 bytes).

## License

See [LICENSE](LICENSE) file for details.

## Contributing

This is a generic template for FPGA host code development. Modify the memory addresses, GPIO mappings, and bitstream paths according to your specific FPGA design.