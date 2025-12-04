LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_textio.ALL;
USE STD.textio.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY top IS
	PORT (

		Q2_CLK1_GTREFCLK_PAD_N_IN : IN STD_LOGIC;
		Q2_CLK1_GTREFCLK_PAD_P_IN : IN STD_LOGIC;

		DRP_CLK_IN_P : IN STD_LOGIC;
		DRP_CLK_IN_N : IN STD_LOGIC;

		pci_exp_txp : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		pci_exp_txn : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);

		pci_exp_rxp : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		pci_exp_rxn : IN STD_LOGIC_VECTOR (3 DOWNTO 0);

		sys_clk_p : IN STD_LOGIC;
		sys_clk_n : IN STD_LOGIC;
		sys_rst_n_i : IN STD_LOGIC;

		ddr3_sdram_addr : out STD_LOGIC_VECTOR ( 13 downto 0 );
        ddr3_sdram_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
        ddr3_sdram_cas_n : out STD_LOGIC;
        ddr3_sdram_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
        ddr3_sdram_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
        ddr3_sdram_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
        ddr3_sdram_cs_n : out STD_LOGIC_VECTOR ( 0 to 0 );
        ddr3_sdram_dm : out STD_LOGIC_VECTOR ( 7 downto 0 );
        ddr3_sdram_dq : inout STD_LOGIC_VECTOR ( 63 downto 0 );
        ddr3_sdram_dqs_n : inout STD_LOGIC_VECTOR ( 7 downto 0 );
        ddr3_sdram_dqs_p : inout STD_LOGIC_VECTOR ( 7 downto 0 );
        ddr3_sdram_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
        ddr3_sdram_ras_n : out STD_LOGIC;
        ddr3_sdram_reset_n : out STD_LOGIC;
        ddr3_sdram_we_n : out STD_LOGIC;

		led_0 : OUT STD_LOGIC;
		led_1 : OUT STD_LOGIC;
		led_2 : OUT STD_LOGIC;
		led_3 : OUT STD_LOGIC
	);
END top;

