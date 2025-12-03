#!/bin/bash
# Wrapper script to run the GUI with virtual environment

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if virtualenv exists
if [ ! -d "$SCRIPT_DIR/virtualenv" ]; then
    echo "Error: Virtual environment not found!"
    echo "Please run: ./quickstart.sh"
    exit 1
fi

# Activate virtual environment and run GUI
source "$SCRIPT_DIR/virtualenv/bin/activate"
python3 "$SCRIPT_DIR/create_project_gui.py"
