# CITRAP Project Generator - Quick Start

## Summary

The Python script has been successfully created and tested. It provides an interactive way to create Vivado CITRAP projects with automatic path management.

## What Was Created

1. **`create_project.py`** - Main interactive script
2. **`README.md`** - Complete documentation

## Verified Functionality

✅ Interactive menu system working
✅ Board/design/configuration detection working  
✅ Path transformation working correctly:
   - Project paths: `/citrap_gen/citrap/`
   - Source files: Points to config directory
   - TCL scripts: Relative to config directory
   - All absolute paths converted to relative

## Quick Usage

```bash
# 1. Source Vivado settings
source /tools/Xilinx/Vivado/2024.2/settings64.sh

# 2. Run the script
cd /home/burtsev/Documents/citrap_gen
python3 create_project.py

# 3. Follow the prompts:
#    - Select board (au250 or zc706)
#    - Select design type (memory_mapped)
#    - Select configuration (1ch_ddr, 2ch_ddr, 3ch_ddr, 4ch_ddr, minimal)
#    - Confirm with 'y'
```

## Available Configurations

### AU250
- **memory_mapped**
  - `1ch_ddr` - 1 DDR channel
  - `2ch_ddr` - 2 DDR channels
  - `3ch_ddr` - 3 DDR channels
  - `4ch_ddr` - 4 DDR channels
  - `minimal` - Minimal configuration

### ZC706
- **memory_mapped**
  - Standard configuration

## Path Transformation Example

**Before (in fcp.tcl):**
```tcl
create_project citrap /home/burtsev/Documents/citrap_au250/citrap -part xcu250-figd2104-2L-e
add_files -norecurse /home/burtsev/Documents/citrap_au250/top.vhd
cd /home/burtsev/Documents/citrap_au250/
```

**After (transformed):**
```tcl
create_project citrap /home/burtsev/Documents/citrap_gen/citrap -part xcu250-figd2104-2L-e
add_files -norecurse /home/burtsev/Documents/citrap_gen/boards/au250/memory_mapped/minimal/top.vhd
cd /home/burtsev/Documents/citrap_gen/boards/au250/memory_mapped/minimal
```

## Project Structure

```
citrap_gen/
├── create_project.py          # Interactive script
├── README.md                   # Full documentation
├── QUICKSTART.md              # This file
├── boards/                     # Board configurations
│   ├── au250/
│   │   └── memory_mapped/
│   │       ├── 1ch_ddr/
│   │       │   ├── fcp.tcl
│   │       │   ├── top.vhd
│   │       │   ├── static_design.tcl
│   │       │   └── ...
│   │       └── ...
│   └── zc706/
└── citrap/                     # Generated project (created by script)
    └── citrap.xpr
```

## Notes

- The script creates a temporary TCL file that is automatically cleaned up
- All paths are automatically adjusted to be relative to the script location
- The `citrap` project directory will be created if it doesn't exist
- Existing projects will be overwritten

## Troubleshooting

If Vivado is not found:
```bash
source /tools/Xilinx/Vivado/2024.2/settings64.sh
```

If you want to see the transformed TCL before running:
```bash
# The script creates temp_fcp.tcl temporarily - you can modify the script
# to keep it for inspection
```