ARCHITECTURE Behavioral OF top IS
	signal sys_clk           : std_logic;
	signal sys_rst_n : std_logic;

    -- Additional signals for AXI connections between wrappers
    signal gpio_4b : STD_LOGIC_VECTOR(3 downto 0);
    signal axi_clk : STD_LOGIC;
    signal axi_aresetn : STD_LOGIC;

    -- AXI signals for static_design_wrapper mstatic interface
    signal mstatic_axi_araddr : STD_LOGIC_VECTOR(31 downto 0);
    signal mstatic_axi_arburst : STD_LOGIC_VECTOR(1 downto 0);
    signal mstatic_axi_arcache : STD_LOGIC_VECTOR(3 downto 0);
    signal mstatic_axi_arid : STD_LOGIC_VECTOR(0 to 0);
    signal mstatic_axi_arlen : STD_LOGIC_VECTOR(7 downto 0);
    signal mstatic_axi_arlock : STD_LOGIC_VECTOR(0 to 0);
    signal mstatic_axi_arprot : STD_LOGIC_VECTOR(2 downto 0);
    signal mstatic_axi_arqos : STD_LOGIC_VECTOR(3 downto 0);
    signal mstatic_axi_arready : STD_LOGIC;
    signal mstatic_axi_arregion : STD_LOGIC_VECTOR(3 downto 0);
    signal mstatic_axi_arsize : STD_LOGIC_VECTOR(2 downto 0);
    signal mstatic_axi_arvalid : STD_LOGIC;
    signal mstatic_axi_awaddr : STD_LOGIC_VECTOR(31 downto 0);
    signal mstatic_axi_awburst : STD_LOGIC_VECTOR(1 downto 0);
    signal mstatic_axi_awcache : STD_LOGIC_VECTOR(3 downto 0);
    signal mstatic_axi_awid : STD_LOGIC_VECTOR(0 to 0);
    signal mstatic_axi_awlen : STD_LOGIC_VECTOR(7 downto 0);
    signal mstatic_axi_awlock : STD_LOGIC_VECTOR(0 to 0);
    signal mstatic_axi_awprot : STD_LOGIC_VECTOR(2 downto 0);
    signal mstatic_axi_awqos : STD_LOGIC_VECTOR(3 downto 0);
    signal mstatic_axi_awready : STD_LOGIC;
    signal mstatic_axi_awregion : STD_LOGIC_VECTOR(3 downto 0);
    signal mstatic_axi_awsize : STD_LOGIC_VECTOR(2 downto 0);
    signal mstatic_axi_awvalid : STD_LOGIC;
    signal mstatic_axi_bid : STD_LOGIC_VECTOR(0 to 0);
    signal mstatic_axi_bready : STD_LOGIC;
    signal mstatic_axi_bresp : STD_LOGIC_VECTOR(1 downto 0);
    signal mstatic_axi_bvalid : STD_LOGIC;
    signal mstatic_axi_rdata : STD_LOGIC_VECTOR(31 downto 0);
    signal mstatic_axi_rid : STD_LOGIC_VECTOR(0 to 0);
    signal mstatic_axi_rlast : STD_LOGIC;
    signal mstatic_axi_rready : STD_LOGIC;
    signal mstatic_axi_rresp : STD_LOGIC_VECTOR(1 downto 0);
    signal mstatic_axi_rvalid : STD_LOGIC;
    signal mstatic_axi_wdata : STD_LOGIC_VECTOR(31 downto 0);
    signal mstatic_axi_wlast : STD_LOGIC;
    signal mstatic_axi_wready : STD_LOGIC;
    signal mstatic_axi_wstrb : STD_LOGIC_VECTOR(3 downto 0);
    signal mstatic_axi_wvalid : STD_LOGIC;

    -- AXI signals for static_design_wrapper sstatic interface (connects to dfx_test_partition sstatic)
    signal sstatic_axi_araddr : STD_LOGIC_VECTOR(31 downto 0);
    signal sstatic_axi_arburst : STD_LOGIC_VECTOR(1 downto 0);
    signal sstatic_axi_arcache : STD_LOGIC_VECTOR(3 downto 0);
    signal sstatic_axi_arid : STD_LOGIC_VECTOR(0 to 0);
    signal sstatic_axi_arlen : STD_LOGIC_VECTOR(7 downto 0);
    signal sstatic_axi_arlock : STD_LOGIC;
    signal sstatic_axi_arprot : STD_LOGIC_VECTOR(2 downto 0);
    signal sstatic_axi_arqos : STD_LOGIC_VECTOR(3 downto 0);
    signal sstatic_axi_arready : STD_LOGIC;
    signal sstatic_axi_arregion : STD_LOGIC_VECTOR(3 downto 0);
    signal sstatic_axi_arsize : STD_LOGIC_VECTOR(2 downto 0);
    signal sstatic_axi_arvalid : STD_LOGIC;
    signal sstatic_axi_awaddr : STD_LOGIC_VECTOR(31 downto 0);
    signal sstatic_axi_awburst : STD_LOGIC_VECTOR(1 downto 0);
    signal sstatic_axi_awcache : STD_LOGIC_VECTOR(3 downto 0);
    signal sstatic_axi_awid : STD_LOGIC_VECTOR(0 to 0);
    signal sstatic_axi_awlen : STD_LOGIC_VECTOR(7 downto 0);
    signal sstatic_axi_awlock : STD_LOGIC;
    signal sstatic_axi_awprot : STD_LOGIC_VECTOR(2 downto 0);
    signal sstatic_axi_awqos : STD_LOGIC_VECTOR(3 downto 0);
    signal sstatic_axi_awready : STD_LOGIC;
    signal sstatic_axi_awregion : STD_LOGIC_VECTOR(3 downto 0);
    signal sstatic_axi_awsize : STD_LOGIC_VECTOR(2 downto 0);
    signal sstatic_axi_awvalid : STD_LOGIC;
    signal sstatic_axi_bid : STD_LOGIC_VECTOR(0 to 0);
    signal sstatic_axi_bready : STD_LOGIC;
    signal sstatic_axi_bresp : STD_LOGIC_VECTOR(1 downto 0);
    signal sstatic_axi_bvalid : STD_LOGIC;
    signal sstatic_axi_rdata : STD_LOGIC_VECTOR(31 downto 0);
    signal sstatic_axi_rid : STD_LOGIC_VECTOR(0 to 0);
    signal sstatic_axi_rlast : STD_LOGIC;
    signal sstatic_axi_rready : STD_LOGIC;
    signal sstatic_axi_rresp : STD_LOGIC_VECTOR(1 downto 0);
    signal sstatic_axi_rvalid : STD_LOGIC;
    signal sstatic_axi_wdata : STD_LOGIC_VECTOR(31 downto 0);
    signal sstatic_axi_wlast : STD_LOGIC;
    signal sstatic_axi_wready : STD_LOGIC;
    signal sstatic_axi_wstrb : STD_LOGIC_VECTOR(3 downto 0);
    signal sstatic_axi_wvalid : STD_LOGIC;

