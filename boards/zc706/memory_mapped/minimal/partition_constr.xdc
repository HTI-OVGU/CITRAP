startgroup
create_pblock user_logic_partition
add_cells_to_pblock [get_pblocks user_logic_partition] [get_cells -quiet [list dfx_test_partition_wrapper_i]]
resize_pblock [get_pblocks user_logic_partition] -add {SLICE_X90Y0:SLICE_X163Y99 SLICE_X0Y0:SLICE_X89Y349}
resize_pblock [get_pblocks user_logic_partition] -add {DSP48_X4Y0:DSP48_X6Y39 DSP48_X0Y0:DSP48_X3Y139}
resize_pblock [get_pblocks user_logic_partition] -add {RAMB18_X4Y0:RAMB18_X7Y39 RAMB18_X0Y0:RAMB18_X3Y139}
resize_pblock [get_pblocks user_logic_partition] -add {RAMB36_X4Y0:RAMB36_X7Y19 RAMB36_X0Y0:RAMB36_X3Y69}
set_property RESET_AFTER_RECONFIG true [get_pblocks user_logic_partition]
set_property SNAPPING_MODE ON [get_pblocks user_logic_partition]
endgroup
