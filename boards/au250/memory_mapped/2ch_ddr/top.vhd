--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
--Date        : Wed Oct 29 13:39:15 2025
--Host        : burtsev-office-g3 running 64-bit Debian GNU/Linux 12 (bookworm)
--Command     : generate_target static_design_wrapper.bd
--Design      : static_design_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;
entity top is
  port (
    ddr4_sdram_c0_act_n : out STD_LOGIC;
    ddr4_sdram_c0_adr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    ddr4_sdram_c0_ba : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr4_sdram_c0_bg : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr4_sdram_c0_ck_c : out STD_LOGIC;
    ddr4_sdram_c0_ck_t : out STD_LOGIC;
    ddr4_sdram_c0_cke : out STD_LOGIC;
    ddr4_sdram_c0_cs_n : out STD_LOGIC;
    ddr4_sdram_c0_dq : inout STD_LOGIC_VECTOR ( 71 downto 0 );
    ddr4_sdram_c0_dqs_c : inout STD_LOGIC_VECTOR ( 17 downto 0 );
    ddr4_sdram_c0_dqs_t : inout STD_LOGIC_VECTOR ( 17 downto 0 );
    ddr4_sdram_c0_odt : out STD_LOGIC;
    ddr4_sdram_c0_par : out STD_LOGIC;
    ddr4_sdram_c0_reset_n : out STD_LOGIC;
    ddr4_sdram_c1_act_n : out STD_LOGIC;
    ddr4_sdram_c1_adr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    ddr4_sdram_c1_ba : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr4_sdram_c1_bg : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr4_sdram_c1_ck_c : out STD_LOGIC;
    ddr4_sdram_c1_ck_t : out STD_LOGIC;
    ddr4_sdram_c1_cke : out STD_LOGIC;
    ddr4_sdram_c1_cs_n : out STD_LOGIC;
    ddr4_sdram_c1_dq : inout STD_LOGIC_VECTOR ( 71 downto 0 );
    ddr4_sdram_c1_dqs_c : inout STD_LOGIC_VECTOR ( 17 downto 0 );
    ddr4_sdram_c1_dqs_t : inout STD_LOGIC_VECTOR ( 17 downto 0 );
    ddr4_sdram_c1_odt : out STD_LOGIC;
    ddr4_sdram_c1_par : out STD_LOGIC;
    ddr4_sdram_c1_reset_n : out STD_LOGIC;
    default_300mhz_clk0_clk_n : in STD_LOGIC;
    default_300mhz_clk0_clk_p : in STD_LOGIC;
    default_300mhz_clk1_clk_n : in STD_LOGIC;
    default_300mhz_clk1_clk_p : in STD_LOGIC;
    pci_express_x16_rxn : in STD_LOGIC_VECTOR ( 15 downto 0 );
    pci_express_x16_rxp : in STD_LOGIC_VECTOR ( 15 downto 0 );
    pci_express_x16_txn : out STD_LOGIC_VECTOR ( 15 downto 0 );
    pci_express_x16_txp : out STD_LOGIC_VECTOR ( 15 downto 0 );
    pcie_perstn : in STD_LOGIC;
    pcie_refclk_clk_n : in STD_LOGIC;
    pcie_refclk_clk_p : in STD_LOGIC
  );
end top;

