create_pblock user_logic_partition
add_cells_to_pblock [get_pblocks user_logic_partition] [get_cells -quiet [list dfx_test_partition_wrapper_i]]
resize_pblock [get_pblocks user_logic_partition] -add {SLICE_X0Y480:SLICE_X232Y959 SLICE_X0Y0:SLICE_X116Y479}
resize_pblock [get_pblocks user_logic_partition] -add {BUFG_GT_X1Y192:BUFG_GT_X1Y383 BUFG_GT_X0Y0:BUFG_GT_X0Y383}
resize_pblock [get_pblocks user_logic_partition] -add {BUFG_GT_SYNC_X1Y120:BUFG_GT_SYNC_X1Y239 BUFG_GT_SYNC_X0Y0:BUFG_GT_SYNC_X0Y239}
resize_pblock [get_pblocks user_logic_partition] -add {CFGIO_SITE_X0Y2:CFGIO_SITE_X0Y3}
resize_pblock [get_pblocks user_logic_partition] -add {CMACE4_X0Y0:CMACE4_X0Y11}
resize_pblock [get_pblocks user_logic_partition] -add {CONFIG_SITE_X0Y2:CONFIG_SITE_X0Y3}
resize_pblock [get_pblocks user_logic_partition] -add {DSP48E2_X16Y192:DSP48E2_X31Y383 DSP48E2_X0Y0:DSP48E2_X15Y383}
resize_pblock [get_pblocks user_logic_partition] -add {GTYE4_CHANNEL_X1Y32:GTYE4_CHANNEL_X1Y63 GTYE4_CHANNEL_X0Y0:GTYE4_CHANNEL_X0Y63}
resize_pblock [get_pblocks user_logic_partition] -add {GTYE4_COMMON_X1Y8:GTYE4_COMMON_X1Y15 GTYE4_COMMON_X0Y0:GTYE4_COMMON_X0Y15}
resize_pblock [get_pblocks user_logic_partition] -add {ILKNE4_X1Y5:ILKNE4_X1Y7 ILKNE4_X0Y0:ILKNE4_X0Y6}
resize_pblock [get_pblocks user_logic_partition] -add {IOB_X0Y416:IOB_X0Y831}
resize_pblock [get_pblocks user_logic_partition] -add {LAGUNA_X16Y480:LAGUNA_X31Y959 LAGUNA_X0Y0:LAGUNA_X15Y959}
resize_pblock [get_pblocks user_logic_partition] -add {PCIE40E4_X0Y2:PCIE40E4_X0Y3}
resize_pblock [get_pblocks user_logic_partition] -add {RAMB18_X8Y192:RAMB18_X13Y383 RAMB18_X0Y0:RAMB18_X7Y383}
resize_pblock [get_pblocks user_logic_partition] -add {RAMB36_X8Y96:RAMB36_X13Y191 RAMB36_X0Y0:RAMB36_X7Y191}
resize_pblock [get_pblocks user_logic_partition] -add {SYSMONE4_X0Y2:SYSMONE4_X0Y3}
resize_pblock [get_pblocks user_logic_partition] -add {URAM288_X2Y128:URAM288_X4Y255 URAM288_X0Y0:URAM288_X1Y255}
set_property SNAPPING_MODE ON [get_pblocks user_logic_partition]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]

