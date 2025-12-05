# CITRAP: A Rapid-Prototyping Infrastructure for FPGAs


CITRAP is an open-source, lightweight, and fully configurable infrastructure template designed to streamline and accelerate the development of FPGA-based accelerators. It acts as a minimal “base design” for hardware prototyping, taking care of the essential interfaces:PCIe, DRAM controllers, DMA engines, AXI interconnects, and native debugging tools. So developers can focus entirely on their Unit Under Test (UUT) rather than rebuilding infrastructure for every project.

Unlike heavy frameworks such as XRT, TAPASCo, or OpenCPI, CITRAP introduces no additional abstraction layers. Instead, it preserves full visibility into the hardware through native Vivado tools (ILA/VIO) and keeps the developer in direct control of the synthesis and debugging flow. The result is a significantly faster iteration cycle with complete access to internal signals, something that high-abstraction frameworks cannot offer.


## Motivation

Since FPGA prototyping has become increasingly complex when project requires PCIe connectivity, DRAM infrastructure, DMA paths, memory-mapped and streaming interfaces, and proper debugging. Building this infrastructure repeatedly consumes enormous time and slows down the research and development cycle.

Furthermore, PCIe-based accelerators suffer from long reprogramming cycles: systems can require full host reboots to recover PCIe links after FPGA reconfiguration. Existing frameworks attempt to hide this complexity, but at the cost of limited signal visibility, slow build processes, restrictive runtime environments, and reduced control over low-level hardware behavior.

CITRAP directly addresses these issues.

It provides:

- a static infrastructure partition that is synthesized once and never touched again,
- a DFX-based reconfigurable user partition for rapid iteration,
- native access to onboard debugging cores (ILA/VIO),
- seamless PCIe operation without rescans or root privileges,
- and a bare-metal workflow using standard Vivado tools.

This combination enables a development experience that is both highly efficient and fully transparent.

## Features

CITRAP offers:
- Support for full native Vivado debugging (ILA, VIO) inside the reconfigurable region
- Static infrastructure synthesized once: PCIe XDMA, DRAM controller, AXI interconnect, MicroBlaze/ARM (optional)
- Dynamic Function eXchange (DFX) with safe isolation between static and user logic partitions
- Low overhead: ~4% LUT usage on Alveo U250 (~4× less than XRT shells)
- C++ XDMA wrapper library for simple host–FPGA communication
- AXI4-MM and AXI4-Stream support (via XDMA and AXI DMA)
- GUI-based configuration script to generate board-specific static designs
- Full control, no proprietary runtime, no hidden layers, no lost timing visibility

CITRAP enables engineers to build FPGA accelerators with short iteration cycle while keeping full access to the underlying hardware. It is a good foundation for research, prototyping, teaching, and any scenario requiring fast, repeatable, and transparent FPGA development.

## Getting Started

To create a new Vivado project using the CITRAP generator (GUI or CLI), please refer to the detailed documentation in the **Host Code** folder:


[**Go to Project Generator & Host Code Documentation**](host_code/README.md)

### Quick Summary

1. **Setup Environment**:

   ```bash
   ./quickstart.sh
   ```

2. **Run Project Generator**:

   ```bash
   # GUI Version
   ./run_gui.sh


   # CLI Version
   ./run_cli.sh
   ```

For detailed instructions on prerequisites, configuration, and using the generated host code, see [host_code/README.md](host_code/README.md).
# CITRAP Project Generator

Interactive tools to create Vivado projects for different FPGA boards.

## Prerequisites

### System Dependencies

Install tkinter (required for GUI):

**Ubuntu/Debian:**
```bash
sudo apt-get install python3-tk
```
### Python Dependencies

All Python dependencies are managed via virtual environment.

## Quick Start

### Automated Setup (Recommended)

The easiest way to get started is to use the automated quickstart script:

```bash
./quickstart.sh
```

This script will automatically:
- ✅ Check for Python 3 installation
- ✅ Create virtual environment if it doesn't exist
- ✅ Install all Python dependencies from `requirements.txt`
- ✅ Verify all packages are installed correctly
- ✅ Check for tkinter (system package)
- ✅ Provide clear instructions if tkinter is missing
- ✅ Activate the virtual environment
- ✅ Display available commands

**Note:** If tkinter is not installed, the script will:
1. Show installation instructions for your OS
2. Ask if you want to continue with CLI-only support
3. Allow you to proceed or exit to install tkinter first

### Manual Setup (Alternative)

If you prefer to set up manually:

#### 1. Setup Virtual Environment

```bash
make
```

This will:
- Create a `virtualenv` directory
- Install all packages from `requirements.txt`

#### 2. Activate Virtual Environment

```bash
source virtualenv/bin/activate
```

#### 3. Run the Application

**Recommended: Use wrapper scripts (automatic virtualenv activation)**

```bash
# GUI version
./run_gui.sh

# CLI version
./run_cli.sh
```

**Alternative: Manual activation**

```bash
# Activate environment first
source virtualenv/bin/activate

# Then run the application
python3 create_project_gui.py  # GUI version
python3 create_project.py      # CLI version
```

**Note:** The wrapper scripts (`run_gui.sh`, `run_cli.sh`) automatically activate the virtual environment, so you don't need to run `source virtualenv/bin/activate` first.

## GUI Features

### CITRAP Project Generator GUI (`create_project_gui.py`)

