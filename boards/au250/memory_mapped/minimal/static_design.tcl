
################################################################
# This is a generated script based on design: static_design
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################


################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source static_design_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcu250-figd2104-2L-e
   set_property BOARD_PART xilinx.com:au250:part0:1.3 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name static_design

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:ddr4:2.2\
xilinx.com:ip:axi_dwidth_converter:2.1\
xilinx.com:ip:dfx_axi_shutdown_manager:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xdma:4.1\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:xlconstant:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: pcie_conf
proc create_hier_cell_pcie_conf { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_pcie_conf() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 15 -to 0 vend_id_subsys_vend_id
  create_bd_pin -dir O -from 15 -to 0 dev_id
  create_bd_pin -dir O -from 7 -to 0 rev_id
  create_bd_pin -dir O -from 15 -to 0 subsys_id

  # Create instance: X10EE, and set properties
  set X10EE [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 X10EE ]
  set_property -dict [list \
    CONFIG.CONST_VAL {4334} \
    CONFIG.CONST_WIDTH {16} \
  ] $X10EE


  # Create instance: X9032, and set properties
  set X9032 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 X9032 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {36914} \
    CONFIG.CONST_WIDTH {16} \
  ] $X9032


  # Create instance: X0, and set properties
  set X0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 X0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {8} \
  ] $X0


  # Create instance: X0007, and set properties
  set X0007 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 X0007 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {7} \
    CONFIG.CONST_WIDTH {16} \
  ] $X0007


  # Create port connections
  connect_bd_net -net X0007_dout  [get_bd_pins X0007/dout] \
  [get_bd_pins subsys_id]
  connect_bd_net -net X10EE_dout  [get_bd_pins X10EE/dout] \
  [get_bd_pins vend_id_subsys_vend_id]
  connect_bd_net -net X9022_dout  [get_bd_pins X9032/dout] \
  [get_bd_pins dev_id]
  connect_bd_net -net xlconstant_2_dout  [get_bd_pins X0/dout] \
  [get_bd_pins rev_id]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: PCIe
