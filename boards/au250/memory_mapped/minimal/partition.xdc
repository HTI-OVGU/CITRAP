create_pblock user_logic_partition
add_cells_to_pblock [get_pblocks user_logic_partition] [get_cells -quiet [list dfx_test_partition_wrapper_i]]
resize_pblock [get_pblocks user_logic_partition] -add {SLICE_X0Y480:SLICE_X232Y959 SLICE_X146Y360:SLICE_X224Y479 SLICE_X0Y240:SLICE_X116Y479 SLICE_X119Y240:SLICE_X213Y299 SLICE_X0Y0:SLICE_X232Y239}
resize_pblock [get_pblocks user_logic_partition] -add {BUFG_GT_X1Y192:BUFG_GT_X1Y383 BUFG_GT_X1Y0:BUFG_GT_X1Y95 BUFG_GT_X0Y0:BUFG_GT_X0Y383}
resize_pblock [get_pblocks user_logic_partition] -add {BUFG_GT_SYNC_X1Y120:BUFG_GT_SYNC_X1Y239 BUFG_GT_SYNC_X1Y0:BUFG_GT_SYNC_X1Y59 BUFG_GT_SYNC_X0Y0:BUFG_GT_SYNC_X0Y239}
resize_pblock [get_pblocks user_logic_partition] -add {CFGIO_SITE_X0Y0:CFGIO_SITE_X0Y3}
resize_pblock [get_pblocks user_logic_partition] -add {CMACE4_X0Y0:CMACE4_X0Y11}
resize_pblock [get_pblocks user_logic_partition] -add {CONFIG_SITE_X0Y2:CONFIG_SITE_X0Y3 CONFIG_SITE_X0Y0:CONFIG_SITE_X0Y0}
resize_pblock [get_pblocks user_logic_partition] -add {DSP48E2_X0Y192:DSP48E2_X31Y383 DSP48E2_X20Y144:DSP48E2_X30Y191 DSP48E2_X0Y120:DSP48E2_X15Y191 DSP48E2_X0Y96:DSP48E2_X29Y119 DSP48E2_X0Y0:DSP48E2_X31Y95}
resize_pblock [get_pblocks user_logic_partition] -add {GTYE4_CHANNEL_X1Y32:GTYE4_CHANNEL_X1Y63 GTYE4_CHANNEL_X1Y0:GTYE4_CHANNEL_X1Y15 GTYE4_CHANNEL_X0Y0:GTYE4_CHANNEL_X0Y63}
resize_pblock [get_pblocks user_logic_partition] -add {GTYE4_COMMON_X1Y8:GTYE4_COMMON_X1Y15 GTYE4_COMMON_X1Y0:GTYE4_COMMON_X1Y3 GTYE4_COMMON_X0Y0:GTYE4_COMMON_X0Y15}
resize_pblock [get_pblocks user_logic_partition] -add {ILKNE4_X0Y0:ILKNE4_X1Y7}
resize_pblock [get_pblocks user_logic_partition] -add {IOB_X0Y260:IOB_X0Y831 IOB_X0Y0:IOB_X0Y207}
resize_pblock [get_pblocks user_logic_partition] -add {LAGUNA_X0Y480:LAGUNA_X31Y959 LAGUNA_X20Y360:LAGUNA_X29Y479 LAGUNA_X0Y360:LAGUNA_X15Y479 LAGUNA_X0Y240:LAGUNA_X29Y359 LAGUNA_X0Y0:LAGUNA_X31Y239}
resize_pblock [get_pblocks user_logic_partition] -add {PCIE40E4_X0Y2:PCIE40E4_X0Y3 PCIE40E4_X0Y0:PCIE40E4_X0Y0}
resize_pblock [get_pblocks user_logic_partition] -add {RAMB18_X10Y144:RAMB18_X13Y383 RAMB18_X12Y0:RAMB18_X13Y95 RAMB18_X8Y0:RAMB18_X11Y119 RAMB18_X8Y192:RAMB18_X9Y383 RAMB18_X0Y0:RAMB18_X7Y383}
resize_pblock [get_pblocks user_logic_partition] -add {RAMB36_X10Y72:RAMB36_X13Y191 RAMB36_X12Y0:RAMB36_X13Y47 RAMB36_X8Y0:RAMB36_X11Y59 RAMB36_X8Y96:RAMB36_X9Y191 RAMB36_X0Y0:RAMB36_X7Y191}
resize_pblock [get_pblocks user_logic_partition] -add {SYSMONE4_X0Y0:SYSMONE4_X0Y3}
resize_pblock [get_pblocks user_logic_partition] -add {URAM288_X3Y96:URAM288_X4Y255 URAM288_X2Y0:URAM288_X4Y79 URAM288_X2Y128:URAM288_X2Y255 URAM288_X0Y0:URAM288_X1Y255}
set_property SNAPPING_MODE ON [get_pblocks user_logic_partition]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
