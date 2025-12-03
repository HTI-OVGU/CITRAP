create_clock -period 6.400 [get_ports Q2_CLK1_GTREFCLK_PAD_P_IN]

create_clock -period 5.000 -name drpclk_in_i [get_ports DRP_CLK_IN_P]

set_property PACKAGE_PIN AC8 [get_ports Q2_CLK1_GTREFCLK_PAD_P_IN]
set_property PACKAGE_PIN AC7 [get_ports Q2_CLK1_GTREFCLK_PAD_N_IN]

create_clock -period 10.000 -name sys_clk [get_ports sys_clk_p]

set_property IOSTANDARD LVCMOS15 [get_ports sys_rst_n_i]
set_property PULLTYPE PULLUP [get_ports sys_rst_n_i]
set_property PACKAGE_PIN AK23 [get_ports sys_rst_n_i]
set_false_path -from [get_ports sys_rst_n_i]

#set_property IOSTANDARD LVCMOS25 [get_ports rst_sw]
#set_property PULLTYPE PULLUP [get_ports rst_sw]
#set_property PACKAGE_PIN AK25 [get_ports rst_sw]

set_property IOSTANDARD LVCMOS15 [get_ports led_0]
set_property IOSTANDARD LVCMOS15 [get_ports led_1]
set_property IOSTANDARD LVCMOS15 [get_ports led_2]
set_property IOSTANDARD LVCMOS15 [get_ports led_3]

set_property PACKAGE_PIN W21 [get_ports led_2]
set_property PACKAGE_PIN A17 [get_ports led_3]
set_property PACKAGE_PIN G2 [get_ports led_1]
set_property PACKAGE_PIN Y21 [get_ports led_0]
set_false_path -to [get_ports -filter NAME=~led_*]

set_property PACKAGE_PIN N8 [get_ports sys_clk_p]
set_property PACKAGE_PIN N7 [get_ports sys_clk_n]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets sys_clk]

######################################
# PCI Express x4 Interface Constraints
######################################

set_property PACKAGE_PIN P5 [get_ports {pci_exp_rxn[0]}]
set_property PACKAGE_PIN P6 [get_ports {pci_exp_rxp[0]}]
set_property PACKAGE_PIN N3 [get_ports {pci_exp_txn[0]}]
set_property PACKAGE_PIN N4 [get_ports {pci_exp_txp[0]}]

set_property PACKAGE_PIN T5 [get_ports {pci_exp_rxn[1]}]
set_property PACKAGE_PIN T6 [get_ports {pci_exp_rxp[1]}]
set_property PACKAGE_PIN P1 [get_ports {pci_exp_txn[1]}]
set_property PACKAGE_PIN P2 [get_ports {pci_exp_txp[1]}]

set_property PACKAGE_PIN U3 [get_ports {pci_exp_rxn[2]}]
set_property PACKAGE_PIN U4 [get_ports {pci_exp_rxp[2]}]
set_property PACKAGE_PIN R3 [get_ports {pci_exp_txn[2]}]
set_property PACKAGE_PIN R4 [get_ports {pci_exp_txp[2]}]

set_property PACKAGE_PIN V5 [get_ports {pci_exp_rxn[3]}]
set_property PACKAGE_PIN V6 [get_ports {pci_exp_rxp[3]}]
set_property PACKAGE_PIN T1 [get_ports {pci_exp_txn[3]}]
set_property PACKAGE_PIN T2 [get_ports {pci_exp_txp[3]}]



