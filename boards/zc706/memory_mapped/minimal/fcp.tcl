create_project citrap /dummy_path/citrap -part xc7z045ffg900-2
set_property board_part xilinx.com:zc706:part0:1.4 [current_project]
add_files -norecurse -scan_for_includes /dummy_path/top.vhd
import_files -force -norecurse
import_files -fileset constrs_1 -force -norecurse /dummy_path/zc706.xdc
import_files -fileset constrs_1 -force -norecurse /dummy_path/partition_constr.xdc
update_compile_order -fileset sources_1
cd /dummy_path/
source static_design.tcl

update_compile_order -fileset sources_1
make_wrapper -files [get_files /dummy_path/citrap/citrap.srcs/sources_1/bd/static_design/static_design.bd] -top
add_files -norecurse /dummy_path/citrap/citrap.gen/sources_1/bd/static_design/hdl/static_design_wrapper.v
update_compile_order -fileset sources_1
open_bd_design {/home/burtsev/Documents/citrap/citrap/citrap.srcs/sources_1/bd/static_design/static_design.bd}
open_bd_design {/home/burtsev/Documents/citrap/citrap/citrap.srcs/sources_1/bd/static_design/static_design.bd}
source dfx_test_partition.tcl
update_compile_order -fileset sources_1
make_wrapper -files [get_files /dummy_path/citrap/citrap.srcs/sources_1/bd/dfx_test_partition/dfx_test_partition.bd] -top

add_files -norecurse /dummy_path/citrap/citrap.gen/sources_1/bd/dfx_test_partition/hdl/dfx_test_partition_wrapper.v
update_compile_order -fileset sources_1

set_property PR_FLOW 1 [current_project]
create_partition_def -name user_logic_partition -module dfx_test_partition_wrapper

create_reconfig_module -name dfx_test_partition_wrapper -partition_def [get_partition_defs user_logic_partition ]  -define_from dfx_test_partition_wrapper

generate_target all [get_files -of_objects [get_reconfig_modules dfx_test_partition_wrapper] /dummy_path/citrap/citrap.srcs/sources_1/bd/dfx_test_partition/dfx_test_partition.bd]

generate_target all [get_files  /dummy_path/citrap/citrap.srcs/sources_1/bd/static_design/static_design.bd]

update_compile_order -fileset sources_1

create_reconfig_module -name debug_partition -partition_def [get_partition_defs user_logic_partition ]  -top dbg_partition_wrapper

import_files -norecurse /dummy_path/debug_partition/dbg_partition.bd /dummy_path/debug_partition/dbg_partition_wrapper.vhd  -of_objects [get_reconfig_modules debug_partition]

create_pr_configuration -name dfx_test -partitions [list dfx_test_partition_wrapper_i:dfx_test_partition_wrapper ]

create_pr_configuration -name debug -partitions [list dfx_test_partition_wrapper_i:debug_partition ]

set_property PR_CONFIGURATION dfx_test [get_runs impl_1]

create_run child_0_impl_1 -parent_run impl_1 -flow {Vivado Implementation 2024} -pr_config debug

set_property strategy Flow_AreaOptimized_high [get_runs synth_1]
set_property strategy Area_ExploreSequential [get_runs impl_1]

set_property incremental_checkpoint.directive RuntimeOptimized [get_runs impl_1]
set_property incremental_checkpoint.directive RuntimeOptimized [get_runs child_0_impl_1]
set_property AUTO_INCREMENTAL_CHECKPOINT 1 [get_runs impl_1]
set_property AUTO_INCREMENTAL_CHECKPOINT.DIRECTORY /dummy_path/citrap/citrap.srcs/utils_1/imports/impl_1 [get_runs impl_1]
set_property AUTO_INCREMENTAL_CHECKPOINT 1 [get_runs child_0_impl_1]
set_property AUTO_INCREMENTAL_CHECKPOINT.DIRECTORY /dummy_path/citrap/citrap.srcs/utils_1/imports/child_0_impl_1 [get_runs child_0_impl_1]



