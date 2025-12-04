#!/usr/bin/env python3
"""
Clean Vivado Files
Removes all files starting with 'vivado' from the current directory
"""

from pathlib import Path
import sys

def clean_vivado_files(directory=None):
    """Delete all files starting with 'vivado' in the specified directory"""
    if directory is None:
        directory = Path.cwd()
    else:
        directory = Path(directory)
    
    if not directory.exists():
        print(f"Error: Directory {directory} does not exist")
        return 1
    
    deleted_files = []
    for item in directory.iterdir():
        if item.is_file() and (item.name.startswith("vivado") or item.name.startswith("hs_err_pid")):
            try:
                item.unlink()
                deleted_files.append(item.name)
                print(f"  Deleted: {item.name}")
            except Exception as e:
                print(f"  Warning: Could not delete {item.name}: {e}")
    
    if deleted_files:
        print(f"\nDeleted {len(deleted_files)} Vivado files")
    else:
        print("No Vivado files found to clean")
    
    return 0

if __name__ == "__main__":
    print("=" * 60)
    print("Cleaning Vivado Files")
    print("=" * 60)
    print()
    
    # Get directory from command line argument or use current directory
    directory = sys.argv[1] if len(sys.argv) > 1 else None
    
    if directory:
        print(f"Cleaning directory: {directory}")
    else:
        print(f"Cleaning current directory: {Path.cwd()}")
    print()
    
    exit_code = clean_vivado_files(directory)
    
    print()
    print("=" * 60)
    sys.exit(exit_code)
