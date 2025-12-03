#!/usr/bin/env python3
"""
CITRAP Project Generator
Interactive script to create Vivado projects for different FPGA boards
"""

import os
import sys
import subprocess
import shutil
import re
import argparse
from pathlib import Path

def get_script_dir():
    """Get the directory where this script is located"""
    return Path(__file__).parent.resolve()

def get_available_boards():
    """Scan boards directory and return available configurations"""
    script_dir = get_script_dir()
    boards_dir = script_dir / "boards"
    
    if not boards_dir.exists():
        print(f"Error: boards directory not found at {boards_dir}")
        sys.exit(1)
    
    boards = {}
    for board_dir in boards_dir.iterdir():
        if board_dir.is_dir():
            board_name = board_dir.name
            boards[board_name] = {}
            
            # Check for design types (memory_mapped, streaming, etc.)
            for design_type_dir in board_dir.iterdir():
                if design_type_dir.is_dir():
                    design_type = design_type_dir.name
                    boards[board_name][design_type] = []
                    
                    # Check for configurations (1ch_ddr, 2ch_ddr, minimal, etc.)
                    for config_dir in design_type_dir.iterdir():
                        if config_dir.is_dir() and (config_dir / "fcp.tcl").exists():
                            boards[board_name][design_type].append(config_dir.name)
    
    return boards

def display_menu(options, title):
    """Display a numbered menu and get user selection"""
    print(f"\n{title}")
    print("=" * len(title))
    for i, option in enumerate(options, 1):
        print(f"{i}. {option}")
    
    while True:
        try:
            choice = input(f"\nSelect option (1-{len(options)}): ").strip()
            idx = int(choice) - 1
            if 0 <= idx < len(options):
                return options[idx]
            else:
                print(f"Please enter a number between 1 and {len(options)}")
        except ValueError:
            print("Please enter a valid number")
        except KeyboardInterrupt:
            print("\n\nOperation cancelled by user")
            sys.exit(0)

def copy_config_files(config_dir, citrap_dir):
    """
    Copy only required files for project creation to citrap directory
    Returns list of copied items
    """
    # Create citrap directory if it doesn't exist
    citrap_dir.mkdir(parents=True, exist_ok=True)
    
    copied_items = []
    
    # List of required files for project creation
    required_files = [
        'fcp.tcl',
        'top.vhd',
        'static_design.tcl',
        'dfx_test_partition.tcl'
    ]
    
    # Copy required files
    for filename in required_files:
        src_file = config_dir / filename
        if src_file.exists():
            dest = citrap_dir / filename
            shutil.copy2(src_file, dest)
            copied_items.append(filename)
            print(f"  Copied: {filename}")
        else:
            print(f"  Warning: {filename} not found, skipping")
    
    # Copy constraint files (partition.xdc, partition_constr.xdc, or board-specific .xdc)
    for item in config_dir.iterdir():
        if item.is_file() and item.suffix == '.xdc':
            dest = citrap_dir / item.name
            shutil.copy2(item, dest)
            copied_items.append(item.name)
            print(f"  Copied: {item.name}")
    
    # Copy debug_partition directory if it exists
    debug_partition_dir = config_dir / 'debug_partition'
    if debug_partition_dir.exists() and debug_partition_dir.is_dir():
        dest_debug_dir = citrap_dir / 'debug_partition'
        shutil.copytree(debug_partition_dir, dest_debug_dir, dirs_exist_ok=True)
        copied_items.append('debug_partition/ (directory)')
        print(f"  Copied: debug_partition/ (directory)")
    
    return copied_items