architecture STRUCTURE of top is
	signal pci_refclk           : std_logic;
	signal pci_refclk_gt           : std_logic;

    signal sys_clk           : std_logic;
	signal sys_rst_n : std_logic;

    -- Additional signals for AXI connections between wrappers
    signal axi_clk : STD_LOGIC;
    signal axi_aresetn : STD_LOGIC;

    -- AXI signals for static_design_wrapper mstatic interface
    signal mstatic_axi_0_araddr : STD_LOGIC_VECTOR(36 downto 0);
    signal mstatic_axi_0_arburst : STD_LOGIC_VECTOR(1 downto 0);
    signal mstatic_axi_0_arcache : STD_LOGIC_VECTOR(3 downto 0);
    signal mstatic_axi_0_arid : STD_LOGIC_VECTOR(0 to 0);
    signal mstatic_axi_0_arlen : STD_LOGIC_VECTOR(7 downto 0);
    signal mstatic_axi_0_arlock : STD_LOGIC;
    signal mstatic_axi_0_arprot : STD_LOGIC_VECTOR(2 downto 0);
    signal mstatic_axi_0_arqos : STD_LOGIC_VECTOR(3 downto 0);
    signal mstatic_axi_0_arready : STD_LOGIC;
    signal mstatic_axi_0_arregion : STD_LOGIC_VECTOR(3 downto 0);
    signal mstatic_axi_0_arsize : STD_LOGIC_VECTOR(2 downto 0);
    signal mstatic_axi_0_arvalid : STD_LOGIC;
    signal mstatic_axi_0_awaddr : STD_LOGIC_VECTOR(36 downto 0);
    signal mstatic_axi_0_awburst : STD_LOGIC_VECTOR(1 downto 0);
    signal mstatic_axi_0_awcache : STD_LOGIC_VECTOR(3 downto 0);
    signal mstatic_axi_0_awid : STD_LOGIC_VECTOR(0 to 0);
    signal mstatic_axi_0_awlen : STD_LOGIC_VECTOR(7 downto 0);
    signal mstatic_axi_0_awlock : STD_LOGIC;
    signal mstatic_axi_0_awprot : STD_LOGIC_VECTOR(2 downto 0);
    signal mstatic_axi_0_awqos : STD_LOGIC_VECTOR(3 downto 0);
    signal mstatic_axi_0_awready : STD_LOGIC;
    signal mstatic_axi_0_awregion : STD_LOGIC_VECTOR(3 downto 0);
    signal mstatic_axi_0_awsize : STD_LOGIC_VECTOR(2 downto 0);
    signal mstatic_axi_0_awvalid : STD_LOGIC;
    signal mstatic_axi_0_bid : STD_LOGIC_VECTOR(0 to 0);
    signal mstatic_axi_0_bready : STD_LOGIC;
    signal mstatic_axi_0_bresp : STD_LOGIC_VECTOR(1 downto 0);
    signal mstatic_axi_0_bvalid : STD_LOGIC;
    signal mstatic_axi_0_rdata : STD_LOGIC_VECTOR(511 downto 0);
    signal mstatic_axi_0_rid : STD_LOGIC_VECTOR(0 to 0);
    signal mstatic_axi_0_rlast : STD_LOGIC;
    signal mstatic_axi_0_rready : STD_LOGIC;
    signal mstatic_axi_0_rresp : STD_LOGIC_VECTOR(1 downto 0);
    signal mstatic_axi_0_rvalid : STD_LOGIC;
    signal mstatic_axi_0_wdata : STD_LOGIC_VECTOR(511 downto 0);
    signal mstatic_axi_0_wlast : STD_LOGIC;
    signal mstatic_axi_0_wready : STD_LOGIC;
    signal mstatic_axi_0_wstrb : STD_LOGIC_VECTOR(63 downto 0);
    signal mstatic_axi_0_wvalid : STD_LOGIC;

    -- AXI signals for static_design_wrapper sstatic interface (connects to dfx_test_partition sstatic)
    signal sstatic_axi_0_araddr : STD_LOGIC_VECTOR(37 downto 0);
    signal sstatic_axi_0_arburst : STD_LOGIC_VECTOR(1 downto 0);
    signal sstatic_axi_0_arcache : STD_LOGIC_VECTOR(3 downto 0);
    signal sstatic_axi_0_arid : STD_LOGIC_VECTOR(0 to 0);
    signal sstatic_axi_0_arlen : STD_LOGIC_VECTOR(7 downto 0);
    signal sstatic_axi_0_arlock : STD_LOGIC;
    signal sstatic_axi_0_arprot : STD_LOGIC_VECTOR(2 downto 0);
    signal sstatic_axi_0_arqos : STD_LOGIC_VECTOR(3 downto 0);
    signal sstatic_axi_0_arready : STD_LOGIC;
    signal sstatic_axi_0_arregion : STD_LOGIC_VECTOR(3 downto 0);
    signal sstatic_axi_0_arsize : STD_LOGIC_VECTOR(2 downto 0);
    signal sstatic_axi_0_arvalid : STD_LOGIC;
    signal sstatic_axi_0_awaddr : STD_LOGIC_VECTOR(37 downto 0);
    signal sstatic_axi_0_awburst : STD_LOGIC_VECTOR(1 downto 0);
    signal sstatic_axi_0_awcache : STD_LOGIC_VECTOR(3 downto 0);
    signal sstatic_axi_0_awid : STD_LOGIC_VECTOR(0 to 0);
    signal sstatic_axi_0_awlen : STD_LOGIC_VECTOR(7 downto 0);
    signal sstatic_axi_0_awlock : STD_LOGIC;
    signal sstatic_axi_0_awprot : STD_LOGIC_VECTOR(2 downto 0);
    signal sstatic_axi_0_awqos : STD_LOGIC_VECTOR(3 downto 0);
    signal sstatic_axi_0_awready : STD_LOGIC;
    signal sstatic_axi_0_awregion : STD_LOGIC_VECTOR(3 downto 0);
    signal sstatic_axi_0_awsize : STD_LOGIC_VECTOR(2 downto 0);
    signal sstatic_axi_0_awvalid : STD_LOGIC;
    signal sstatic_axi_0_bid : STD_LOGIC_VECTOR(0 to 0);
    signal sstatic_axi_0_bready : STD_LOGIC;
    signal sstatic_axi_0_bresp : STD_LOGIC_VECTOR(1 downto 0);
    signal sstatic_axi_0_bvalid : STD_LOGIC;
    signal sstatic_axi_0_rdata : STD_LOGIC_VECTOR(511 downto 0);
    signal sstatic_axi_0_rid : STD_LOGIC_VECTOR(0 to 0);
    signal sstatic_axi_0_rlast : STD_LOGIC;
    signal sstatic_axi_0_rready : STD_LOGIC;
    signal sstatic_axi_0_rresp : STD_LOGIC_VECTOR(1 downto 0);
    signal sstatic_axi_0_rvalid : STD_LOGIC;
    signal sstatic_axi_0_wdata : STD_LOGIC_VECTOR(511 downto 0);
    signal sstatic_axi_0_wlast : STD_LOGIC;
    signal sstatic_axi_0_wready : STD_LOGIC;
    signal sstatic_axi_0_wstrb : STD_LOGIC_VECTOR(63 downto 0);
    signal sstatic_axi_0_wvalid : STD_LOGIC;

  component static_design_wrapper is
  port (
    pcie_perstn : in STD_LOGIC;
    mstatic_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    axi_clk : out STD_LOGIC;
    mstatic_axi_0_araddr : out STD_LOGIC_VECTOR ( 36 downto 0 );
    mstatic_axi_0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_arid : out STD_LOGIC_VECTOR ( 0 to 0 );
    mstatic_axi_0_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    mstatic_axi_0_arlock : out STD_LOGIC;
    mstatic_axi_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_arready : in STD_LOGIC;
    mstatic_axi_0_arregion : out STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_arvalid : out STD_LOGIC;
    mstatic_axi_0_awaddr : out STD_LOGIC_VECTOR ( 36 downto 0 );
    mstatic_axi_0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_awid : out STD_LOGIC_VECTOR ( 0 to 0 );
    mstatic_axi_0_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    mstatic_axi_0_awlock : out STD_LOGIC;
    mstatic_axi_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_awready : in STD_LOGIC;
    mstatic_axi_0_awregion : out STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_awvalid : out STD_LOGIC;
    mstatic_axi_0_bid : in STD_LOGIC_VECTOR ( 0 to 0 );
    mstatic_axi_0_bready : out STD_LOGIC;
    mstatic_axi_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_bvalid : in STD_LOGIC;
    mstatic_axi_0_rdata : in STD_LOGIC_VECTOR ( 511 downto 0 );
    mstatic_axi_0_rid : in STD_LOGIC_VECTOR ( 0 to 0 );
    mstatic_axi_0_rlast : in STD_LOGIC;
    mstatic_axi_0_rready : out STD_LOGIC;
    mstatic_axi_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_rvalid : in STD_LOGIC;
    mstatic_axi_0_wdata : out STD_LOGIC_VECTOR ( 511 downto 0 );
    mstatic_axi_0_wlast : out STD_LOGIC;
    mstatic_axi_0_wready : in STD_LOGIC;
    mstatic_axi_0_wstrb : out STD_LOGIC_VECTOR ( 63 downto 0 );
    mstatic_axi_0_wvalid : out STD_LOGIC;
    ddr4_sdram_c0_act_n : out STD_LOGIC;
    ddr4_sdram_c0_adr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    ddr4_sdram_c0_ba : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr4_sdram_c0_bg : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr4_sdram_c0_ck_c : out STD_LOGIC;
    ddr4_sdram_c0_ck_t : out STD_LOGIC;
    ddr4_sdram_c0_cke : out STD_LOGIC;
    ddr4_sdram_c0_cs_n : out STD_LOGIC;
    ddr4_sdram_c0_dq : inout STD_LOGIC_VECTOR ( 71 downto 0 );
    ddr4_sdram_c0_dqs_c : inout STD_LOGIC_VECTOR ( 17 downto 0 );
    ddr4_sdram_c0_dqs_t : inout STD_LOGIC_VECTOR ( 17 downto 0 );
    ddr4_sdram_c0_odt : out STD_LOGIC;
    ddr4_sdram_c0_par : out STD_LOGIC;
    ddr4_sdram_c0_reset_n : out STD_LOGIC;
    ddr4_sdram_c1_act_n : out STD_LOGIC;
    ddr4_sdram_c1_adr : out STD_LOGIC_VECTOR ( 16 downto 0 );
    ddr4_sdram_c1_ba : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr4_sdram_c1_bg : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr4_sdram_c1_ck_c : out STD_LOGIC;
    ddr4_sdram_c1_ck_t : out STD_LOGIC;
    ddr4_sdram_c1_cke : out STD_LOGIC;
    ddr4_sdram_c1_cs_n : out STD_LOGIC;
    ddr4_sdram_c1_dq : inout STD_LOGIC_VECTOR ( 71 downto 0 );
    ddr4_sdram_c1_dqs_c : inout STD_LOGIC_VECTOR ( 17 downto 0 );
    ddr4_sdram_c1_dqs_t : inout STD_LOGIC_VECTOR ( 17 downto 0 );
    ddr4_sdram_c1_odt : out STD_LOGIC;
    ddr4_sdram_c1_par : out STD_LOGIC;
    ddr4_sdram_c1_reset_n : out STD_LOGIC;
    default_300mhz_clk0_clk_n : in STD_LOGIC;
    default_300mhz_clk0_clk_p : in STD_LOGIC;
    default_300mhz_clk1_clk_n : in STD_LOGIC;
    default_300mhz_clk1_clk_p : in STD_LOGIC;
    pcie_refclk_clk_n : in STD_LOGIC;
    pcie_refclk_clk_p : in STD_LOGIC;
    sstatic_axi_0_araddr : in STD_LOGIC_VECTOR ( 36 downto 0 );
    sstatic_axi_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_arid : in STD_LOGIC_VECTOR ( 0 to 0 );
    sstatic_axi_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    sstatic_axi_0_arlock : in STD_LOGIC;
    sstatic_axi_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    sstatic_axi_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_arready : out STD_LOGIC;
    sstatic_axi_0_arregion : in STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    sstatic_axi_0_arvalid : in STD_LOGIC;
    sstatic_axi_0_awaddr : in STD_LOGIC_VECTOR ( 36 downto 0 );
    sstatic_axi_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_awid : in STD_LOGIC_VECTOR ( 0 to 0 );
    sstatic_axi_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    sstatic_axi_0_awlock : in STD_LOGIC;
    sstatic_axi_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    sstatic_axi_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_awready : out STD_LOGIC;
    sstatic_axi_0_awregion : in STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    sstatic_axi_0_awvalid : in STD_LOGIC;
    sstatic_axi_0_bid : out STD_LOGIC_VECTOR ( 0 to 0 );
    sstatic_axi_0_bready : in STD_LOGIC;
    sstatic_axi_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_bvalid : out STD_LOGIC;
    sstatic_axi_0_rdata : out STD_LOGIC_VECTOR ( 511 downto 0 );
    sstatic_axi_0_rid : out STD_LOGIC_VECTOR ( 0 to 0 );
    sstatic_axi_0_rlast : out STD_LOGIC;
    sstatic_axi_0_rready : in STD_LOGIC;
    sstatic_axi_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_rvalid : out STD_LOGIC;
    sstatic_axi_0_wdata : in STD_LOGIC_VECTOR ( 511 downto 0 );
    sstatic_axi_0_wlast : in STD_LOGIC;
    sstatic_axi_0_wready : out STD_LOGIC;
    sstatic_axi_0_wstrb : in STD_LOGIC_VECTOR ( 63 downto 0 );
    sstatic_axi_0_wvalid : in STD_LOGIC;
    pci_express_x16_rxn : in STD_LOGIC_VECTOR ( 15 downto 0 );
    pci_express_x16_rxp : in STD_LOGIC_VECTOR ( 15 downto 0 );
    pci_express_x16_txn : out STD_LOGIC_VECTOR ( 15 downto 0 );
    pci_express_x16_txp : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  end component static_design_wrapper;

component dfx_test_partition_wrapper is
  port (
    mstatic_axi_aclk_0 : in STD_LOGIC;
    mstatic_axi_aresetn_0 : in STD_LOGIC;
    S_BSCAN_bscanid_en : in STD_LOGIC := '0';
    S_BSCAN_capture : in STD_LOGIC := '0';
    S_BSCAN_drck : in STD_LOGIC := '0';
    S_BSCAN_reset : in STD_LOGIC := '0';
    S_BSCAN_runtest : in STD_LOGIC := '0';
    S_BSCAN_sel : in STD_LOGIC := '0';
    S_BSCAN_shift : in STD_LOGIC := '0';
    S_BSCAN_tck : in STD_LOGIC := '0';
    S_BSCAN_tdi : in STD_LOGIC := '0';
    S_BSCAN_tdo : out STD_LOGIC := '0';
    S_BSCAN_tms : in STD_LOGIC := '0';
    S_BSCAN_update : in STD_LOGIC := '0';
    mstatic_axi_0_awaddr : in STD_LOGIC_VECTOR ( 36 downto 0 );
    mstatic_axi_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    mstatic_axi_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_awlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    mstatic_axi_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_awvalid : in STD_LOGIC;
    mstatic_axi_0_awready : out STD_LOGIC;
    mstatic_axi_0_wdata : in STD_LOGIC_VECTOR ( 511 downto 0 );
    mstatic_axi_0_wstrb : in STD_LOGIC_VECTOR ( 63 downto 0 );
    mstatic_axi_0_wlast : in STD_LOGIC;
    mstatic_axi_0_wvalid : in STD_LOGIC;
    mstatic_axi_0_wready : out STD_LOGIC;
    mstatic_axi_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_bvalid : out STD_LOGIC;
    mstatic_axi_0_bready : in STD_LOGIC;
    mstatic_axi_0_araddr : in STD_LOGIC_VECTOR ( 36 downto 0 );
    mstatic_axi_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    mstatic_axi_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_arlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    mstatic_axi_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_arvalid : in STD_LOGIC;
    mstatic_axi_0_arready : out STD_LOGIC;
    mstatic_axi_0_rdata : out STD_LOGIC_VECTOR ( 511 downto 0 );
    mstatic_axi_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_rlast : out STD_LOGIC;
    mstatic_axi_0_rvalid : out STD_LOGIC;
    mstatic_axi_0_rready : in STD_LOGIC;
    sstatic_axi_0_awaddr : out STD_LOGIC_VECTOR ( 36 downto 0 );
    sstatic_axi_0_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    sstatic_axi_0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    sstatic_axi_0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_awlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    sstatic_axi_0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    sstatic_axi_0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_awvalid : out STD_LOGIC;
    sstatic_axi_0_awready : in STD_LOGIC;
    sstatic_axi_0_wdata : out STD_LOGIC_VECTOR ( 511 downto 0 );
    sstatic_axi_0_wstrb : out STD_LOGIC_VECTOR ( 63 downto 0 );
    sstatic_axi_0_wlast : out STD_LOGIC;
    sstatic_axi_0_wvalid : out STD_LOGIC;
    sstatic_axi_0_wready : in STD_LOGIC;
    sstatic_axi_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_bvalid : in STD_LOGIC;
    sstatic_axi_0_bready : out STD_LOGIC;
    sstatic_axi_0_araddr : out STD_LOGIC_VECTOR ( 36 downto 0 );
    sstatic_axi_0_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    sstatic_axi_0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    sstatic_axi_0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    sstatic_axi_0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    sstatic_axi_0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_arvalid : out STD_LOGIC;
    sstatic_axi_0_arready : in STD_LOGIC;
    sstatic_axi_0_rdata : in STD_LOGIC_VECTOR ( 511 downto 0 );
    sstatic_axi_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_rlast : in STD_LOGIC;
    sstatic_axi_0_rvalid : in STD_LOGIC;
    sstatic_axi_0_rready : out STD_LOGIC
  );
  end component dfx_test_partition_wrapper;

begin



static_design_i: component static_design_wrapper
     port map (
      axi_clk => axi_clk,
      ddr4_sdram_c0_act_n => ddr4_sdram_c0_act_n,
      ddr4_sdram_c0_adr(16 downto 0) => ddr4_sdram_c0_adr(16 downto 0),
      ddr4_sdram_c0_ba(1 downto 0) => ddr4_sdram_c0_ba(1 downto 0),
      ddr4_sdram_c0_bg(1 downto 0) => ddr4_sdram_c0_bg(1 downto 0),
      ddr4_sdram_c0_ck_c => ddr4_sdram_c0_ck_c,
      ddr4_sdram_c0_ck_t => ddr4_sdram_c0_ck_t,
      ddr4_sdram_c0_cke => ddr4_sdram_c0_cke,
      ddr4_sdram_c0_cs_n => ddr4_sdram_c0_cs_n,
      ddr4_sdram_c0_dq(71 downto 0) => ddr4_sdram_c0_dq(71 downto 0),
      ddr4_sdram_c0_dqs_c(17 downto 0) => ddr4_sdram_c0_dqs_c(17 downto 0),
      ddr4_sdram_c0_dqs_t(17 downto 0) => ddr4_sdram_c0_dqs_t(17 downto 0),
      ddr4_sdram_c0_odt => ddr4_sdram_c0_odt,
      ddr4_sdram_c0_par => ddr4_sdram_c0_par,
      ddr4_sdram_c0_reset_n => ddr4_sdram_c0_reset_n,
      ddr4_sdram_c1_act_n => ddr4_sdram_c1_act_n,
      ddr4_sdram_c1_adr(16 downto 0) => ddr4_sdram_c1_adr(16 downto 0),
      ddr4_sdram_c1_ba(1 downto 0) => ddr4_sdram_c1_ba(1 downto 0),
      ddr4_sdram_c1_bg(1 downto 0) => ddr4_sdram_c1_bg(1 downto 0),
      ddr4_sdram_c1_ck_c => ddr4_sdram_c1_ck_c,
      ddr4_sdram_c1_ck_t => ddr4_sdram_c1_ck_t,
      ddr4_sdram_c1_cke => ddr4_sdram_c1_cke,
      ddr4_sdram_c1_cs_n => ddr4_sdram_c1_cs_n,
      ddr4_sdram_c1_dq(71 downto 0) => ddr4_sdram_c1_dq(71 downto 0),
      ddr4_sdram_c1_dqs_c(17 downto 0) => ddr4_sdram_c1_dqs_c(17 downto 0),
      ddr4_sdram_c1_dqs_t(17 downto 0) => ddr4_sdram_c1_dqs_t(17 downto 0),
      ddr4_sdram_c1_odt => ddr4_sdram_c1_odt,
      ddr4_sdram_c1_par => ddr4_sdram_c1_par,
      ddr4_sdram_c1_reset_n => ddr4_sdram_c1_reset_n,
      default_300mhz_clk0_clk_n => default_300mhz_clk0_clk_n,
      default_300mhz_clk0_clk_p => default_300mhz_clk0_clk_p,
      default_300mhz_clk1_clk_n => default_300mhz_clk1_clk_n,
      default_300mhz_clk1_clk_p => default_300mhz_clk1_clk_p,
      mstatic_aresetn(0) => axi_aresetn,
      mstatic_axi_0_araddr(36 downto 0) => mstatic_axi_0_araddr(36 downto 0),
      mstatic_axi_0_arburst(1 downto 0) => mstatic_axi_0_arburst(1 downto 0),
      mstatic_axi_0_arcache(3 downto 0) => mstatic_axi_0_arcache(3 downto 0),
      mstatic_axi_0_arid(0) => mstatic_axi_0_arid(0),
      mstatic_axi_0_arlen(7 downto 0) => mstatic_axi_0_arlen(7 downto 0),
      mstatic_axi_0_arlock => mstatic_axi_0_arlock,
      mstatic_axi_0_arprot(2 downto 0) => mstatic_axi_0_arprot(2 downto 0),
      mstatic_axi_0_arqos(3 downto 0) => mstatic_axi_0_arqos(3 downto 0),
      mstatic_axi_0_arready => mstatic_axi_0_arready,
      mstatic_axi_0_arregion(3 downto 0) => mstatic_axi_0_arregion(3 downto 0),
      mstatic_axi_0_arsize(2 downto 0) => mstatic_axi_0_arsize(2 downto 0),
      mstatic_axi_0_arvalid => mstatic_axi_0_arvalid,
      mstatic_axi_0_awaddr(36 downto 0) => mstatic_axi_0_awaddr(36 downto 0),
      mstatic_axi_0_awburst(1 downto 0) => mstatic_axi_0_awburst(1 downto 0),
      mstatic_axi_0_awcache(3 downto 0) => mstatic_axi_0_awcache(3 downto 0),
      mstatic_axi_0_awid(0) => mstatic_axi_0_awid(0),
      mstatic_axi_0_awlen(7 downto 0) => mstatic_axi_0_awlen(7 downto 0),
      mstatic_axi_0_awlock => mstatic_axi_0_awlock,
      mstatic_axi_0_awprot(2 downto 0) => mstatic_axi_0_awprot(2 downto 0),
      mstatic_axi_0_awqos(3 downto 0) => mstatic_axi_0_awqos(3 downto 0),
      mstatic_axi_0_awready => mstatic_axi_0_awready,
      mstatic_axi_0_awregion(3 downto 0) => mstatic_axi_0_awregion(3 downto 0),
      mstatic_axi_0_awsize(2 downto 0) => mstatic_axi_0_awsize(2 downto 0),
      mstatic_axi_0_awvalid => mstatic_axi_0_awvalid,
      mstatic_axi_0_bid(0) => mstatic_axi_0_bid(0),
      mstatic_axi_0_bready => mstatic_axi_0_bready,
      mstatic_axi_0_bresp(1 downto 0) => mstatic_axi_0_bresp(1 downto 0),
      mstatic_axi_0_bvalid => mstatic_axi_0_bvalid,
      mstatic_axi_0_rdata(511 downto 0) => mstatic_axi_0_rdata(511 downto 0),
      mstatic_axi_0_rid(0) => mstatic_axi_0_rid(0),
      mstatic_axi_0_rlast => mstatic_axi_0_rlast,
      mstatic_axi_0_rready => mstatic_axi_0_rready,
      mstatic_axi_0_rresp(1 downto 0) => mstatic_axi_0_rresp(1 downto 0),
      mstatic_axi_0_rvalid => mstatic_axi_0_rvalid,
      mstatic_axi_0_wdata(511 downto 0) => mstatic_axi_0_wdata(511 downto 0),
      mstatic_axi_0_wlast => mstatic_axi_0_wlast,
      mstatic_axi_0_wready => mstatic_axi_0_wready,
      mstatic_axi_0_wstrb(63 downto 0) => mstatic_axi_0_wstrb(63 downto 0),
      mstatic_axi_0_wvalid => mstatic_axi_0_wvalid,
      pci_express_x16_rxn(15 downto 0) => pci_express_x16_rxn(15 downto 0),
      pci_express_x16_rxp(15 downto 0) => pci_express_x16_rxp(15 downto 0),
      pci_express_x16_txn(15 downto 0) => pci_express_x16_txn(15 downto 0),
      pci_express_x16_txp(15 downto 0) => pci_express_x16_txp(15 downto 0),
      pcie_perstn => pcie_perstn,
      pcie_refclk_clk_n => pcie_refclk_clk_n,
      pcie_refclk_clk_p => pcie_refclk_clk_p,
      sstatic_axi_0_araddr(36 downto 0) => sstatic_axi_0_araddr(36 downto 0),
      sstatic_axi_0_arburst(1 downto 0) => sstatic_axi_0_arburst(1 downto 0),
      sstatic_axi_0_arcache(3 downto 0) => sstatic_axi_0_arcache(3 downto 0),
      sstatic_axi_0_arid(0) => sstatic_axi_0_arid(0),
      sstatic_axi_0_arlen(7 downto 0) => sstatic_axi_0_arlen(7 downto 0),
      sstatic_axi_0_arlock => sstatic_axi_0_arlock,
      sstatic_axi_0_arprot(2 downto 0) => sstatic_axi_0_arprot(2 downto 0),
      sstatic_axi_0_arqos(3 downto 0) => sstatic_axi_0_arqos(3 downto 0),
      sstatic_axi_0_arready => sstatic_axi_0_arready,
      sstatic_axi_0_arregion(3 downto 0) => sstatic_axi_0_arregion(3 downto 0),
      sstatic_axi_0_arsize(2 downto 0) => sstatic_axi_0_arsize(2 downto 0),
      sstatic_axi_0_arvalid => sstatic_axi_0_arvalid,
      sstatic_axi_0_awaddr(36 downto 0) => sstatic_axi_0_awaddr(36 downto 0),
      sstatic_axi_0_awburst(1 downto 0) => sstatic_axi_0_awburst(1 downto 0),
      sstatic_axi_0_awcache(3 downto 0) => sstatic_axi_0_awcache(3 downto 0),
      sstatic_axi_0_awid(0) => sstatic_axi_0_awid(0),
      sstatic_axi_0_awlen(7 downto 0) => sstatic_axi_0_awlen(7 downto 0),
      sstatic_axi_0_awlock => sstatic_axi_0_awlock,
      sstatic_axi_0_awprot(2 downto 0) => sstatic_axi_0_awprot(2 downto 0),
      sstatic_axi_0_awqos(3 downto 0) => sstatic_axi_0_awqos(3 downto 0),
      sstatic_axi_0_awready => sstatic_axi_0_awready,
      sstatic_axi_0_awregion(3 downto 0) => sstatic_axi_0_awregion(3 downto 0),
      sstatic_axi_0_awsize(2 downto 0) => sstatic_axi_0_awsize(2 downto 0),
      sstatic_axi_0_awvalid => sstatic_axi_0_awvalid,
      sstatic_axi_0_bid(0) => sstatic_axi_0_bid(0),
      sstatic_axi_0_bready => sstatic_axi_0_bready,
      sstatic_axi_0_bresp(1 downto 0) => sstatic_axi_0_bresp(1 downto 0),
      sstatic_axi_0_bvalid => sstatic_axi_0_bvalid,
      sstatic_axi_0_rdata(511 downto 0) => sstatic_axi_0_rdata(511 downto 0),
      sstatic_axi_0_rid(0) => sstatic_axi_0_rid(0),
      sstatic_axi_0_rlast => sstatic_axi_0_rlast,
      sstatic_axi_0_rready => sstatic_axi_0_rready,
      sstatic_axi_0_rresp(1 downto 0) => sstatic_axi_0_rresp(1 downto 0),
      sstatic_axi_0_rvalid => sstatic_axi_0_rvalid,
      sstatic_axi_0_wdata(511 downto 0) => sstatic_axi_0_wdata(511 downto 0),
      sstatic_axi_0_wlast => sstatic_axi_0_wlast,
      sstatic_axi_0_wready => sstatic_axi_0_wready,
      sstatic_axi_0_wstrb(63 downto 0) => sstatic_axi_0_wstrb(63 downto 0),
      sstatic_axi_0_wvalid => sstatic_axi_0_wvalid
    );

    dfx_test_partition_wrapper_i: component dfx_test_partition_wrapper
    PORT MAP (


    mstatic_axi_0_araddr(36 downto 0) => mstatic_axi_0_araddr(36 downto 0),
    mstatic_axi_0_arburst(1 downto 0) => mstatic_axi_0_arburst(1 downto 0),
    mstatic_axi_0_arcache(3 downto 0) => mstatic_axi_0_arcache(3 downto 0),
    mstatic_axi_0_arlen(7 downto 0) => mstatic_axi_0_arlen(7 downto 0),
    mstatic_axi_0_arlock(0) => mstatic_axi_0_arlock,
    mstatic_axi_0_arprot(2 downto 0) => mstatic_axi_0_arprot(2 downto 0),
    mstatic_axi_0_arqos(3 downto 0) => mstatic_axi_0_arqos(3 downto 0),
    mstatic_axi_0_arready => mstatic_axi_0_arready,
    mstatic_axi_0_arsize(2 downto 0) => mstatic_axi_0_arsize(2 downto 0),
    mstatic_axi_0_arvalid => mstatic_axi_0_arvalid,
    mstatic_axi_0_awaddr(36 downto 0) => mstatic_axi_0_awaddr(36 downto 0),
    mstatic_axi_0_awburst(1 downto 0) => mstatic_axi_0_awburst(1 downto 0),
    mstatic_axi_0_awcache(3 downto 0) => mstatic_axi_0_awcache(3 downto 0),
    mstatic_axi_0_awlen(7 downto 0) => mstatic_axi_0_awlen(7 downto 0),
    mstatic_axi_0_awlock(0) => mstatic_axi_0_awlock,
    mstatic_axi_0_awprot(2 downto 0) => mstatic_axi_0_awprot(2 downto 0),
    mstatic_axi_0_awqos(3 downto 0) => mstatic_axi_0_awqos(3 downto 0),
    mstatic_axi_0_awready => mstatic_axi_0_awready,
    mstatic_axi_0_awsize(2 downto 0) => mstatic_axi_0_awsize(2 downto 0),
    mstatic_axi_0_awvalid => mstatic_axi_0_awvalid,
    mstatic_axi_0_bready => mstatic_axi_0_bready,
    mstatic_axi_0_bresp(1 downto 0) => mstatic_axi_0_bresp(1 downto 0),
    mstatic_axi_0_bvalid => mstatic_axi_0_bvalid,
    mstatic_axi_0_rdata(511 downto 0) => mstatic_axi_0_rdata(511 downto 0),
    mstatic_axi_0_rlast => mstatic_axi_0_rlast,
    mstatic_axi_0_rready => mstatic_axi_0_rready,
    mstatic_axi_0_rresp(1 downto 0) => mstatic_axi_0_rresp(1 downto 0),
    mstatic_axi_0_rvalid => mstatic_axi_0_rvalid,
    mstatic_axi_0_wdata(511 downto 0) => mstatic_axi_0_wdata(511 downto 0),
    mstatic_axi_0_wlast => mstatic_axi_0_wlast,
    mstatic_axi_0_wready => mstatic_axi_0_wready,
    mstatic_axi_0_wstrb(63 downto 0) => mstatic_axi_0_wstrb(63 downto 0),
    mstatic_axi_0_wvalid => mstatic_axi_0_wvalid,
    mstatic_axi_aclk_0 => axi_clk,
    mstatic_axi_aresetn_0 => axi_aresetn,
    sstatic_axi_0_araddr(36 downto 0) => sstatic_axi_0_araddr(36 downto 0),
    sstatic_axi_0_arburst(1 downto 0) => sstatic_axi_0_arburst(1 downto 0),
    sstatic_axi_0_arcache(3 downto 0) => sstatic_axi_0_arcache(3 downto 0),
    sstatic_axi_0_arlen(7 downto 0) => sstatic_axi_0_arlen(7 downto 0),
    sstatic_axi_0_arlock(0) => sstatic_axi_0_arlock,
    sstatic_axi_0_arprot(2 downto 0) => sstatic_axi_0_arprot(2 downto 0),
    sstatic_axi_0_arqos(3 downto 0) => sstatic_axi_0_arqos(3 downto 0),
    sstatic_axi_0_arready => sstatic_axi_0_arready,
    sstatic_axi_0_arsize(2 downto 0) => sstatic_axi_0_arsize(2 downto 0),
    sstatic_axi_0_arvalid => sstatic_axi_0_arvalid,
    sstatic_axi_0_awaddr(36 downto 0) => sstatic_axi_0_awaddr(36 downto 0),
    sstatic_axi_0_awburst(1 downto 0) => sstatic_axi_0_awburst(1 downto 0),
    sstatic_axi_0_awcache(3 downto 0) => sstatic_axi_0_awcache(3 downto 0),
    sstatic_axi_0_awlen(7 downto 0) => sstatic_axi_0_awlen(7 downto 0),
    sstatic_axi_0_awlock(0) => sstatic_axi_0_awlock,
    sstatic_axi_0_awprot(2 downto 0) => sstatic_axi_0_awprot(2 downto 0),
    sstatic_axi_0_awqos(3 downto 0) => sstatic_axi_0_awqos(3 downto 0),
    sstatic_axi_0_awready => sstatic_axi_0_awready,
    sstatic_axi_0_awsize(2 downto 0) => sstatic_axi_0_awsize(2 downto 0),
    sstatic_axi_0_awvalid => sstatic_axi_0_awvalid,
    sstatic_axi_0_bready => sstatic_axi_0_bready,
    sstatic_axi_0_bresp(1 downto 0) => sstatic_axi_0_bresp(1 downto 0),
    sstatic_axi_0_bvalid => sstatic_axi_0_bvalid,
    sstatic_axi_0_rdata(511 downto 0) => sstatic_axi_0_rdata(511 downto 0),
    sstatic_axi_0_rlast => sstatic_axi_0_rlast,
    sstatic_axi_0_rready => sstatic_axi_0_rready,
    sstatic_axi_0_rresp(1 downto 0) => sstatic_axi_0_rresp(1 downto 0),
    sstatic_axi_0_rvalid => sstatic_axi_0_rvalid,
    sstatic_axi_0_wdata(511 downto 0) => sstatic_axi_0_wdata(511 downto 0),
    sstatic_axi_0_wlast => sstatic_axi_0_wlast,
    sstatic_axi_0_wready => sstatic_axi_0_wready,
    sstatic_axi_0_wstrb(63 downto 0) => sstatic_axi_0_wstrb(63 downto 0),
    sstatic_axi_0_wvalid => sstatic_axi_0_wvalid,

    S_BSCAN_bscanid_en => open,
    S_BSCAN_capture => open,
    S_BSCAN_drck => open,
    S_BSCAN_reset => open,
    S_BSCAN_runtest => open,
    S_BSCAN_sel => open,
    S_BSCAN_shift => open,
    S_BSCAN_tck => open,
    S_BSCAN_tdi => open,
    S_BSCAN_tdo => open,
    S_BSCAN_tms => open,
    S_BSCAN_update => open

    );

end STRUCTURE;