--    -- BSCAN signals
--    signal bscan_bscanid_en : STD_LOGIC := '0';
--    signal bscan_capture : STD_LOGIC := '0';
--    signal bscan_drck : STD_LOGIC := '0';
--    signal bscan_reset : STD_LOGIC := '0';
--    signal bscan_runtest : STD_LOGIC := '0';
--    signal bscan_sel : STD_LOGIC := '0';
--    signal bscan_shift : STD_LOGIC := '0';
--    signal bscan_tck : STD_LOGIC := '0';
--    signal bscan_tdi : STD_LOGIC := '0';
--    signal bscan_tdo : STD_LOGIC;
--    signal bscan_tms : STD_LOGIC := '0';
--    signal bscan_update : STD_LOGIC := '0';


	component static_design_wrapper is
  port (
    ddr3_sdram_addr : out STD_LOGIC_VECTOR ( 13 downto 0 );
    ddr3_sdram_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
    ddr3_sdram_cas_n : out STD_LOGIC;
    ddr3_sdram_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_cs_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_dm : out STD_LOGIC_VECTOR ( 7 downto 0 );
    ddr3_sdram_dq : inout STD_LOGIC_VECTOR ( 63 downto 0 );
    ddr3_sdram_dqs_n : inout STD_LOGIC_VECTOR ( 7 downto 0 );
    ddr3_sdram_dqs_p : inout STD_LOGIC_VECTOR ( 7 downto 0 );
    ddr3_sdram_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_ras_n : out STD_LOGIC;
    ddr3_sdram_reset_n : out STD_LOGIC;
    ddr3_sdram_we_n : out STD_LOGIC;
    led_4bits_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_aresetn_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    mstatic_axi_0_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    mstatic_axi_0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_arid : out STD_LOGIC_VECTOR ( 0 to 0 );
    mstatic_axi_0_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    mstatic_axi_0_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    mstatic_axi_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_arready : in STD_LOGIC;
    mstatic_axi_0_arregion : out STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_arvalid : out STD_LOGIC;
    mstatic_axi_0_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    mstatic_axi_0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_awid : out STD_LOGIC_VECTOR ( 0 to 0 );
    mstatic_axi_0_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    mstatic_axi_0_awlock : out STD_LOGIC_VECTOR ( 0 to 0 );
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
    mstatic_axi_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    mstatic_axi_0_rid : in STD_LOGIC_VECTOR ( 0 to 0 );
    mstatic_axi_0_rlast : in STD_LOGIC;
    mstatic_axi_0_rready : out STD_LOGIC;
    mstatic_axi_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_rvalid : in STD_LOGIC;
    mstatic_axi_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    mstatic_axi_0_wlast : out STD_LOGIC;
    mstatic_axi_0_wready : in STD_LOGIC;
    mstatic_axi_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_wvalid : out STD_LOGIC;
    mstatic_axi_clk_0 : out STD_LOGIC;
    pci_exp_rxn : in STD_LOGIC_VECTOR ( 3 downto 0 );
    pci_exp_rxp : in STD_LOGIC_VECTOR ( 3 downto 0 );
    pci_exp_txn : out STD_LOGIC_VECTOR ( 3 downto 0 );
    pci_exp_txp : out STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
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
    sstatic_axi_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
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
    sstatic_axi_0_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    sstatic_axi_0_rid : out STD_LOGIC_VECTOR ( 0 to 0 );
    sstatic_axi_0_rlast : out STD_LOGIC;
    sstatic_axi_0_rready : in STD_LOGIC;
    sstatic_axi_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_rvalid : out STD_LOGIC;
    sstatic_axi_0_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    sstatic_axi_0_wlast : in STD_LOGIC;
    sstatic_axi_0_wready : out STD_LOGIC;
    sstatic_axi_0_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_wvalid : in STD_LOGIC;
    sys_clk : in STD_LOGIC;
    sys_rst_n : in STD_LOGIC
  );
  end component static_design_wrapper;

  component dfx_test_partition_wrapper is
  port (
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
    mstatic_axi_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    mstatic_axi_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    mstatic_axi_0_arlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    mstatic_axi_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_arready : out STD_LOGIC;
    mstatic_axi_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_arvalid : in STD_LOGIC;
    mstatic_axi_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    mstatic_axi_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    mstatic_axi_0_awlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    mstatic_axi_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_awready : out STD_LOGIC;
    mstatic_axi_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_awvalid : in STD_LOGIC;
    mstatic_axi_0_bready : in STD_LOGIC;
    mstatic_axi_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_bvalid : out STD_LOGIC;
    mstatic_axi_0_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    mstatic_axi_0_rlast : out STD_LOGIC;
    mstatic_axi_0_rready : in STD_LOGIC;
    mstatic_axi_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_rvalid : out STD_LOGIC;
    mstatic_axi_0_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    mstatic_axi_0_wlast : in STD_LOGIC;
    mstatic_axi_0_wready : out STD_LOGIC;
    mstatic_axi_0_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_wvalid : in STD_LOGIC;
    mstatic_axi_aclk_0 : in STD_LOGIC;
    mstatic_axi_aresetn_0 : in STD_LOGIC;
    sstatic_axi_0_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    sstatic_axi_0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    sstatic_axi_0_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    sstatic_axi_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    sstatic_axi_0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_arready : in STD_LOGIC;
    sstatic_axi_0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    sstatic_axi_0_arvalid : out STD_LOGIC;
    sstatic_axi_0_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    sstatic_axi_0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    sstatic_axi_0_awlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    sstatic_axi_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    sstatic_axi_0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_awready : in STD_LOGIC;
    sstatic_axi_0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    sstatic_axi_0_awvalid : out STD_LOGIC;
    sstatic_axi_0_bready : out STD_LOGIC;
    sstatic_axi_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_bvalid : in STD_LOGIC;
    sstatic_axi_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    sstatic_axi_0_rlast : in STD_LOGIC;
    sstatic_axi_0_rready : out STD_LOGIC;
    sstatic_axi_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_rvalid : in STD_LOGIC;
    sstatic_axi_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    sstatic_axi_0_wlast : out STD_LOGIC;
    sstatic_axi_0_wready : in STD_LOGIC;
    sstatic_axi_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_wvalid : out STD_LOGIC
  );
  end component dfx_test_partition_wrapper;

