
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
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2024.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

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
   create_project project_1 myproj -part xc7z045ffg900-2
   set_property BOARD_PART xilinx.com:zc706:part0:1.4 [current_project]
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
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:dfx_axi_shutdown_manager:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:axi_dwidth_converter:2.1\
xilinx.com:ip:axi_clock_converter:2.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:mig_7series:4.2\
xilinx.com:ip:xdma:4.1\
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
# MIG PRJ FILE TCL PROCs
##################################################################

proc write_mig_file_static_design_mig_7series_0_0 { str_mig_prj_filepath } {

   file mkdir [ file dirname "$str_mig_prj_filepath" ]
   set mig_prj_file [open $str_mig_prj_filepath  w+]

   puts $mig_prj_file {﻿<?xml version="1.0" encoding="UTF-8" standalone="no" ?>}
   puts $mig_prj_file {<Project NoOfControllers="1">}
   puts $mig_prj_file {  }
   puts $mig_prj_file {<!-- IMPORTANT: This is an internal file that has been generated by the MIG software. Any direct editing or changes made to this file may result in unpredictable behavior or data corruption. It is strongly advised that users do not edit the contents of this file. Re-run the MIG GUI with the required settings if any of the options provided below need to be altered. -->}
   puts $mig_prj_file {  <ModuleName>static_design_mig_7series_0_0</ModuleName>}
   puts $mig_prj_file {  <dci_inouts_inputs>1</dci_inouts_inputs>}
   puts $mig_prj_file {  <dci_inputs>1</dci_inputs>}
   puts $mig_prj_file {  <Debug_En>OFF</Debug_En>}
   puts $mig_prj_file {  <DataDepth_En>1024</DataDepth_En>}
   puts $mig_prj_file {  <LowPower_En>ON</LowPower_En>}
   puts $mig_prj_file {  <XADC_En>Enabled</XADC_En>}
   puts $mig_prj_file {  <TargetFPGA>xc7z045-ffg900/-2</TargetFPGA>}
   puts $mig_prj_file {  <Version>4.2</Version>}
   puts $mig_prj_file {  <SystemClock>No Buffer</SystemClock>}
   puts $mig_prj_file {  <ReferenceClock>Use System Clock</ReferenceClock>}
   puts $mig_prj_file {  <SysResetPolarity>ACTIVE LOW</SysResetPolarity>}
   puts $mig_prj_file {  <BankSelectionFlag>FALSE</BankSelectionFlag>}
   puts $mig_prj_file {  <InternalVref>0</InternalVref>}
   puts $mig_prj_file {  <dci_hr_inouts_inputs>50 Ohms</dci_hr_inouts_inputs>}
   puts $mig_prj_file {  <dci_cascade>1</dci_cascade>}
   puts $mig_prj_file {  <FPGADevice>}
   puts $mig_prj_file {    <selected>7z/xc7z045i-ffg900</selected>}
   puts $mig_prj_file {  </FPGADevice>}
   puts $mig_prj_file {  <Controller number="0">}
   puts $mig_prj_file {    <MemoryDevice>DDR3_SDRAM/SODIMMs/MT8JTF12864HZ-1G6</MemoryDevice>}
   puts $mig_prj_file {    <TimePeriod>1250</TimePeriod>}
   puts $mig_prj_file {    <VccAuxIO>1.8V</VccAuxIO>}
   puts $mig_prj_file {    <PHYRatio>4:1</PHYRatio>}
   puts $mig_prj_file {    <InputClkFreq>100</InputClkFreq>}
   puts $mig_prj_file {    <UIExtraClocks>1</UIExtraClocks>}
   puts $mig_prj_file {    <MMCM_VCO>800</MMCM_VCO>}
   puts $mig_prj_file {    <MMCMClkOut0> 8.000</MMCMClkOut0>}
   puts $mig_prj_file {    <MMCMClkOut1>1</MMCMClkOut1>}
   puts $mig_prj_file {    <MMCMClkOut2>1</MMCMClkOut2>}
   puts $mig_prj_file {    <MMCMClkOut3>1</MMCMClkOut3>}
   puts $mig_prj_file {    <MMCMClkOut4>1</MMCMClkOut4>}
   puts $mig_prj_file {    <DataWidth>64</DataWidth>}
   puts $mig_prj_file {    <DeepMemory>1</DeepMemory>}
   puts $mig_prj_file {    <DataMask>1</DataMask>}
   puts $mig_prj_file {    <ECC>Disabled</ECC>}
   puts $mig_prj_file {    <Ordering>Normal</Ordering>}
   puts $mig_prj_file {    <BankMachineCnt>4</BankMachineCnt>}
   puts $mig_prj_file {    <CustomPart>FALSE</CustomPart>}
   puts $mig_prj_file {    <NewPartName/>}
   puts $mig_prj_file {    <RowAddress>14</RowAddress>}
   puts $mig_prj_file {    <ColAddress>10</ColAddress>}
   puts $mig_prj_file {    <BankAddress>3</BankAddress>}
   puts $mig_prj_file {    <MemoryVoltage>1.5V</MemoryVoltage>}
   puts $mig_prj_file {    <C0_MEM_SIZE>1073741824</C0_MEM_SIZE>}
   puts $mig_prj_file {    <UserMemoryAddressMap>BANK_ROW_COLUMN</UserMemoryAddressMap>}
   puts $mig_prj_file {    <PinSelection>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="E10" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_addr[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="D6" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_addr[10]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="B7" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_addr[11]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="H12" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_addr[12]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="A10" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_addr[13]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="B9" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_addr[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="E11" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_addr[2]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="A9" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_addr[3]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="D11" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_addr[4]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="B6" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_addr[5]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="F9" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_addr[6]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="E8" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_addr[7]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="B10" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_addr[8]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="J8" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_addr[9]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="F8" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_ba[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="H7" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_ba[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="A7" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_ba[2]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="E7" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_cas_n"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15" PADName="F10" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_ck_n[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15" PADName="G10" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_ck_p[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="D10" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_cke[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="J11" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_cs_n[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="J3" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dm[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="F2" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dm[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="E1" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dm[2]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="C2" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dm[3]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="L12" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dm[4]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="G14" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dm[5]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="C16" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dm[6]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="C11" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dm[7]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="L1" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="H6" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[10]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="H3" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[11]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="G1" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[12]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="H2" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[13]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="G5" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[14]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="G4" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[15]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="E2" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[16]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="E3" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[17]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="D4" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[18]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="E5" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[19]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="L2" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="F4" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[20]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="F3" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[21]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="D1" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[22]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="D3" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[23]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="A2" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[24]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="B2" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[25]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="B4" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[26]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="B5" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[27]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="A3" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[28]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="B1" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[29]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="K5" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[2]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="C1" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[30]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="C4" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[31]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="K10" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[32]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="L9" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[33]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="K12" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[34]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="J9" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[35]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="K11" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[36]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="L10" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[37]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="J10" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[38]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="L7" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[39]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="J4" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[3]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="F14" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[40]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="F15" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[41]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="F13" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[42]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="G16" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[43]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="G15" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[44]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="E12" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[45]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="D13" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[46]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="E13" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[47]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="D15" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[48]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="E15" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[49]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="K1" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[4]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="D16" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[50]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="E16" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[51]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="C17" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[52]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="B16" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[53]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="D14" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[54]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="B17" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[55]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="B12" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[56]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="C12" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[57]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="A12" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[58]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="A14" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[59]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="L3" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[5]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="A13" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[60]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="B11" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[61]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="C14" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[62]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="B14" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[63]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="J5" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[6]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="K6" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[7]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="G6" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[8]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15_T_DCI" PADName="H4" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dq[9]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="K2" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_n[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="H1" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_n[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="D5" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_n[2]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="A4" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_n[3]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="K8" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_n[4]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="F12" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_n[5]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="E17" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_n[6]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="A15" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_n[7]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="K3" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_p[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="J1" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_p[1]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="E6" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_p[2]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="A5" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_p[3]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="L8" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_p[4]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="G12" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_p[5]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="F17" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_p[6]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15_T_DCI" PADName="B15" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_dqs_p[7]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="G7" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_odt[0]"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="H11" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_ras_n"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="LVCMOS15" PADName="G17" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_reset_n"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="SSTL15" PADName="F7" SLEW="FAST" VCCAUX_IO="NORMAL" name="ddr3_we_n"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15" PADName="G9" SLEW="" VCCAUX_IO="DONTCARE" name="sys_clk_n"/>}
   puts $mig_prj_file {      <Pin IN_TERM="" IOSTANDARD="DIFF_SSTL15" PADName="H9" SLEW="" VCCAUX_IO="DONTCARE" name="sys_clk_p"/>}
   puts $mig_prj_file {    </PinSelection>}
   puts $mig_prj_file {    <System_Control>}
   puts $mig_prj_file {      <Pin Bank="Select Bank" PADName="No connect" name="sys_rst"/>}
   puts $mig_prj_file {      <Pin Bank="Select Bank" PADName="No connect" name="init_calib_complete"/>}
   puts $mig_prj_file {      <Pin Bank="Select Bank" PADName="No connect" name="tg_compare_error"/>}
   puts $mig_prj_file {    </System_Control>}
   puts $mig_prj_file {    <TimingParameters>}
   puts $mig_prj_file {      <Parameters tcke="5" tfaw="30" tras="35" trcd="13.75" trefi="7.8" trfc="110" trp="13.75" trrd="6" trtp="7.5" twtr="7.5"/>}
   puts $mig_prj_file {    </TimingParameters>}
   puts $mig_prj_file {    <mrBurstLength name="Burst Length">8 - Fixed</mrBurstLength>}
   puts $mig_prj_file {    <mrBurstType name="Read Burst Type and Length">Sequential</mrBurstType>}
   puts $mig_prj_file {    <mrCasLatency name="CAS Latency">11</mrCasLatency>}
   puts $mig_prj_file {    <mrMode name="Mode">Normal</mrMode>}
   puts $mig_prj_file {    <mrDllReset name="DLL Reset">No</mrDllReset>}
   puts $mig_prj_file {    <mrPdMode name="DLL control for precharge PD">Slow Exit</mrPdMode>}
   puts $mig_prj_file {    <emrDllEnable name="DLL Enable">Enable</emrDllEnable>}
   puts $mig_prj_file {    <emrOutputDriveStrength name="Output Driver Impedance Control">RZQ/7</emrOutputDriveStrength>}
   puts $mig_prj_file {    <emrMirrorSelection name="Address Mirroring">Disable</emrMirrorSelection>}
   puts $mig_prj_file {    <emrCSSelection name="Controller Chip Select Pin">Enable</emrCSSelection>}
   puts $mig_prj_file {    <emrRTT name="RTT (nominal) - On Die Termination (ODT)">RZQ/6</emrRTT>}
   puts $mig_prj_file {    <emrPosted name="Additive Latency (AL)">0</emrPosted>}
   puts $mig_prj_file {    <emrOCD name="Write Leveling Enable">Disabled</emrOCD>}
   puts $mig_prj_file {    <emrDQS name="TDQS enable">Enabled</emrDQS>}
   puts $mig_prj_file {    <emrRDQS name="Qoff">Output Buffer Enabled</emrRDQS>}
   puts $mig_prj_file {    <mr2PartialArraySelfRefresh name="Partial-Array Self Refresh">Full Array</mr2PartialArraySelfRefresh>}
   puts $mig_prj_file {    <mr2CasWriteLatency name="CAS write latency">8</mr2CasWriteLatency>}
   puts $mig_prj_file {    <mr2AutoSelfRefresh name="Auto Self Refresh">Enabled</mr2AutoSelfRefresh>}
   puts $mig_prj_file {    <mr2SelfRefreshTempRange name="High Temparature Self Refresh Rate">Normal</mr2SelfRefreshTempRange>}
   puts $mig_prj_file {    <mr2RTTWR name="RTT_WR - Dynamic On Die Termination (ODT)">Dynamic ODT off</mr2RTTWR>}
   puts $mig_prj_file {    <PortInterface>AXI</PortInterface>}
   puts $mig_prj_file {    <AXIParameters>}
   puts $mig_prj_file {      <C0_C_RD_WR_ARB_ALGORITHM>RD_PRI_REG</C0_C_RD_WR_ARB_ALGORITHM>}
   puts $mig_prj_file {      <C0_S_AXI_ADDR_WIDTH>30</C0_S_AXI_ADDR_WIDTH>}
   puts $mig_prj_file {      <C0_S_AXI_DATA_WIDTH>512</C0_S_AXI_DATA_WIDTH>}
   puts $mig_prj_file {      <C0_S_AXI_ID_WIDTH>4</C0_S_AXI_ID_WIDTH>}
   puts $mig_prj_file {      <C0_S_AXI_SUPPORTS_NARROW_BURST>0</C0_S_AXI_SUPPORTS_NARROW_BURST>}
   puts $mig_prj_file {    </AXIParameters>}
   puts $mig_prj_file {  </Controller>}
   puts $mig_prj_file {</Project>}

   close $mig_prj_file
}
# End of write_mig_file_static_design_mig_7series_0_0()



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

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pci_exp


  # Create pins
  create_bd_pin -dir I -type clk sys_clk
  create_bd_pin -dir I -type rst sys_rst_n
  create_bd_pin -dir O user_lnk_up
  create_bd_pin -dir O -type clk pcie_axi_clk
  create_bd_pin -dir O -type rst pcie_axi_aresetn

  # Create instance: xdma_0, and set properties
  set xdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_0 ]
  set_property -dict [list \
    CONFIG.axi_data_width {64_bit} \
    CONFIG.axisten_freq {125} \
    CONFIG.cfg_mgmt_if {false} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.pcie_id_if {true} \
    CONFIG.pf0_link_status_slot_clock_config {true} \
    CONFIG.pl_link_cap_max_link_speed {2.5_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X4} \
    CONFIG.xdma_pcie_64bit_en {true} \
    CONFIG.xdma_pcie_prefetchable {true} \
    CONFIG.xdma_rnum_chnl {2} \
    CONFIG.xdma_wnum_chnl {2} \
  ] $xdma_0


  # Create instance: pcie_conf
  create_hier_cell_pcie_conf $hier_obj pcie_conf

  # Create interface connections
  connect_bd_intf_net -intf_net xdma_0_M_AXI [get_bd_intf_pins M_AXI] [get_bd_intf_pins xdma_0/M_AXI]
  connect_bd_intf_net -intf_net xdma_0_pcie_mgt [get_bd_intf_pins pci_exp] [get_bd_intf_pins xdma_0/pcie_mgt]

  # Create port connections
  connect_bd_net -net X0007_dout  [get_bd_pins pcie_conf/subsys_id] \
  [get_bd_pins xdma_0/cfg_subsys_id_pf0]
  connect_bd_net -net X10EE_dout  [get_bd_pins pcie_conf/vend_id_subsys_vend_id] \
  [get_bd_pins xdma_0/cfg_subsys_vend_id] \
  [get_bd_pins xdma_0/cfg_vend_id]
  connect_bd_net -net X9022_dout  [get_bd_pins pcie_conf/dev_id] \
  [get_bd_pins xdma_0/cfg_dev_id_pf0]
  connect_bd_net -net sys_clk_2  [get_bd_pins sys_clk] \
  [get_bd_pins xdma_0/sys_clk]
  connect_bd_net -net sys_rst_n_1  [get_bd_pins sys_rst_n] \
  [get_bd_pins xdma_0/sys_rst_n]
  connect_bd_net -net xdma_0_user_lnk_up  [get_bd_pins xdma_0/user_lnk_up] \
  [get_bd_pins user_lnk_up]
  connect_bd_net -net xilinx_dma_pcie_ep_0_user_clk  [get_bd_pins xdma_0/axi_aclk] \
  [get_bd_pins pcie_axi_clk]
  connect_bd_net -net xilinx_dma_pcie_ep_0_user_resetn  [get_bd_pins xdma_0/axi_aresetn] \
  [get_bd_pins pcie_axi_aresetn]
  connect_bd_net -net xlconstant_2_dout  [get_bd_pins pcie_conf/rev_id] \
  [get_bd_pins xdma_0/cfg_rev_id_pf0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: DRAM
proc create_hier_cell_DRAM { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_DRAM() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3_sdram


  # Create pins
  create_bd_pin -dir I -type clk mstatic_axi_clk_0
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I -type rst aux_reset_in
  create_bd_pin -dir I -type clk sys_clk
  create_bd_pin -dir I -type rst sys_rst_n

  # Create instance: axi_dwidth_converter_0, and set properties
  set axi_dwidth_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 axi_dwidth_converter_0 ]
  set_property CONFIG.SI_DATA_WIDTH {32} $axi_dwidth_converter_0


  # Create instance: axi_clock_converter_0, and set properties
  set axi_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clock_converter_0 ]

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.USE_LOCKED {false} \
    CONFIG.USE_RESET {false} \
  ] $clk_wiz_0


  # Create instance: mig_7series_0, and set properties
  set mig_7series_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0 ]

  # Generate the PRJ File for MIG
  set str_mig_folder [get_property IP_DIR [ get_ips [ get_property CONFIG.Component_Name $mig_7series_0 ] ] ]
  set str_mig_file_name mig_b.prj
  set str_mig_file_path ${str_mig_folder}/${str_mig_file_name}
  write_mig_file_static_design_mig_7series_0_0 $str_mig_file_path

  set_property -dict [list \
    CONFIG.BOARD_MIG_PARAM {ddr3_sdram} \
    CONFIG.MIG_DONT_TOUCH_PARAM {Custom} \
    CONFIG.RESET_BOARD_INTERFACE {Custom} \
    CONFIG.XML_INPUT_FILE {mig_b.prj} \
  ] $mig_7series_0


  # Create interface connections
  connect_bd_intf_net -intf_net axi_clock_converter_0_M_AXI [get_bd_intf_pins axi_clock_converter_0/M_AXI] [get_bd_intf_pins axi_dwidth_converter_0/S_AXI]
  connect_bd_intf_net -intf_net axi_dwidth_converter_0_M_AXI [get_bd_intf_pins axi_dwidth_converter_0/M_AXI] [get_bd_intf_pins mig_7series_0/S_AXI]
  connect_bd_intf_net -intf_net axi_smc_M02_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_clock_converter_0/S_AXI]
  connect_bd_intf_net -intf_net mig_7series_0_DDR3 [get_bd_intf_pins ddr3_sdram] [get_bd_intf_pins mig_7series_0/DDR3]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1  [get_bd_pins clk_wiz_0/clk_out1] \
  [get_bd_pins mig_7series_0/sys_clk_i]
  connect_bd_net -net mig_7series_0_ui_clk  [get_bd_pins mig_7series_0/ui_clk] \
  [get_bd_pins proc_sys_reset_0/slowest_sync_clk] \
  [get_bd_pins axi_dwidth_converter_0/s_axi_aclk] \
  [get_bd_pins axi_clock_converter_0/m_axi_aclk]
  connect_bd_net -net mig_7series_0_ui_clk_sync_rst  [get_bd_pins mig_7series_0/ui_clk_sync_rst] \
  [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net rst_mig_7series_0_200M_peripheral_aresetn  [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
  [get_bd_pins mig_7series_0/aresetn] \
  [get_bd_pins axi_dwidth_converter_0/s_axi_aresetn] \
  [get_bd_pins axi_clock_converter_0/m_axi_aresetn]
  connect_bd_net -net rst_ps7_0_50M_peripheral_aresetn  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins axi_clock_converter_0/s_axi_aresetn]
  connect_bd_net -net sys_clk_2  [get_bd_pins sys_clk] \
  [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net sys_rst_n_1  [get_bd_pins sys_rst_n] \
  [get_bd_pins mig_7series_0/sys_rst]
  connect_bd_net -net xilinx_dma_pcie_ep_0_user_clk  [get_bd_pins mstatic_axi_clk_0] \
  [get_bd_pins axi_clock_converter_0/s_axi_aclk]
  connect_bd_net -net xilinx_dma_pcie_ep_0_user_resetn  [get_bd_pins aux_reset_in] \
  [get_bd_pins proc_sys_reset_0/aux_reset_in]

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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 m_static_to_sdman

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_static_from_sdman

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_static_to_sdman

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 s_static_from_sdman

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI


  # Create pins
  create_bd_pin -dir I -type clk axi_clk
  create_bd_pin -dir I -type rst resetn
  create_bd_pin -dir O -from 0 -to 0 mstatic_aresetn_0

  # Create instance: dfx_axi_shutdown_man_1, and set properties
  set dfx_axi_shutdown_man_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dfx_axi_shutdown_manager:1.0 dfx_axi_shutdown_man_1 ]
  set_property CONFIG.RP_IS_MASTER {false} $dfx_axi_shutdown_man_1


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
  set_property CONFIG.RP_IS_MASTER {true} $dfx_axi_shutdown_man_0


  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.C_MON_TYPE {NATIVE} \
    CONFIG.C_NUM_OF_PROBES {8} \
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


  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [list \
    CONFIG.NUM_MI {3} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_1


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins smartconnect_1/S00_AXI] [get_bd_intf_pins S00_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins smartconnect_1/M00_AXI] [get_bd_intf_pins M00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_1 [get_bd_intf_pins s_static_to_sdman] [get_bd_intf_pins dfx_axi_shutdown_man_0/S_AXI]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins m_static_to_sdman] [get_bd_intf_pins dfx_axi_shutdown_man_1/S_AXI]
  connect_bd_intf_net -intf_net dfx_axi_shutdown_man_0_M_AXI [get_bd_intf_pins s_static_from_sdman] [get_bd_intf_pins dfx_axi_shutdown_man_0/M_AXI]
  connect_bd_intf_net -intf_net dfx_axi_shutdown_man_1_M_AXI [get_bd_intf_pins m_static_from_sdman] [get_bd_intf_pins dfx_axi_shutdown_man_1/M_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M01_AXI [get_bd_intf_pins axi_dfx_control/S_AXI] [get_bd_intf_pins smartconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M02_AXI [get_bd_intf_pins axi_gpio_user_logic_aresetn/S_AXI] [get_bd_intf_pins smartconnect_1/M02_AXI]

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
  [get_bd_pins system_ila_0/probe6]
  connect_bd_net -net dfx_axi_shutdown_man_0_shutdown_requested  [get_bd_pins dfx_axi_shutdown_man_0/shutdown_requested] \
  [get_bd_pins util_vector_logic_0/Op2] \
  [get_bd_pins system_ila_0/probe1]
  connect_bd_net -net dfx_axi_shutdown_man_0_wr_in_shutdown  [get_bd_pins dfx_axi_shutdown_man_0/wr_in_shutdown] \
  [get_bd_pins system_ila_0/probe4]
  connect_bd_net -net dfx_axi_shutdown_man_1_in_shutdown  [get_bd_pins dfx_axi_shutdown_man_1/in_shutdown] \
  [get_bd_pins util_vector_logic_1/Op1] \
  [get_bd_pins system_ila_0/probe2]
  connect_bd_net -net dfx_axi_shutdown_man_1_rd_in_shutdown  [get_bd_pins dfx_axi_shutdown_man_1/rd_in_shutdown] \
  [get_bd_pins system_ila_0/probe7]
  connect_bd_net -net dfx_axi_shutdown_man_1_shutdown_requested  [get_bd_pins dfx_axi_shutdown_man_1/shutdown_requested] \
  [get_bd_pins util_vector_logic_0/Op1] \
  [get_bd_pins system_ila_0/probe0]
  connect_bd_net -net dfx_axi_shutdown_man_1_wr_in_shutdown  [get_bd_pins dfx_axi_shutdown_man_1/wr_in_shutdown] \
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
  [get_bd_pins axi_gpio_user_logic_aresetn/s_axi_aclk] \
  [get_bd_pins smartconnect_1/aclk]
  connect_bd_net -net xilinx_dma_pcie_ep_0_user_resetn  [get_bd_pins resetn] \
  [get_bd_pins dfx_axi_shutdown_man_0/resetn] \
  [get_bd_pins dfx_axi_shutdown_man_1/resetn] \
  [get_bd_pins axi_dfx_control/s_axi_aresetn] \
  [get_bd_pins util_vector_logic_2/Op2] \
  [get_bd_pins axi_gpio_user_logic_aresetn/s_axi_aresetn] \
  [get_bd_pins smartconnect_1/aresetn]
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
  set led_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 led_4bits ]

  set ddr3_sdram [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3_sdram ]

  set mstatic_axi_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 mstatic_axi_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   ] $mstatic_axi_0

  set sstatic_axi_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 sstatic_axi_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
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

  set pci_exp [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pci_exp ]


  # Create ports
  set sys_rst_n [ create_bd_port -dir I -type rst sys_rst_n ]
  set sys_clk [ create_bd_port -dir I -type clk sys_clk ]
  set mstatic_axi_clk_0 [ create_bd_port -dir O -type clk mstatic_axi_clk_0 ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {mstatic_axi_0:sstatic_axi_0} \
 ] $mstatic_axi_clk_0
  set mstatic_aresetn_0 [ create_bd_port -dir O -from 0 -to 0 -type rst mstatic_aresetn_0 ]

  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {1} \
    CONFIG.NUM_MI {3} \
    CONFIG.NUM_SI {2} \
  ] $axi_smc


  # Create instance: DFX_logic
  create_hier_cell_DFX_logic [current_bd_instance .] DFX_logic

  # Create instance: axi_gpio_leds, and set properties
  set axi_gpio_leds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_leds ]
  set_property -dict [list \
    CONFIG.GPIO_BOARD_INTERFACE {led_4bits} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $axi_gpio_leds


  # Create instance: DRAM
  create_hier_cell_DRAM [current_bd_instance .] DRAM

  # Create instance: PCIe
  create_hier_cell_PCIe [current_bd_instance .] PCIe

  # Create interface connections
  connect_bd_intf_net -intf_net DFX_logic_M00_AXI [get_bd_intf_pins axi_gpio_leds/S_AXI] [get_bd_intf_pins DFX_logic/M00_AXI]
  connect_bd_intf_net -intf_net DFX_logic_s_static_from_sdman [get_bd_intf_pins DFX_logic/s_static_from_sdman] [get_bd_intf_pins axi_smc/S01_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_1 [get_bd_intf_ports sstatic_axi_0] [get_bd_intf_pins DFX_logic/s_static_to_sdman]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports led_4bits] [get_bd_intf_pins axi_gpio_leds/GPIO]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins DFX_logic/m_static_to_sdman]
  connect_bd_intf_net -intf_net axi_smc_M01_AXI [get_bd_intf_pins axi_smc/M01_AXI] [get_bd_intf_pins DFX_logic/S00_AXI]
  connect_bd_intf_net -intf_net axi_smc_M02_AXI [get_bd_intf_pins DRAM/S_AXI] [get_bd_intf_pins axi_smc/M02_AXI]
  connect_bd_intf_net -intf_net dfx_axi_shutdown_man_1_M_AXI [get_bd_intf_ports mstatic_axi_0] [get_bd_intf_pins DFX_logic/m_static_from_sdman]
  connect_bd_intf_net -intf_net mig_7series_0_DDR3 [get_bd_intf_ports ddr3_sdram] [get_bd_intf_pins DRAM/ddr3_sdram]
  connect_bd_intf_net -intf_net xdma_0_M_AXI [get_bd_intf_pins PCIe/M_AXI] [get_bd_intf_pins axi_smc/S00_AXI]
  connect_bd_intf_net -intf_net xdma_0_pcie_mgt [get_bd_intf_ports pci_exp] [get_bd_intf_pins PCIe/pci_exp]

  # Create port connections
  connect_bd_net -net sys_clk_2  [get_bd_ports sys_clk] \
  [get_bd_pins DRAM/sys_clk] \
  [get_bd_pins PCIe/sys_clk]
  connect_bd_net -net sys_rst_n_1  [get_bd_ports sys_rst_n] \
  [get_bd_pins DRAM/sys_rst_n]
  connect_bd_net -net util_vector_logic_0_Res  [get_bd_pins DFX_logic/mstatic_aresetn_0] \
  [get_bd_ports mstatic_aresetn_0]
  connect_bd_net -net xilinx_dma_pcie_ep_0_user_clk  [get_bd_pins PCIe/pcie_axi_clk] \
  [get_bd_ports mstatic_axi_clk_0] \
  [get_bd_pins axi_smc/aclk] \
  [get_bd_pins DFX_logic/axi_clk] \
  [get_bd_pins axi_gpio_leds/s_axi_aclk] \
  [get_bd_pins DRAM/mstatic_axi_clk_0]
  connect_bd_net -net xilinx_dma_pcie_ep_0_user_resetn  [get_bd_pins PCIe/pcie_axi_aresetn] \
  [get_bd_pins DRAM/aux_reset_in] \
  [get_bd_pins axi_smc/aresetn] \
  [get_bd_pins axi_gpio_leds/s_axi_aresetn] \
  [get_bd_pins DFX_logic/resetn] \
  [get_bd_pins DRAM/s_axi_aresetn]

  # Create address segments
  assign_bd_address -offset 0x80010000 -range 0x00010000 -with_name SEG_axi_gpio_0_Reg -target_address_space [get_bd_addr_spaces PCIe/xdma_0/M_AXI] [get_bd_addr_segs axi_gpio_leds/S_AXI/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x00010000 -with_name SEG_axi_gpio_1_Reg -target_address_space [get_bd_addr_spaces PCIe/xdma_0/M_AXI] [get_bd_addr_segs DFX_logic/axi_dfx_control/S_AXI/Reg] -force
  assign_bd_address -offset 0x80020000 -range 0x00010000 -with_name SEG_axi_gpio_1_Reg_1 -target_address_space [get_bd_addr_spaces PCIe/xdma_0/M_AXI] [get_bd_addr_segs DFX_logic/axi_gpio_user_logic_aresetn/S_AXI/Reg] -force
  assign_bd_address -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces PCIe/xdma_0/M_AXI] [get_bd_addr_segs DRAM/mig_7series_0/memmap/memaddr] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces PCIe/xdma_0/M_AXI] [get_bd_addr_segs mstatic_axi_0/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces sstatic_axi_0] [get_bd_addr_segs DFX_logic/axi_dfx_control/S_AXI/Reg] -force
  assign_bd_address -offset 0x80010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces sstatic_axi_0] [get_bd_addr_segs axi_gpio_leds/S_AXI/Reg] -force
  assign_bd_address -offset 0x80020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces sstatic_axi_0] [get_bd_addr_segs DFX_logic/axi_gpio_user_logic_aresetn/S_AXI/Reg] -force
  assign_bd_address -offset 0x40000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces sstatic_axi_0] [get_bd_addr_segs DRAM/mig_7series_0/memmap/memaddr] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces sstatic_axi_0] [get_bd_addr_segs mstatic_axi_0/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


