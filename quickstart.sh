#!/bin/bash
# Quick Start Script for CITRAP Project Generator
# This script automatically sets up the virtual environment and all dependencies

set -e  # Exit on error

echo "=========================================="
echo "CITRAP Project Generator - Quick Start"
echo "=========================================="
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for Python 3
if ! command_exists python3; then
    echo "✗ Python 3 is not installed!"
    echo "Please install Python 3 first."
    exit 1
fi

echo "✓ Python 3 found: $(python3 --version)"
echo ""

# Check if virtualenv exists, if not create it
if [ ! -d "virtualenv" ]; then
    echo "Virtual environment not found. Creating..."
    echo "Running: make"
    echo ""
    make
    echo ""
    echo "✓ Virtual environment created successfully"
else
    echo "✓ Virtual environment already exists"
fi

echo ""

# Check if all packages are installed in virtualenv
echo "Verifying Python packages in virtual environment..."
source ./virtualenv/bin/activate

MISSING_PACKAGES=0
while IFS= read -r package; do
    # Skip empty lines and comments
    [[ -z "$package" || "$package" =~ ^# ]] && continue
    
    # Extract package name (before any version specifier)
    pkg_name=$(echo "$package" | sed 's/[>=<].*//' | tr '[:upper:]' '[:lower:]')
    
    if ! python3 -c "import $pkg_name" 2>/dev/null; then
        echo "✗ Missing package: $pkg_name"
        MISSING_PACKAGES=1
    fi
done < requirements.txt

if [ $MISSING_PACKAGES -eq 1 ]; then
    echo ""
    echo "Some packages are missing. Reinstalling..."
    ./virtualenv/bin/pip install -Ur requirements.txt
    echo ""
    echo "✓ All packages installed"
else
    echo "✓ All required packages are installed"
fi

echo ""

# Check if tkinter is available (system package)
echo "Checking for tkinter (system package)..."
if python3 -c "import tkinter" 2>/dev/null; then
    echo "✓ tkinter is installed"
    TKINTER_OK=1
else
    echo "✗ tkinter is NOT installed"
    TKINTER_OK=0
fi

echo ""
echo "=========================================="
echo "Setup Summary"
echo "=========================================="
echo "✓ Virtual environment: Ready"
echo "✓ Python packages: Installed"

if [ $TKINTER_OK -eq 1 ]; then
    echo "✓ tkinter: Installed"
else
    echo "✗ tkinter: NOT installed (required for GUI)"
fi

echo ""

if [ $TKINTER_OK -eq 0 ]; then
    echo "=========================================="
    echo "ACTION REQUIRED: Install tkinter"
    echo "=========================================="
    echo ""
    echo "tkinter is a system package and must be installed separately."
    echo "Run one of the following commands based on your OS:"
    echo ""
    echo "  Ubuntu/Debian:"
    echo "    sudo apt-get update"
    echo "    sudo apt-get install python3-tk"
    echo ""
    echo "  Fedora/RHEL:"
    echo "    sudo dnf install python3-tkinter"
    echo ""
    echo "  Arch Linux:"
    echo "    sudo pacman -S tk"
    echo ""
    echo "After installing tkinter, run this script again."
    echo "=========================================="
    echo ""
    
    # Ask if user wants to continue anyway
    read -p "Continue without GUI support? (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled. Please install tkinter and run again."
        exit 1
    fi
    echo ""
    echo "Continuing with CLI-only support..."
fi

echo ""
echo "=========================================="
echo "Environment Ready!"
echo "=========================================="
echo ""
echo "Available commands:"
if [ $TKINTER_OK -eq 1 ]; then
    echo "  1. GUI version:  ./run_gui.sh  (or: python3 create_project_gui.py)"
else
    echo "  1. GUI version:  ./run_gui.sh  (requires tkinter)"
fi
echo "  2. CLI version:  ./run_cli.sh  (or: python3 create_project.py)"
echo ""
echo "Note: Use the wrapper scripts (run_gui.sh, run_cli.sh) for automatic"
echo "      virtual environment activation, or activate manually first:"
echo "      source virtualenv/bin/activate"
echo ""
echo "To clean and rebuild everything:"
echo "  make clean && make"
echo ""
echo "=========================================="
echo ""

# Spawn a new shell with the virtual environment activated
echo "=========================================="
echo "Spawning new shell with virtual environment activated..."
echo "Type 'exit' to return to your original shell."
echo "=========================================="
exec bash --rcfile <(echo "if [ -f ~/.bashrc ]; then source ~/.bashrc; fi; source ./virtualenv/bin/activate")
