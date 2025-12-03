set bitfile [lindex $argv 0]
if { ![file exists $bitfile] } {
    puts "Error: Bitfile $bitfile not found"
    exit 1
} else {
    puts "Using bitfile: $bitfile"
}

# Get FPGA device from command line argument, default to xc7z045_1 if not provided
set fpga_device [lindex $argv 1]
if { $fpga_device == "" } {
    set fpga_device "xc7z045_1"
    puts "Warning: No device specified, using default: $fpga_device"
} else {
    puts "Using FPGA device: $fpga_device"
}

open_hw_manager

connect_hw_server -url TCP:localhost:3121

open_hw_target

current_hw_device [get_hw_devices $fpga_device]

set_property PROGRAM.FILE $bitfile [get_hw_devices $fpga_device]

program_hw_devices [get_hw_devices $fpga_device]

refresh_hw_device [get_hw_devices $fpga_device]

puts "Programming complete!"

exit 0