-- Component Declarations
component IBUFDS_GTE2 is
   port(
       O       : out std_logic;
       ODIV2   : out std_logic;
       I       : in std_logic;
       CEB     : in std_logic;
       IB      : in std_logic
   );
end component;

component IBUF is
   port(
       O       : out std_logic;
       I       : in std_logic
   );
end component;

BEGIN
        led_0 <= gpio_4b(0);
        led_1 <= gpio_4b(1);
        led_2 <= gpio_4b(2);
        led_3 <= gpio_4b(3);

    -- Instantiation of IBUFDS_GTE2
refclk_ibuf_inst : IBUFDS_GTE2
    port map(
        O       => sys_clk,
        ODIV2   => open, -- Not connected
        I       => sys_clk_p,
        CEB     => '0', -- Active Low Enable
        IB      => sys_clk_n
    );

-- Instantiation of IBUF
sys_reset_n_ibuf_inst : IBUF
    port map(
        O       => sys_rst_n,
        I       => sys_rst_n_i
    );

inst_static_design_wrapper: component static_design_wrapper
     port map (
      ddr3_sdram_addr(13 downto 0) => ddr3_sdram_addr(13 downto 0),
      ddr3_sdram_ba(2 downto 0) => ddr3_sdram_ba(2 downto 0),
      ddr3_sdram_cas_n => ddr3_sdram_cas_n,
      ddr3_sdram_ck_n(0) => ddr3_sdram_ck_n(0),
      ddr3_sdram_ck_p(0) => ddr3_sdram_ck_p(0),
      ddr3_sdram_cke(0) => ddr3_sdram_cke(0),
      ddr3_sdram_cs_n(0) => ddr3_sdram_cs_n(0),
      ddr3_sdram_dm(7 downto 0) => ddr3_sdram_dm(7 downto 0),
      ddr3_sdram_dq(63 downto 0) => ddr3_sdram_dq(63 downto 0),
      ddr3_sdram_dqs_n(7 downto 0) => ddr3_sdram_dqs_n(7 downto 0),
      ddr3_sdram_dqs_p(7 downto 0) => ddr3_sdram_dqs_p(7 downto 0),
      ddr3_sdram_odt(0) => ddr3_sdram_odt(0),
      ddr3_sdram_ras_n => ddr3_sdram_ras_n,
      ddr3_sdram_reset_n => ddr3_sdram_reset_n,
      ddr3_sdram_we_n => ddr3_sdram_we_n,
      led_4bits_tri_o(3 downto 0) => gpio_4b(3 downto 0),
      mstatic_aresetn_0(0) => axi_aresetn,
      mstatic_axi_0_araddr(31 downto 0) => mstatic_axi_araddr(31 downto 0),
      mstatic_axi_0_arburst(1 downto 0) => mstatic_axi_arburst(1 downto 0),
      mstatic_axi_0_arcache(3 downto 0) => mstatic_axi_arcache(3 downto 0),
      mstatic_axi_0_arid(0) => mstatic_axi_arid(0),
      mstatic_axi_0_arlen(7 downto 0) => mstatic_axi_arlen(7 downto 0),
      mstatic_axi_0_arlock(0) => mstatic_axi_arlock(0),
      mstatic_axi_0_arprot(2 downto 0) => mstatic_axi_arprot(2 downto 0),
      mstatic_axi_0_arqos(3 downto 0) => mstatic_axi_arqos(3 downto 0),
      mstatic_axi_0_arready => mstatic_axi_arready,
      mstatic_axi_0_arregion(3 downto 0) => mstatic_axi_arregion(3 downto 0),
      mstatic_axi_0_arsize(2 downto 0) => mstatic_axi_arsize(2 downto 0),
      mstatic_axi_0_arvalid => mstatic_axi_arvalid,
      mstatic_axi_0_awaddr(31 downto 0) => mstatic_axi_awaddr(31 downto 0),
      mstatic_axi_0_awburst(1 downto 0) => mstatic_axi_awburst(1 downto 0),
      mstatic_axi_0_awcache(3 downto 0) => mstatic_axi_awcache(3 downto 0),
      mstatic_axi_0_awid(0) => mstatic_axi_awid(0),
      mstatic_axi_0_awlen(7 downto 0) => mstatic_axi_awlen(7 downto 0),
      mstatic_axi_0_awlock(0) => mstatic_axi_awlock(0),
      mstatic_axi_0_awprot(2 downto 0) => mstatic_axi_awprot(2 downto 0),
      mstatic_axi_0_awqos(3 downto 0) => mstatic_axi_awqos(3 downto 0),
      mstatic_axi_0_awready => mstatic_axi_awready,
      mstatic_axi_0_awregion(3 downto 0) => mstatic_axi_awregion(3 downto 0),
      mstatic_axi_0_awsize(2 downto 0) => mstatic_axi_awsize(2 downto 0),
      mstatic_axi_0_awvalid => mstatic_axi_awvalid,
      mstatic_axi_0_bid(0) => mstatic_axi_bid(0),
      mstatic_axi_0_bready => mstatic_axi_bready,
      mstatic_axi_0_bresp(1 downto 0) => mstatic_axi_bresp(1 downto 0),
      mstatic_axi_0_bvalid => mstatic_axi_bvalid,
      mstatic_axi_0_rdata(31 downto 0) => mstatic_axi_rdata(31 downto 0),
      mstatic_axi_0_rid(0) => mstatic_axi_rid(0),
      mstatic_axi_0_rlast => mstatic_axi_rlast,
      mstatic_axi_0_rready => mstatic_axi_rready,
      mstatic_axi_0_rresp(1 downto 0) => mstatic_axi_rresp(1 downto 0),
      mstatic_axi_0_rvalid => mstatic_axi_rvalid,
      mstatic_axi_0_wdata(31 downto 0) => mstatic_axi_wdata(31 downto 0),
      mstatic_axi_0_wlast => mstatic_axi_wlast,
      mstatic_axi_0_wready => mstatic_axi_wready,
      mstatic_axi_0_wstrb(3 downto 0) => mstatic_axi_wstrb(3 downto 0),
      mstatic_axi_0_wvalid => mstatic_axi_wvalid,
      mstatic_axi_clk_0 => axi_clk,
      pci_exp_rxn(3 downto 0) => pci_exp_rxn(3 downto 0),
      pci_exp_rxp(3 downto 0) => pci_exp_rxp(3 downto 0),
      pci_exp_txn(3 downto 0) => pci_exp_txn(3 downto 0),
      pci_exp_txp(3 downto 0) => pci_exp_txp(3 downto 0),
      sstatic_axi_0_araddr(31 downto 0) => sstatic_axi_araddr(31 downto 0),
      sstatic_axi_0_arburst(1 downto 0) => sstatic_axi_arburst(1 downto 0),
      sstatic_axi_0_arcache(3 downto 0) => sstatic_axi_arcache(3 downto 0),
      sstatic_axi_0_arid(0) => sstatic_axi_arid(0),
      sstatic_axi_0_arlen(7 downto 0) => sstatic_axi_arlen(7 downto 0),
      sstatic_axi_0_arlock => sstatic_axi_arlock,
      sstatic_axi_0_arprot(2 downto 0) => sstatic_axi_arprot(2 downto 0),
      sstatic_axi_0_arqos(3 downto 0) => sstatic_axi_arqos(3 downto 0),
      sstatic_axi_0_arready => sstatic_axi_arready,
      sstatic_axi_0_arregion(3 downto 0) => sstatic_axi_arregion(3 downto 0),
      sstatic_axi_0_arsize(2 downto 0) => sstatic_axi_arsize(2 downto 0),
      sstatic_axi_0_arvalid => sstatic_axi_arvalid,
      sstatic_axi_0_awaddr(31 downto 0) => sstatic_axi_awaddr(31 downto 0),
      sstatic_axi_0_awburst(1 downto 0) => sstatic_axi_awburst(1 downto 0),
      sstatic_axi_0_awcache(3 downto 0) => sstatic_axi_awcache(3 downto 0),
      sstatic_axi_0_awid(0) => sstatic_axi_awid(0),
      sstatic_axi_0_awlen(7 downto 0) => sstatic_axi_awlen(7 downto 0),
      sstatic_axi_0_awlock => sstatic_axi_awlock,
      sstatic_axi_0_awprot(2 downto 0) => sstatic_axi_awprot(2 downto 0),
      sstatic_axi_0_awqos(3 downto 0) => sstatic_axi_awqos(3 downto 0),
      sstatic_axi_0_awready => sstatic_axi_awready,
      sstatic_axi_0_awregion(3 downto 0) => sstatic_axi_awregion(3 downto 0),
      sstatic_axi_0_awsize(2 downto 0) => sstatic_axi_awsize(2 downto 0),
      sstatic_axi_0_awvalid => sstatic_axi_awvalid,
      sstatic_axi_0_bid(0) => sstatic_axi_bid(0),
      sstatic_axi_0_bready => sstatic_axi_bready,
      sstatic_axi_0_bresp(1 downto 0) => sstatic_axi_bresp(1 downto 0),
      sstatic_axi_0_bvalid => sstatic_axi_bvalid,
      sstatic_axi_0_rdata(31 downto 0) => sstatic_axi_rdata(31 downto 0),
      sstatic_axi_0_rid(0) => sstatic_axi_rid(0),
      sstatic_axi_0_rlast => sstatic_axi_rlast,
      sstatic_axi_0_rready => sstatic_axi_rready,
      sstatic_axi_0_rresp(1 downto 0) => sstatic_axi_rresp(1 downto 0),
      sstatic_axi_0_rvalid => sstatic_axi_rvalid,
      sstatic_axi_0_wdata(31 downto 0) => sstatic_axi_wdata(31 downto 0),
      sstatic_axi_0_wlast => sstatic_axi_wlast,
      sstatic_axi_0_wready => sstatic_axi_wready,
      sstatic_axi_0_wstrb(3 downto 0) => sstatic_axi_wstrb(3 downto 0),
      sstatic_axi_0_wvalid => sstatic_axi_wvalid,
      sys_clk => sys_clk,
      sys_rst_n => sys_rst_n
      );

