#!/usr/bin/env python3
"""
CITRAP Project Generator - GUI Version
Interactive GUI to create Vivado projects for different FPGA boards
"""

import tkinter as tk
from tkinter import ttk
from tkinter import messagebox
import subprocess
import os
import shutil
import re
from pathlib import Path
from ttkbootstrap import Style

class CITRAPProjectGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("CITRAP Project Generator")
        self.gui_width = 800
        self.gui_height = 1000
        self.root.geometry(f"{self.gui_width}x{self.gui_height}")
        
        # Get script directory
        self.script_dir = Path(__file__).parent.resolve()
        
        # Initialize variables
        self.boards_data = {}
        self.selected_board = tk.StringVar()
        self.selected_design_type = tk.StringVar()
        self.selected_config = tk.StringVar()
        self.vivado_settings_path = tk.StringVar(value="/tools/Xilinx/Vivado/2024.2/settings64.sh")
        self.jobs_count = tk.IntVar(value=32)
        self.generate_bitstream = tk.BooleanVar(value=False)
        
        # Load available boards
        self.load_boards()
        
        # Setup GUI
        self.setup_gui()
        
    def load_boards(self):
        """Scan boards directory and return available configurations"""
        boards_dir = self.script_dir / "boards"
        
        if not boards_dir.exists():
            messagebox.showerror("Error", f"Boards directory not found at {boards_dir}")
            return
        
        for board_dir in boards_dir.iterdir():
            if board_dir.is_dir():
                board_name = board_dir.name
                self.boards_data[board_name] = {}
                
                # Check for design types
                for design_type_dir in board_dir.iterdir():
                    if design_type_dir.is_dir():
                        design_type = design_type_dir.name
                        self.boards_data[board_name][design_type] = []
                        
                        # Check for configurations
                        for config_dir in design_type_dir.iterdir():
                            if config_dir.is_dir() and (config_dir / "fcp.tcl").exists():
                                self.boards_data[board_name][design_type].append(config_dir.name)
    
    def clean_vivado_files(self):
        """Delete all files starting with 'vivado' in the script directory"""
        deleted_files = []
        for item in self.script_dir.iterdir():
            if item.is_file() and item.name.startswith("vivado"):
                try:
                    item.unlink()
                    deleted_files.append(item.name)
                except Exception as e:
                    print(f"Warning: Could not delete {item.name}: {e}")
        return deleted_files

    
    def setup_gui(self):
        """Setup the GUI layout"""
        # Configure grid weights
        self.root.grid_rowconfigure(0, weight=1)
        for i in range(3):
            self.root.grid_columnconfigure(i, weight=1)
        
        row = 0
        
        # Title
        title_label = ttk.Label(self.root, text="CITRAP Project Generator", 
                               font=("Arial", 16, "bold"))
        title_label.grid(row=row, column=0, columnspan=3, pady=20, sticky="ew")
        row += 1
        
        # Vivado Settings Path
        vivado_frame = ttk.LabelFrame(self.root, text="Vivado Settings", padding=10)
        vivado_frame.grid(row=row, column=0, columnspan=3, padx=20, pady=10, sticky="ew")
        row += 1
        
        ttk.Label(vivado_frame, text="Settings Path:").grid(row=0, column=0, sticky="e", padx=5)
        vivado_entry = ttk.Entry(vivado_frame, textvariable=self.vivado_settings_path, width=60)
        vivado_entry.grid(row=0, column=1, padx=5, pady=5, sticky="ew")
        vivado_frame.grid_columnconfigure(1, weight=1)
        
        # Board Selection Frame
        board_frame = ttk.LabelFrame(self.root, text="Board Configuration", padding=10)
        board_frame.grid(row=row, column=0, columnspan=3, padx=20, pady=10, sticky="ew")
        row += 1
        
        # Board dropdown
        ttk.Label(board_frame, text="Select Board:").grid(row=0, column=0, sticky="e", padx=5, pady=5)
        self.board_combo = ttk.Combobox(board_frame, textvariable=self.selected_board, 
                                        values=sorted(self.boards_data.keys()), 
                                        state="readonly", width=40)
        self.board_combo.grid(row=0, column=1, padx=5, pady=5, sticky="ew")
        self.board_combo.bind("<<ComboboxSelected>>", self.on_board_selected)
        
        # Design Type dropdown
        ttk.Label(board_frame, text="Design Type:").grid(row=1, column=0, sticky="e", padx=5, pady=5)
        self.design_type_combo = ttk.Combobox(board_frame, textvariable=self.selected_design_type,
                                              state="readonly", width=40)
        self.design_type_combo.grid(row=1, column=1, padx=5, pady=5, sticky="ew")
        self.design_type_combo.bind("<<ComboboxSelected>>", self.on_design_type_selected)
        
        # Configuration dropdown
        ttk.Label(board_frame, text="Configuration:").grid(row=2, column=0, sticky="e", padx=5, pady=5)
        self.config_combo = ttk.Combobox(board_frame, textvariable=self.selected_config,
                                        state="readonly", width=40)
        self.config_combo.grid(row=2, column=1, padx=5, pady=5, sticky="ew")
        
        board_frame.grid_columnconfigure(1, weight=1)
        
        # Jobs Configuration Frame
        jobs_frame = ttk.LabelFrame(self.root, text="Build Configuration", padding=10)
        jobs_frame.grid(row=row, column=0, columnspan=3, padx=20, pady=10, sticky="ew")
        row += 1
        
        ttk.Label(jobs_frame, text="Jobs (threads):").grid(row=0, column=0, sticky="e", padx=5, pady=5)
        jobs_spinbox = ttk.Spinbox(jobs_frame, from_=1, to=128, textvariable=self.jobs_count, width=10)
        jobs_spinbox.grid(row=0, column=1, padx=5, pady=5, sticky="w")
        ttk.Label(jobs_frame, text="Number of parallel jobs for synthesis/implementation").grid(row=0, column=2, sticky="w", padx=5)
        
        # Generate Bitstream checkbox
        self.bitstream_checkbox = ttk.Checkbutton(jobs_frame, text="Generate Bitstream", 
                                                  variable=self.generate_bitstream)
        self.bitstream_checkbox.grid(row=1, column=0, columnspan=3, sticky="w", padx=5, pady=5)
        ttk.Label(jobs_frame, text="(Runs synthesis and implementation to generate bitstream)", 
                 font=("Arial", 9, "italic")).grid(row=2, column=0, columnspan=3, sticky="w", padx=25)
        
        jobs_frame.grid_columnconfigure(2, weight=1)
        

        
        # Buttons Frame
        button_frame = ttk.Frame(self.root)
        button_frame.grid(row=row, column=0, columnspan=3, pady=20)
        row += 1
        
        self.create_button = ttk.Button(button_frame, text="Create Project", 
                                       style="success.TButton", command=self.create_project)
        self.create_button.grid(row=0, column=0, padx=10)
        
        # Status Label
        self.status_label = ttk.Label(self.root, text="Ready", font=("Arial", 10))
        self.status_label.grid(row=row, column=0, columnspan=3, pady=10)
        
    def on_board_selected(self, event):
        """Handle board selection"""
        board = self.selected_board.get()
        if board and board in self.boards_data:
            design_types = sorted(self.boards_data[board].keys())
            self.design_type_combo['values'] = design_types
            self.design_type_combo.set('')
            self.config_combo['values'] = []
            self.config_combo.set('')
    
    def on_design_type_selected(self, event):
        """Handle design type selection"""
        board = self.selected_board.get()
        design_type = self.selected_design_type.get()
        if board and design_type and board in self.boards_data:
            configs = sorted(self.boards_data[board][design_type])
            self.config_combo['values'] = configs
            self.config_combo.set('')
    

    
    def copy_config_files(self, config_dir, citrap_dir):
        """Copy only required files for project creation"""
        citrap_dir.mkdir(parents=True, exist_ok=True)
        
        copied_items = []
        
        # List of required files
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
        
        # Copy constraint files (.xdc)
        for item in config_dir.iterdir():
            if item.is_file() and item.suffix == '.xdc':
                dest = citrap_dir / item.name
                shutil.copy2(item, dest)
                copied_items.append(item.name)
        
        # Copy debug_partition directory if it exists
        debug_partition_dir = config_dir / 'debug_partition'
        if debug_partition_dir.exists() and debug_partition_dir.is_dir():
            dest_debug_dir = citrap_dir / 'debug_partition'
            shutil.copytree(debug_partition_dir, dest_debug_dir, dirs_exist_ok=True)
            copied_items.append('debug_partition/')
        
        return copied_items
    
    def update_fcp_tcl(self, fcp_path, jobs=32):
        """Update fcp.tcl with actual paths and jobs count"""
        with open(fcp_path, 'r') as f:
            content = f.read()
        
        # Replace /dummy_path/citrap with script_dir/citrap (project location)
        updated_content = content.replace('/dummy_path/citrap', str(self.script_dir) + '/citrap')
        
        # Replace remaining /dummy_path/ with script_dir/citrap_tmp/ (source files)
        updated_content = updated_content.replace('/dummy_path/', str(self.script_dir) + '/citrap_tmp/')
        
        # Replace -jobs N with the specified jobs count
        updated_content = re.sub(r'-jobs\s+\d+', f'-jobs {jobs}', updated_content)
        
        return updated_content
    
    def append_bitstream_generation(self, config_dir, jobs=32):
        """Read generage_bitstream.tcl and update jobs count"""
        bitstream_tcl = config_dir / "generage_bitstream.tcl"
        
        if not bitstream_tcl.exists():
            print(f"Warning: {bitstream_tcl} not found, skipping bitstream generation")
            return ""
        
        with open(bitstream_tcl, 'r') as f:
            content = f.read()
        
        # Replace -jobs N with the specified jobs count
        updated_content = re.sub(r'-jobs\s+\d+', f'-jobs {jobs}', content)
        
        return "\n" + updated_content
    
    def create_project(self):
        """Create the Vivado project"""
        board = self.selected_board.get()
        design_type = self.selected_design_type.get()
        config = self.selected_config.get()
        vivado_settings = self.vivado_settings_path.get()
        jobs = self.jobs_count.get()
        
        # Validate selections
        if not board or not design_type or not config:
            messagebox.showwarning("Warning", "Please select board, design type, and configuration")
            return
        
        if not vivado_settings:
            messagebox.showwarning("Warning", "Please specify Vivado settings path")
            return
        
        # Check if Vivado settings file exists
        if not Path(vivado_settings).exists():
            response = messagebox.askyesno("Warning", 
                f"Vivado settings file not found at:\n{vivado_settings}\n\nContinue anyway?")
            if not response:
                return
        
        # Confirm
        response = messagebox.askyesno("Confirm", 
            f"Create project with the following configuration?\n\n"
            f"Board: {board}\n"
            f"Design Type: {design_type}\n"
            f"Configuration: {config}\n"
            f"Jobs (threads): {jobs}\n"
            f"Generate Bitstream: {'Yes' if self.generate_bitstream.get() else 'No'}\n\n"
            f"This will delete existing citrap and citrap_tmp directories.\n\n"
            f"The GUI will close and all output will be shown in the terminal.")
        
        if not response:
            return
        
        # Close the GUI window
        self.root.destroy()
        
        # Continue execution in terminal
        try:
            print("=" * 60)
            print("CITRAP Project Generator")
            print("=" * 60)
            print(f"\nConfiguration:")
            print(f"  Board: {board}")
            print(f"  Design Type: {design_type}")
            print(f"  Configuration: {config}")
            print(f"  Vivado Settings: {vivado_settings}")
            print(f"  Jobs (threads): {jobs}")
            print(f"  Generate Bitstream: {'Yes' if self.generate_bitstream.get() else 'No'}")
            print("=" * 60)
            
            # Clean vivado files from previous runs
            print("\nCleaning Vivado log files...")
            deleted_files = self.clean_vivado_files()
            if deleted_files:
                for file in deleted_files:
                    print(f"  Deleted: {file}")
                print(f"Deleted {len(deleted_files)} Vivado files")
            else:
                print("  No Vivado files to clean")
            
            # Construct paths
            config_dir = self.script_dir / "boards" / board / design_type / config
            citrap_dir = self.script_dir / "citrap_tmp"
            citrap_project_dir = self.script_dir / "citrap"
            
            # Clean directories
            print("\nCleaning directories...")
            if citrap_dir.exists():
                print(f"  Deleting {citrap_dir}...")
                shutil.rmtree(citrap_dir)
            if citrap_project_dir.exists():
                print(f"  Deleting {citrap_project_dir}...")
                shutil.rmtree(citrap_project_dir)
            
            # Copy files
            print(f"\nCopying configuration files to {citrap_dir}...")
            copied_items = self.copy_config_files(config_dir, citrap_dir)
            for item in copied_items:
                print(f"  Copied: {item}")
            print(f"Copied {len(copied_items)} items")
            
            # Update fcp.tcl
            print(f"\nUpdating fcp.tcl with actual paths and jobs count ({jobs})...")
            fcp_content = self.update_fcp_tcl(citrap_dir / "fcp.tcl", jobs)
            
            # Append bitstream generation if requested
            if self.generate_bitstream.get():
                print(f"\nAppending bitstream generation commands...")
                bitstream_content = self.append_bitstream_generation(config_dir, jobs)
                if bitstream_content:
                    fcp_content += bitstream_content
                    print("Bitstream generation commands added")
            
            # Write updated fcp.tcl
            temp_tcl = citrap_dir / "fcp_updated.tcl"
            with open(temp_tcl, 'w') as f:
                f.write(fcp_content)
            print("Updated fcp.tcl")
            
            # Create bash script to source Vivado settings and run Vivado
            print("\nPreparing Vivado execution...")
            bash_script = citrap_dir / "run_vivado.sh"
            with open(bash_script, 'w') as f:
                f.write("#!/bin/bash\n")
                f.write(f"source {vivado_settings}\n")
                f.write(f"cd {citrap_dir}\n")
                f.write(f"vivado -mode batch -source fcp_updated.tcl\n")
            
            # Make script executable
            os.chmod(bash_script, 0o755)
            
            # Run Vivado with output to terminal
            print("\n" + "=" * 60)
            print("Launching Vivado...")
            print(f"Working directory: {citrap_dir}")
            print(f"TCL script: {temp_tcl}")
            print("=" * 60 + "\n")
            
            # Run the bash script without capturing output (shows in terminal)
            result = subprocess.run(['bash', str(bash_script)])
            
            print("\n" + "=" * 60)
            if result.returncode == 0:
                print("SUCCESS: Project created successfully!")
                print(f"Project location: {citrap_project_dir}")
            else:
                print(f"WARNING: Vivado exited with code {result.returncode}")
                print(f"Check the log files in {citrap_dir} for details")
            print("=" * 60 + "\n")
        
        except Exception as e:
            print("\n" + "=" * 60)
            print(f"ERROR: An error occurred: {str(e)}")
            print("=" * 60 + "\n")
            import traceback
            traceback.print_exc()


def main():
    # Create root window
    root = tk.Tk()
    
    # Load ttkbootstrap theme
    style = Style(theme="cosmo")
    style.configure("TButton", padding=6)
    style.configure("TCombobox", font=("Helvetica", 11))
    style.master = root
    
    # Create GUI
    app = CITRAPProjectGUI(root)
    
    # Run application
    root.mainloop()

if __name__ == "__main__":
    main()