proc create_hier_cell_PCIe { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_PCIe() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pci_express

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_refclk


  # Create pins
  create_bd_pin -dir I -type rst pcie_perstn
  create_bd_pin -dir O -type clk axi_clk
  create_bd_pin -dir O -type rst axi_aresetn

  # Create instance: xdma_0, and set properties
  set xdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_0 ]
  set_property -dict [list \
    CONFIG.PCIE_BOARD_INTERFACE {pci_express_x2} \
    CONFIG.SYS_RST_N_BOARD_INTERFACE {pcie_perstn} \
    CONFIG.axi_data_width {64_bit} \
    CONFIG.axilite_master_en {false} \
    CONFIG.cfg_mgmt_if {false} \
    CONFIG.enable_jtag_dbg {true} \
    CONFIG.pcie_id_if {true} \
    CONFIG.pf0_base_class_menu {Simple_communication_controllers} \
    CONFIG.pf0_device_id {9032} \
    CONFIG.pf0_sub_class_interface_menu {16450_compatible_serial_controller} \
    CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
    CONFIG.xdma_axi_intf_mm {AXI_Memory_Mapped} \
    CONFIG.xdma_pcie_64bit_en {true} \
    CONFIG.xdma_pcie_prefetchable {true} \
    CONFIG.xdma_rnum_chnl {2} \
    CONFIG.xdma_wnum_chnl {2} \
  ] $xdma_0


  # Create instance: util_ds_buf, and set properties
  set util_ds_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf ]
  set_property -dict [list \
    CONFIG.DIFF_CLK_IN_BOARD_INTERFACE {pcie_refclk} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $util_ds_buf


  # Create instance: pcie_conf
  create_hier_cell_pcie_conf $hier_obj pcie_conf

  # Create interface connections
  connect_bd_intf_net -intf_net pcie_refclk_1 [get_bd_intf_pins pcie_refclk] [get_bd_intf_pins util_ds_buf/CLK_IN_D]
  connect_bd_intf_net -intf_net xdma_0_M_AXI [get_bd_intf_pins M_AXI] [get_bd_intf_pins xdma_0/M_AXI]
  connect_bd_intf_net -intf_net xdma_0_pcie_mgt [get_bd_intf_pins pci_express] [get_bd_intf_pins xdma_0/pcie_mgt]

  # Create port connections
  connect_bd_net -net pcie_conf_dev_id  [get_bd_pins pcie_conf/dev_id] \
  [get_bd_pins xdma_0/cfg_dev_id_pf0]
  connect_bd_net -net pcie_conf_rev_id  [get_bd_pins pcie_conf/rev_id] \
  [get_bd_pins xdma_0/cfg_rev_id_pf0]
  connect_bd_net -net pcie_conf_subsys_id  [get_bd_pins pcie_conf/subsys_id] \
  [get_bd_pins xdma_0/cfg_subsys_id_pf0]
  connect_bd_net -net pcie_conf_vend_id_subsys_vend_id  [get_bd_pins pcie_conf/vend_id_subsys_vend_id] \
  [get_bd_pins xdma_0/cfg_subsys_vend_id] \
  [get_bd_pins xdma_0/cfg_vend_id]
  connect_bd_net -net pcie_perstn_1  [get_bd_pins pcie_perstn] \
  [get_bd_pins xdma_0/sys_rst_n]
  connect_bd_net -net util_ds_buf_IBUF_DS_ODIV2  [get_bd_pins util_ds_buf/IBUF_DS_ODIV2] \
  [get_bd_pins xdma_0/sys_clk]
  connect_bd_net -net util_ds_buf_IBUF_OUT  [get_bd_pins util_ds_buf/IBUF_OUT] \
  [get_bd_pins xdma_0/sys_clk_gt]
  connect_bd_net -net xdma_0_axi_aclk1  [get_bd_pins xdma_0/axi_aclk] \
  [get_bd_pins axi_clk]
  connect_bd_net -net xdma_0_axi_aresetn  [get_bd_pins xdma_0/axi_aresetn] \
  [get_bd_pins axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: DFX_logic
proc create_hier_cell_DFX_logic { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_DFX_logic() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_static_from_sdman

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_static_to_sdman

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 s_static_from_sdman

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_dfxctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_gpio_user_aresetn

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -type clk axi_clk
  create_bd_pin -dir I -type rst resetn
  create_bd_pin -dir I -from 0 -to 0 probe4
  create_bd_pin -dir I -from 0 -to 0 sys_rst_n
  create_bd_pin -dir O -from 0 -to 0 mstatic_aresetn_0

  # Create instance: dfx_axi_shutdown_man_1, and set properties
  set dfx_axi_shutdown_man_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dfx_axi_shutdown_manager:1.0 dfx_axi_shutdown_man_1 ]
  set_property -dict [list \
    CONFIG.DP_AXI_ADDR_WIDTH {37} \
    CONFIG.DP_AXI_DATA_WIDTH {32} \
    CONFIG.RP_IS_MASTER {false} \
  ] $dfx_axi_shutdown_man_1


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_0


  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_1


  # Create instance: dfx_axi_shutdown_man_0, and set properties
  set dfx_axi_shutdown_man_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dfx_axi_shutdown_manager:1.0 dfx_axi_shutdown_man_0 ]
  set_property -dict [list \
    CONFIG.DP_AXI_DATA_WIDTH {32} \
    CONFIG.RP_IS_MASTER {true} \
  ] $dfx_axi_shutdown_man_0


  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.C_MON_TYPE {NATIVE} \
    CONFIG.C_NUM_OF_PROBES {10} \
  ] $system_ila_0


  # Create instance: axi_dfx_control, and set properties
  set axi_dfx_control [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_dfx_control ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO2_WIDTH {2} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_dfx_control


  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_2


  # Create instance: axi_gpio_user_logic_aresetn, and set properties
  set axi_gpio_user_logic_aresetn [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_user_logic_aresetn ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0xFFFFFFFF} \
    CONFIG.C_GPIO2_WIDTH {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_gpio_user_logic_aresetn


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins axi_dfx_control/S_AXI] [get_bd_intf_pins axi_dfxctrl]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins axi_gpio_user_logic_aresetn/S_AXI] [get_bd_intf_pins axi_gpio_user_aresetn]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins dfx_axi_shutdown_man_1/S_AXI] [get_bd_intf_pins S_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_1 [get_bd_intf_pins s_static_to_sdman] [get_bd_intf_pins dfx_axi_shutdown_man_0/S_AXI]
  connect_bd_intf_net -intf_net dfx_axi_shutdown_man_0_M_AXI [get_bd_intf_pins s_static_from_sdman] [get_bd_intf_pins dfx_axi_shutdown_man_0/M_AXI]
  connect_bd_intf_net -intf_net dfx_axi_shutdown_man_1_M_AXI [get_bd_intf_pins m_static_from_sdman] [get_bd_intf_pins dfx_axi_shutdown_man_1/M_AXI]

  # Create port connections
  connect_bd_net -net axi_gpio_1_gpio_io_o  [get_bd_pins axi_dfx_control/gpio_io_o] \
  [get_bd_pins dfx_axi_shutdown_man_0/request_shutdown] \
  [get_bd_pins dfx_axi_shutdown_man_1/request_shutdown]
  connect_bd_net -net axi_gpio_aresetn_gpio_io_o  [get_bd_pins axi_gpio_user_logic_aresetn/gpio_io_o] \
  [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net dfx_axi_shutdown_man_0_in_shutdown  [get_bd_pins dfx_axi_shutdown_man_0/in_shutdown] \
  [get_bd_pins util_vector_logic_1/Op2] \
  [get_bd_pins system_ila_0/probe3]
  connect_bd_net -net dfx_axi_shutdown_man_0_rd_in_shutdown  [get_bd_pins dfx_axi_shutdown_man_0/rd_in_shutdown] \
  [get_bd_pins system_ila_0/probe8]
  connect_bd_net -net dfx_axi_shutdown_man_0_shutdown_requested  [get_bd_pins dfx_axi_shutdown_man_0/shutdown_requested] \
  [get_bd_pins util_vector_logic_0/Op2] \
  [get_bd_pins system_ila_0/probe1]
  connect_bd_net -net dfx_axi_shutdown_man_0_wr_in_shutdown  [get_bd_pins dfx_axi_shutdown_man_0/wr_in_shutdown] \
  [get_bd_pins system_ila_0/probe6]
  connect_bd_net -net dfx_axi_shutdown_man_1_in_shutdown  [get_bd_pins dfx_axi_shutdown_man_1/in_shutdown] \
  [get_bd_pins util_vector_logic_1/Op1] \
  [get_bd_pins system_ila_0/probe2]
  connect_bd_net -net dfx_axi_shutdown_man_1_rd_in_shutdown  [get_bd_pins dfx_axi_shutdown_man_1/rd_in_shutdown] \
  [get_bd_pins system_ila_0/probe9]
  connect_bd_net -net dfx_axi_shutdown_man_1_shutdown_requested  [get_bd_pins dfx_axi_shutdown_man_1/shutdown_requested] \
  [get_bd_pins util_vector_logic_0/Op1] \
  [get_bd_pins system_ila_0/probe0]
  connect_bd_net -net dfx_axi_shutdown_man_1_wr_in_shutdown  [get_bd_pins dfx_axi_shutdown_man_1/wr_in_shutdown] \
  [get_bd_pins system_ila_0/probe7]
  connect_bd_net -net probe4_1  [get_bd_pins probe4] \
  [get_bd_pins system_ila_0/probe4]
  connect_bd_net -net sys_rst_n_1  [get_bd_pins sys_rst_n] \
  [get_bd_pins system_ila_0/probe5]
  connect_bd_net -net util_vector_logic_0_Res  [get_bd_pins util_vector_logic_0/Res] \
  [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net util_vector_logic_1_Res  [get_bd_pins util_vector_logic_1/Res] \
  [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net util_vector_logic_2_Res  [get_bd_pins util_vector_logic_2/Res] \
  [get_bd_pins mstatic_aresetn_0] \
  [get_bd_pins axi_gpio_user_logic_aresetn/gpio2_io_i]
  connect_bd_net -net xilinx_dma_pcie_ep_0_user_clk  [get_bd_pins axi_clk] \
  [get_bd_pins system_ila_0/clk] \
  [get_bd_pins dfx_axi_shutdown_man_0/clk] \
  [get_bd_pins dfx_axi_shutdown_man_1/clk] \
  [get_bd_pins axi_dfx_control/s_axi_aclk] \
  [get_bd_pins axi_gpio_user_logic_aresetn/s_axi_aclk]
  connect_bd_net -net xilinx_dma_pcie_ep_0_user_resetn  [get_bd_pins resetn] \
  [get_bd_pins dfx_axi_shutdown_man_0/resetn] \
  [get_bd_pins dfx_axi_shutdown_man_1/resetn] \
  [get_bd_pins axi_dfx_control/s_axi_aresetn] \
  [get_bd_pins util_vector_logic_2/Op2] \
  [get_bd_pins axi_gpio_user_logic_aresetn/s_axi_aresetn]
  connect_bd_net -net xlconcat_0_dout  [get_bd_pins xlconcat_0/dout] \
  [get_bd_pins axi_dfx_control/gpio2_io_i]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set ddr4_sdram_c1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_sdram_c1 ]

  set default_300mhz_clk1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 default_300mhz_clk1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $default_300mhz_clk1

  set pci_express [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pci_express ]

  set pcie_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_refclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $pcie_refclk

  set mstatic_axi_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 mstatic_axi_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {37} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   ] $mstatic_axi_0

  set sstatic_axi_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 sstatic_axi_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {37} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $sstatic_axi_0


  # Create ports
  set pcie_perstn [ create_bd_port -dir I -type rst pcie_perstn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $pcie_perstn
  set mstatic_aresetn [ create_bd_port -dir O -from 0 -to 0 mstatic_aresetn ]
  set axi_clk [ create_bd_port -dir O -type clk axi_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {mstatic_axi_0:sstatic_axi_0} \
 ] $axi_clk

  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {2} \
    CONFIG.NUM_MI {5} \
    CONFIG.NUM_SI {2} \
  ] $axi_smc


  # Create instance: DFX_logic
  create_hier_cell_DFX_logic [current_bd_instance .] DFX_logic

  # Create instance: rst_ddr4_1_300M, and set properties
  set rst_ddr4_1_300M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ddr4_1_300M ]

  # Create instance: ddr4_1, and set properties
  set ddr4_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_1 ]
  set_property -dict [list \
    CONFIG.C0_CLOCK_BOARD_INTERFACE {default_300mhz_clk1} \
    CONFIG.C0_DDR4_BOARD_INTERFACE {ddr4_sdram_c1} \
    CONFIG.RESET_BOARD_INTERFACE {Custom} \
    CONFIG.System_Clock {Differential} \
  ] $ddr4_1


  # Create instance: axi_dwidth_converter_0, and set properties
  set axi_dwidth_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 axi_dwidth_converter_0 ]

  # Create instance: axi_dwidth_converter_1, and set properties
  set axi_dwidth_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 axi_dwidth_converter_1 ]

  # Create instance: PCIe
  create_hier_cell_PCIe [current_bd_instance .] PCIe

  # Create interface connections
  connect_bd_intf_net -intf_net DFX_logic_m_static_from_sdman [get_bd_intf_ports mstatic_axi_0] [get_bd_intf_pins DFX_logic/m_static_from_sdman]
  connect_bd_intf_net -intf_net DFX_logic_s_static_from_sdman [get_bd_intf_pins DFX_logic/s_static_from_sdman] [get_bd_intf_pins axi_smc/S01_AXI]
  connect_bd_intf_net -intf_net axi_dwidth_converter_0_M_AXI [get_bd_intf_pins axi_dwidth_converter_0/M_AXI] [get_bd_intf_pins axi_smc/S00_AXI]
  connect_bd_intf_net -intf_net axi_dwidth_converter_1_M_AXI [get_bd_intf_pins axi_dwidth_converter_1/M_AXI] [get_bd_intf_pins ddr4_1/C0_DDR4_S_AXI]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins DFX_logic/axi_dfxctrl]
  connect_bd_intf_net -intf_net axi_smc_M01_AXI [get_bd_intf_pins axi_dwidth_converter_1/S_AXI] [get_bd_intf_pins axi_smc/M01_AXI]
  connect_bd_intf_net -intf_net axi_smc_M02_AXI [get_bd_intf_pins axi_smc/M02_AXI] [get_bd_intf_pins ddr4_1/C0_DDR4_S_AXI_CTRL]
  connect_bd_intf_net -intf_net axi_smc_M03_AXI [get_bd_intf_pins axi_smc/M03_AXI] [get_bd_intf_pins DFX_logic/axi_gpio_user_aresetn]
  connect_bd_intf_net -intf_net axi_smc_M04_AXI [get_bd_intf_pins axi_smc/M04_AXI] [get_bd_intf_pins DFX_logic/S_AXI]
  connect_bd_intf_net -intf_net ddr4_1_C0_DDR4 [get_bd_intf_ports ddr4_sdram_c1] [get_bd_intf_pins ddr4_1/C0_DDR4]
  connect_bd_intf_net -intf_net default_300mhz_clk1_1 [get_bd_intf_ports default_300mhz_clk1] [get_bd_intf_pins ddr4_1/C0_SYS_CLK]
  connect_bd_intf_net -intf_net pcie_refclk_1 [get_bd_intf_ports pcie_refclk] [get_bd_intf_pins PCIe/pcie_refclk]
  connect_bd_intf_net -intf_net s_static_to_sdman_0_1 [get_bd_intf_ports sstatic_axi_0] [get_bd_intf_pins DFX_logic/s_static_to_sdman]
  connect_bd_intf_net -intf_net xdma_0_M_AXI [get_bd_intf_pins PCIe/M_AXI] [get_bd_intf_pins axi_dwidth_converter_0/S_AXI]
  connect_bd_intf_net -intf_net xdma_0_pcie_mgt [get_bd_intf_ports pci_express] [get_bd_intf_pins PCIe/pci_express]

  # Create port connections
  connect_bd_net -net DFX_logic_mstatic_aresetn_0  [get_bd_pins DFX_logic/mstatic_aresetn_0] \
  [get_bd_ports mstatic_aresetn]
  connect_bd_net -net ddr4_1_c0_ddr4_ui_clk  [get_bd_pins ddr4_1/c0_ddr4_ui_clk] \
  [get_bd_pins axi_smc/aclk1] \
  [get_bd_pins rst_ddr4_1_300M/slowest_sync_clk] \
  [get_bd_pins axi_dwidth_converter_1/s_axi_aclk]
  connect_bd_net -net pcie_perstn_1  [get_bd_ports pcie_perstn] \
  [get_bd_pins PCIe/pcie_perstn]
  connect_bd_net -net rst_ddr4_1_300M_peripheral_aresetn  [get_bd_pins rst_ddr4_1_300M/peripheral_aresetn] \
  [get_bd_pins ddr4_1/c0_ddr4_aresetn] \
  [get_bd_pins axi_dwidth_converter_1/s_axi_aresetn]
  connect_bd_net -net rst_ddr4_1_300M_peripheral_reset  [get_bd_pins rst_ddr4_1_300M/peripheral_reset] \
  [get_bd_pins ddr4_1/sys_rst]
  connect_bd_net -net xdma_0_axi_aclk1  [get_bd_pins PCIe/axi_clk] \
  [get_bd_ports axi_clk] \
  [get_bd_pins DFX_logic/axi_clk] \
  [get_bd_pins axi_smc/aclk] \
  [get_bd_pins axi_dwidth_converter_0/s_axi_aclk]
  connect_bd_net -net xdma_0_axi_aresetn  [get_bd_pins PCIe/axi_aresetn] \
  [get_bd_pins axi_smc/aresetn] \
  [get_bd_pins DFX_logic/resetn] \
  [get_bd_pins axi_dwidth_converter_0/s_axi_aresetn] \
  [get_bd_pins rst_ddr4_1_300M/ext_reset_in]

  # Create address segments
  assign_bd_address -offset 0x80000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces PCIe/xdma_0/M_AXI] [get_bd_addr_segs DFX_logic/axi_dfx_control/S_AXI/Reg] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces PCIe/xdma_0/M_AXI] [get_bd_addr_segs DFX_logic/axi_gpio_user_logic_aresetn/S_AXI/Reg] -force
  assign_bd_address -offset 0x001400000000 -range 0x000400000000 -target_address_space [get_bd_addr_spaces PCIe/xdma_0/M_AXI] [get_bd_addr_segs ddr4_1/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x80200000 -range 0x00100000 -target_address_space [get_bd_addr_spaces PCIe/xdma_0/M_AXI] [get_bd_addr_segs ddr4_1/C0_DDR4_MEMORY_MAP_CTRL/C0_REG] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -with_name SEG_m_static_0_Reg -target_address_space [get_bd_addr_spaces PCIe/xdma_0/M_AXI] [get_bd_addr_segs mstatic_axi_0/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces sstatic_axi_0] [get_bd_addr_segs DFX_logic/axi_dfx_control/S_AXI/Reg] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces sstatic_axi_0] [get_bd_addr_segs DFX_logic/axi_gpio_user_logic_aresetn/S_AXI/Reg] -force
  assign_bd_address -offset 0x001400000000 -range 0x000400000000 -target_address_space [get_bd_addr_spaces sstatic_axi_0] [get_bd_addr_segs ddr4_1/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x80200000 -range 0x00100000 -target_address_space [get_bd_addr_spaces sstatic_axi_0] [get_bd_addr_segs ddr4_1/C0_DDR4_MEMORY_MAP_CTRL/C0_REG] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces sstatic_axi_0] [get_bd_addr_segs mstatic_axi_0/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