def update_fcp_tcl(fcp_path, script_dir, jobs=32):
    """
    Read fcp.tcl and replace /dummy_path/ placeholder with appropriate paths
    - Project location: /dummy_path/citrap -> script_dir/citrap
    - Source files: /dummy_path/ -> script_dir/citrap_tmp/
    - Jobs count: -jobs N -> -jobs {jobs}
    Returns the modified content
    """
    with open(fcp_path, 'r') as f:
        content = f.read()
    
    # First, replace /dummy_path/citrap with script_dir/citrap (project location)
    # This ensures the project is created in script_dir/citrap, not in citrap_tmp
    updated_content = content.replace('/dummy_path/citrap', str(script_dir) + '/citrap')
    
    # Then, replace remaining /dummy_path/ with script_dir/citrap_tmp/ (source files)
    updated_content = updated_content.replace('/dummy_path/', str(script_dir) + '/citrap_tmp/')
    
    # Replace -jobs N with the specified jobs count
    updated_content = re.sub(r'-jobs\s+\d+', f'-jobs {jobs}', updated_content)
    
    return updated_content

def append_bitstream_generation(config_dir, jobs=32):
    """
    Read generage_bitstream.tcl and update jobs count
    Returns the content to append to fcp_updated.tcl
    """
    bitstream_tcl = config_dir / "generage_bitstream.tcl"
    
    if not bitstream_tcl.exists():
        print(f"Warning: {bitstream_tcl} not found, skipping bitstream generation")
        return ""
    
    with open(bitstream_tcl, 'r') as f:
        content = f.read()
    
    # Replace -jobs N with the specified jobs count
    updated_content = re.sub(r'-jobs\s+\d+', f'-jobs {jobs}', content)
    
    return "\n" + updated_content

def run_vivado_tcl(tcl_content, citrap_dir):
    """Execute Vivado with the given TCL content"""
    temp_tcl = citrap_dir / "fcp_updated.tcl"
    
    # Write updated TCL file
    with open(temp_tcl, 'w') as f:
        f.write(tcl_content)
    
    print(f"\n{'='*60}")
    print(f"Launching Vivado...")
    print(f"Working directory: {citrap_dir}")
    print(f"TCL script: {temp_tcl}")
    print(f"{'='*60}\n")
    
    try:
        # Run Vivado in batch mode from citrap directory
        cmd = ['vivado', '-mode', 'batch', '-source', 'fcp_updated.tcl']
        result = subprocess.run(cmd, cwd=citrap_dir, check=False)
        
        if result.returncode == 0:
            print(f"\n{'='*60}")
            print(f"SUCCESS: Project created successfully!")
            print(f"Project location: {citrap_dir.parent / 'citrap'}")
            print(f"{'='*60}\n")
        else:
            print(f"\n{'='*60}")
            print(f"WARNING: Vivado exited with code {result.returncode}")
            print(f"Check the log files in {citrap_dir} for details")
            print(f"{'='*60}\n")
    
    except FileNotFoundError:
        print("\nError: Vivado not found in PATH")
        print("Please ensure Vivado is installed and added to your PATH")
        print("Run: source /tools/Xilinx/Vivado/2024.2/settings64.sh")
        sys.exit(1)
    except KeyboardInterrupt:
        print("\n\nOperation cancelled by user")
        sys.exit(0)

def get_jobs_count():
    """Prompt user for number of jobs"""
    while True:
        try:
            jobs_input = input("\nEnter number of jobs/threads (1-128, default 32): ").strip()
            if not jobs_input:
                return 32  # Default value
            jobs = int(jobs_input)
            if 1 <= jobs <= 128:
                return jobs
            else:
                print("Please enter a number between 1 and 128")
        except ValueError:
            print("Please enter a valid number")
        except KeyboardInterrupt:
            print("\n\nOperation cancelled by user")
            sys.exit(0)

def get_bitstream_generation():
    """Prompt user whether to generate bitstream"""
    while True:
        try:
            response = input("\nGenerate bitstream? (y/n, default n): ").strip().lower()
            if not response or response == 'n':
                return False
            elif response == 'y':
                return True
            else:
                print("Please enter 'y' or 'n'")
        except KeyboardInterrupt:
            print("\n\nOperation cancelled by user")
            sys.exit(0)