dfx_test_partition_wrapper_i: component dfx_test_partition_wrapper
    PORT MAP (

        mstatic_axi_0_araddr(31 downto 0) => mstatic_axi_araddr(31 downto 0),
        mstatic_axi_0_arburst(1 downto 0) => mstatic_axi_arburst(1 downto 0),
        mstatic_axi_0_arcache(3 downto 0) => mstatic_axi_arcache(3 downto 0),
        mstatic_axi_0_arlen(7 downto 0) => mstatic_axi_arlen(7 downto 0),
        mstatic_axi_0_arlock(0) => mstatic_axi_arlock(0),
        mstatic_axi_0_arprot(2 downto 0) => mstatic_axi_arprot(2 downto 0),
        mstatic_axi_0_arqos(3 downto 0) => mstatic_axi_arqos(3 downto 0),
        mstatic_axi_0_arready => mstatic_axi_arready,
        mstatic_axi_0_arsize(2 downto 0) => mstatic_axi_arsize(2 downto 0),
        mstatic_axi_0_arvalid => mstatic_axi_arvalid,
        mstatic_axi_0_awaddr(31 downto 0) => mstatic_axi_awaddr(31 downto 0),
        mstatic_axi_0_awburst(1 downto 0) => mstatic_axi_awburst(1 downto 0),
        mstatic_axi_0_awcache(3 downto 0) => mstatic_axi_awcache(3 downto 0),
        mstatic_axi_0_awlen(7 downto 0) => mstatic_axi_awlen(7 downto 0),
        mstatic_axi_0_awlock(0) => mstatic_axi_awlock(0),
        mstatic_axi_0_awprot(2 downto 0) => mstatic_axi_awprot(2 downto 0),
        mstatic_axi_0_awqos(3 downto 0) => mstatic_axi_awqos(3 downto 0),
        mstatic_axi_0_awready => mstatic_axi_awready,
        mstatic_axi_0_awsize(2 downto 0) => mstatic_axi_awsize(2 downto 0),
        mstatic_axi_0_awvalid => mstatic_axi_awvalid,
        mstatic_axi_0_bready => mstatic_axi_bready,
        mstatic_axi_0_bresp(1 downto 0) => mstatic_axi_bresp(1 downto 0),
        mstatic_axi_0_bvalid => mstatic_axi_bvalid,
        mstatic_axi_0_rdata(31 downto 0) => mstatic_axi_rdata(31 downto 0),
        mstatic_axi_0_rlast => mstatic_axi_rlast,
        mstatic_axi_0_rready => mstatic_axi_rready,
        mstatic_axi_0_rresp(1 downto 0) => mstatic_axi_rresp(1 downto 0),
        mstatic_axi_0_rvalid => mstatic_axi_rvalid,
        mstatic_axi_0_wdata(31 downto 0) => mstatic_axi_wdata(31 downto 0),
        mstatic_axi_0_wlast => mstatic_axi_wlast,
        mstatic_axi_0_wready => mstatic_axi_wready,
        mstatic_axi_0_wstrb(3 downto 0) => mstatic_axi_wstrb(3 downto 0),
        mstatic_axi_0_wvalid => mstatic_axi_wvalid,
        mstatic_axi_aclk_0 => axi_clk,
        mstatic_axi_aresetn_0 => axi_aresetn,
        sstatic_axi_0_araddr(31 downto 0) => sstatic_axi_araddr(31 downto 0),
        sstatic_axi_0_arburst(1 downto 0) => sstatic_axi_arburst(1 downto 0),
        sstatic_axi_0_arcache(3 downto 0) => sstatic_axi_arcache(3 downto 0),
        sstatic_axi_0_arlen(7 downto 0) => sstatic_axi_arlen(7 downto 0),
        sstatic_axi_0_arlock(0) => sstatic_axi_arlock,
        sstatic_axi_0_arprot(2 downto 0) => sstatic_axi_arprot(2 downto 0),
        sstatic_axi_0_arqos(3 downto 0) => sstatic_axi_arqos(3 downto 0),
        sstatic_axi_0_arready => sstatic_axi_arready,
        sstatic_axi_0_arsize(2 downto 0) => sstatic_axi_arsize(2 downto 0),
        sstatic_axi_0_arvalid => sstatic_axi_arvalid,
        sstatic_axi_0_awaddr(31 downto 0) => sstatic_axi_awaddr(31 downto 0),
        sstatic_axi_0_awburst(1 downto 0) => sstatic_axi_awburst(1 downto 0),
        sstatic_axi_0_awcache(3 downto 0) => sstatic_axi_awcache(3 downto 0),
        sstatic_axi_0_awlen(7 downto 0) => sstatic_axi_awlen(7 downto 0),
        sstatic_axi_0_awlock(0) => sstatic_axi_awlock,
        sstatic_axi_0_awprot(2 downto 0) => sstatic_axi_awprot(2 downto 0),
        sstatic_axi_0_awqos(3 downto 0) => sstatic_axi_awqos(3 downto 0),
        sstatic_axi_0_awready => sstatic_axi_awready,
        sstatic_axi_0_awsize(2 downto 0) => sstatic_axi_awsize(2 downto 0),
        sstatic_axi_0_awvalid => sstatic_axi_awvalid,
        sstatic_axi_0_bready => sstatic_axi_bready,
        sstatic_axi_0_bresp(1 downto 0) => sstatic_axi_bresp(1 downto 0),
        sstatic_axi_0_bvalid => sstatic_axi_bvalid,
        sstatic_axi_0_rdata(31 downto 0) => sstatic_axi_rdata(31 downto 0),
        sstatic_axi_0_rlast => sstatic_axi_rlast,
        sstatic_axi_0_rready => sstatic_axi_rready,
        sstatic_axi_0_rresp(1 downto 0) => sstatic_axi_rresp(1 downto 0),
        sstatic_axi_0_rvalid => sstatic_axi_rvalid,
        sstatic_axi_0_wdata(31 downto 0) => sstatic_axi_wdata(31 downto 0),
        sstatic_axi_0_wlast => sstatic_axi_wlast,
        sstatic_axi_0_wready => sstatic_axi_wready,
        sstatic_axi_0_wstrb(3 downto 0) => sstatic_axi_wstrb(3 downto 0),
        sstatic_axi_0_wvalid => sstatic_axi_wvalid,

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

END Behavioral;