- **Vivado Settings Path**: Configure path to Vivado settings64.sh (default: `/tools/Xilinx/Vivado/2024.2/settings64.sh`)
- **Board Selection**: Choose from available FPGA boards (e.g., AU250)
- **Design Type**: Select design type (e.g., memory_mapped, streaming)
- **Configuration**: Pick specific configuration (e.g., 3ch_ddr, 4ch_ddr)
- **Automatic Setup**: 
  - Sources Vivado settings automatically
  - Cleans previous project directories
  - Copies required files
  - Updates paths in TCL scripts
  - Launches Vivado in batch mode

## Key Features

- **Recursive Copy**: Copies all files and subdirectories (including `debug_partition/`)
- **Temporary Directory**: Uses `citrap_tmp/` as working directory
- **Auto-Cleanup**: Deletes `citrap_tmp/` and `citrap/` before each run
- **Placeholder Replacement**: Replaces `/dummy_path/` with actual paths
- **GUI Interface**: Modern ttkbootstrap-themed interface
- **CLI Interface**: Interactive command-line option

## How It Works

1. **Select Configuration**: Interactive menus for board/design/configuration
2. **Clean Workspace**: Deletes existing `citrap_tmp/` directory
3. **Recursive Copy**: Copies all files and folders from selected configuration
4. **Update Paths**: Replaces `/dummy_path/` with actual `citrap_tmp/` path
5. **Run Vivado**: Executes Vivado in batch mode

## Directory Structure

```
citrap_gen/
├── create_project.py
├── boards/
│   ├── au250/
│   │   └── memory_mapped/
│   │       ├── 1ch_ddr/
│   │       │   ├── fcp.tcl
│   │       │   ├── top.vhd
│   │       │   ├── static_design.tcl
│   │       │   ├── dfx_test_partition.tcl
│   │       │   ├── partition.xdc
│   │       │   └── debug_partition/
│   │       │       ├── dbg_partition.bd
│   │       │       └── dbg_partition_wrapper.vhd
│   │       └── ...
│   └── zc706/
└── citrap_tmp/                    # Working directory (auto-created/cleaned)
    ├── fcp.tcl                    # With /dummy_path/ replaced
    ├── fcp_updated.tcl
    ├── top.vhd
    ├── static_design.tcl
    ├── dfx_test_partition.tcl
    ├── partition.xdc
    ├── debug_partition/           # Recursively copied
    │   ├── dbg_partition.bd
    │   └── dbg_partition_wrapper.vhd
    └── citrap/                    # Vivado project (created by fcp.tcl)
```

## Configuration File Format

All `fcp.tcl` files use `/dummy_path/` placeholder:

```tcl
create_project citrap /dummy_path/citrap -part xcu250-figd2104-2L-e
add_files -norecurse /dummy_path/top.vhd
import_files -norecurse /dummy_path/debug_partition/dbg_partition.bd
cd /dummy_path/
source static_design.tcl
```

## Example Output

```
============================================================
CITRAP Project Generator
============================================================

Select FPGA Board
=================
1. au250
2. zc706

Select option (1-2): 1

...

Cleaning existing citrap_tmp directory...

Copying configuration files to /home/burtsev/Documents/citrap_gen/citrap_tmp...
  Copied: fcp.tcl
  Copied: top.vhd
  Copied: static_design.tcl
  Copied: dfx_test_partition.tcl
  Copied: partition.xdc
  Copied: debug_partition/ (directory)
Copied 6 items

Updating fcp.tcl with actual paths...
Updated fcp.tcl

============================================================
Launching Vivado...
Working directory: /home/burtsev/Documents/citrap_gen/citrap_tmp
============================================================
```

## Benefits

✅ **Complete Copy**: All files and subdirectories included  
✅ **Clean Workspace**: Fresh start every run  
✅ **Simple Paths**: Just use `/dummy_path/` everywhere  
✅ **Portable**: Works regardless of installation location  
✅ **Easy to Debug**: All files in one temporary directory

## Makefile Targets

- `make` or `make venv` - Create virtual environment and install dependencies
- `make clean` - Remove virtual environment and Python cache files
- `make clean-vivado` - Remove all Vivado log files (files starting with "vivado")
- `make clean-all` - Clean everything including citrap, citrap_tmp directories, and Vivado files

## Cleaning Vivado Files

Vivado creates log files (vivado.log, vivado.jou, etc.) in the working directory. You can clean these files:

**Using Makefile:**
```bash
make clean-vivado
```

**Using standalone script:**
```bash
python3 clean_vivado.py          # Clean current directory
python3 clean_vivado.py /path    # Clean specific directory
```

**Note:** The GUI automatically cleans Vivado files before creating a new project.

## Troubleshooting

### "No module named 'tkinter'"

Install system tkinter package (see Prerequisites section above):
```bash
sudo apt-get install python3-tk
```

### "Vivado not found"

Make sure the Vivado settings path is correct in the GUI, or source it manually:
```bash
source /tools/Xilinx/Vivado/2024.2/settings64.sh
```

### Virtual Environment Issues

Clean and recreate:
```bash
make clean
make
source virtualenv/bin/activate
```

## Requirements

### Python Packages (installed via `make`)
- ttkbootstrap

### System Packages
- python3-tk (tkinter)
- Vivado 2024.1 or 2024.2

# Citation

If you use CITRAP, please cite us:

```bibtex
@inproceedings{citrap,
    author = {Vitalii Burtsev, Martin Wilhelm, Nandhish Thathanur Rajappa, Ilia Sozutov, Thilo Pionteck},
    title = {CITRAP: A Configurable Infrastructure Template for Rapid Prototyping on FPGAs},
    booktitle = { },
    year = {},
    pages = {},
    url = {},
    publisher = {}
}
```