def main():
    # Parse command-line arguments (kept for potential future use)
    parser = argparse.ArgumentParser(
        description='CITRAP Project Generator - Create Vivado projects for different FPGA boards',
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    args = parser.parse_args()
    
    print("="*60)
    print("CITRAP Project Generator")
    print("="*60)
    
    # Get available boards
    boards = get_available_boards()
    
    if not boards:
        print("Error: No board configurations found")
        sys.exit(1)
    
    # Select board
    board_names = sorted(boards.keys())
    selected_board = display_menu(board_names, "Select FPGA Board")
    
    # Select design type
    design_types = sorted(boards[selected_board].keys())
    selected_design_type = display_menu(design_types, f"Select Design Type for {selected_board}")
    
    # Select configuration
    configs = sorted(boards[selected_board][selected_design_type])
    selected_config = display_menu(configs, f"Select Configuration for {selected_board}/{selected_design_type}")
    
    # Get jobs count from user
    jobs_count = get_jobs_count()
    
    # Get bitstream generation preference from user
    generate_bitstream = get_bitstream_generation()
    
    # Construct path to configuration directory
    script_dir = get_script_dir()
    config_dir = script_dir / "boards" / selected_board / selected_design_type / selected_config
    fcp_path = config_dir / "fcp.tcl"
    
    if not fcp_path.exists():
        print(f"Error: fcp.tcl not found at {fcp_path}")
        sys.exit(1)
    
    # Define citrap directory as citrap_tmp
    citrap_dir = script_dir / "citrap_tmp"

    
    # Show summary
    print(f"\n{'='*60}")
    print("Configuration Summary:")
    print(f"  Board: {selected_board}")
    print(f"  Design Type: {selected_design_type}")
    print(f"  Configuration: {selected_config}")
    print(f"  Source Directory: {config_dir}")
    print(f"  Target Directory: {citrap_dir}")
    print(f"  Jobs (threads): {jobs_count}")
    print(f"  Generate Bitstream: {'Yes' if generate_bitstream else 'No'}")
    print(f"{'='*60}")
    
    # Confirm
    confirm = input("\nProceed with project creation? (y/n): ").strip().lower()
    if confirm != 'y':
        print("Operation cancelled")
        sys.exit(0)
    
    # Always clean citrap_tmp directory before starting
    if citrap_dir.exists():
        print(f"\nDeleting all files from {citrap_dir.name} directory...")
        shutil.rmtree(citrap_dir)
        print(f"  All files deleted successfully")
    
    # Also clean the citrap project directory if it exists
    citrap_project_dir = script_dir / "citrap"
    if citrap_project_dir.exists():
        print(f"\nDeleting existing {citrap_project_dir.name} project directory...")
        shutil.rmtree(citrap_project_dir)
        print(f"  Project directory deleted successfully")
    
    print(f"Creating fresh {citrap_dir.name} directory...")

    
    # Copy configuration files and directories
    print(f"\nCopying configuration files to {citrap_dir}...")
    copied_items = copy_config_files(config_dir, citrap_dir)
    print(f"Copied {len(copied_items)} items")

    
    # Update fcp.tcl with actual paths and jobs count
    print(f"\nUpdating fcp.tcl with actual paths and jobs count ({jobs_count})...")
    fcp_content = update_fcp_tcl(citrap_dir / "fcp.tcl", script_dir, jobs_count)
    
    # Append bitstream generation if requested
    if generate_bitstream:
        print(f"\nAppending bitstream generation commands...")
        bitstream_content = append_bitstream_generation(config_dir, jobs_count)
        if bitstream_content:
            fcp_content += bitstream_content
            print("Bitstream generation commands added")
    
    # Write updated fcp.tcl
    with open(citrap_dir / "fcp.tcl", 'w') as f:
        f.write(fcp_content)
    print("Updated fcp.tcl")
    
    # Run Vivado
    run_vivado_tcl(fcp_content, citrap_dir)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nOperation cancelled by user")
        sys.exit(0)
