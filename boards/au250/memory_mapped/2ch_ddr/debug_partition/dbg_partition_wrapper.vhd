--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
--Date        : Tue Nov  4 19:24:24 2025
--Host        : burtsev-office-g3 running 64-bit Debian GNU/Linux 12 (bookworm)
--Command     : generate_target dbg_partition_wrapper.bd
--Design      : dbg_partition_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity dbg_partition_wrapper is
  port (
    S_BSCAN_bscanid_en : in STD_LOGIC;
    S_BSCAN_capture : in STD_LOGIC;
    S_BSCAN_drck : in STD_LOGIC;
    S_BSCAN_reset : in STD_LOGIC;
    S_BSCAN_runtest : in STD_LOGIC;
    S_BSCAN_sel : in STD_LOGIC;
    S_BSCAN_shift : in STD_LOGIC;
    S_BSCAN_tck : in STD_LOGIC;
    S_BSCAN_tdi : in STD_LOGIC;
    S_BSCAN_tdo : out STD_LOGIC;
    S_BSCAN_tms : in STD_LOGIC;
    S_BSCAN_update : in STD_LOGIC;
    mstatic_axi_0_araddr : in STD_LOGIC_VECTOR ( 36 downto 0 );
    mstatic_axi_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    mstatic_axi_0_arlock : in STD_LOGIC_VECTOR ( 0 to 0 );
    mstatic_axi_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mstatic_axi_0_arready : out STD_LOGIC;
    mstatic_axi_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    mstatic_axi_0_arvalid : in STD_LOGIC;
    mstatic_axi_0_awaddr : in STD_LOGIC_VECTOR ( 36 downto 0 );
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
    mstatic_axi_0_rdata : out STD_LOGIC_VECTOR ( 511 downto 0 );
    mstatic_axi_0_rlast : out STD_LOGIC;
    mstatic_axi_0_rready : in STD_LOGIC;
    mstatic_axi_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    mstatic_axi_0_rvalid : out STD_LOGIC;
    mstatic_axi_0_wdata : in STD_LOGIC_VECTOR ( 511 downto 0 );
    mstatic_axi_0_wlast : in STD_LOGIC;
    mstatic_axi_0_wready : out STD_LOGIC;
    mstatic_axi_0_wstrb : in STD_LOGIC_VECTOR ( 63 downto 0 );
    mstatic_axi_0_wvalid : in STD_LOGIC;
    mstatic_axi_aclk_0 : in STD_LOGIC;
    mstatic_axi_aresetn_0 : in STD_LOGIC;
    sstatic_axi_0_araddr : out STD_LOGIC_VECTOR ( 36 downto 0 );
    sstatic_axi_0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    sstatic_axi_0_arlock : out STD_LOGIC_VECTOR ( 0 to 0 );
    sstatic_axi_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    sstatic_axi_0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    sstatic_axi_0_arready : in STD_LOGIC;
    sstatic_axi_0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    sstatic_axi_0_arvalid : out STD_LOGIC;
    sstatic_axi_0_awaddr : out STD_LOGIC_VECTOR ( 36 downto 0 );
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
    sstatic_axi_0_rdata : in STD_LOGIC_VECTOR ( 511 downto 0 );
    sstatic_axi_0_rlast : in STD_LOGIC;
    sstatic_axi_0_rready : out STD_LOGIC;
    sstatic_axi_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    sstatic_axi_0_rvalid : in STD_LOGIC;
    sstatic_axi_0_wdata : out STD_LOGIC_VECTOR ( 511 downto 0 );
    sstatic_axi_0_wlast : out STD_LOGIC;
    sstatic_axi_0_wready : in STD_LOGIC;
    sstatic_axi_0_wstrb : out STD_LOGIC_VECTOR ( 63 downto 0 );
    sstatic_axi_0_wvalid : out STD_LOGIC
  );
end dbg_partition_wrapper;

architecture STRUCTURE of dbg_partition_wrapper is
  component dbg_partition is
  port (
    mstatic_axi_aclk_0 : in STD_LOGIC;
    mstatic_axi_aresetn_0 : in STD_LOGIC;
    S_BSCAN_drck : in STD_LOGIC;
    S_BSCAN_tdo : out STD_LOGIC;
    S_BSCAN_shift : in STD_LOGIC;
    S_BSCAN_tdi : in STD_LOGIC;
    S_BSCAN_update : in STD_LOGIC;
    S_BSCAN_sel : in STD_LOGIC;
    S_BSCAN_tms : in STD_LOGIC;
    S_BSCAN_tck : in STD_LOGIC;
    S_BSCAN_runtest : in STD_LOGIC;
    S_BSCAN_reset : in STD_LOGIC;
    S_BSCAN_capture : in STD_LOGIC;
    S_BSCAN_bscanid_en : in STD_LOGIC;
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
  end component dbg_partition;
begin
dbg_partition_i: component dbg_partition
     port map (
      S_BSCAN_bscanid_en => S_BSCAN_bscanid_en,
      S_BSCAN_capture => S_BSCAN_capture,
      S_BSCAN_drck => S_BSCAN_drck,
      S_BSCAN_reset => S_BSCAN_reset,
      S_BSCAN_runtest => S_BSCAN_runtest,
      S_BSCAN_sel => S_BSCAN_sel,
      S_BSCAN_shift => S_BSCAN_shift,
      S_BSCAN_tck => S_BSCAN_tck,
      S_BSCAN_tdi => S_BSCAN_tdi,
      S_BSCAN_tdo => S_BSCAN_tdo,
      S_BSCAN_tms => S_BSCAN_tms,
      S_BSCAN_update => S_BSCAN_update,
      mstatic_axi_0_araddr(36 downto 0) => mstatic_axi_0_araddr(36 downto 0),
      mstatic_axi_0_arburst(1 downto 0) => mstatic_axi_0_arburst(1 downto 0),
      mstatic_axi_0_arcache(3 downto 0) => mstatic_axi_0_arcache(3 downto 0),
      mstatic_axi_0_arlen(7 downto 0) => mstatic_axi_0_arlen(7 downto 0),
      mstatic_axi_0_arlock(0) => mstatic_axi_0_arlock(0),
      mstatic_axi_0_arprot(2 downto 0) => mstatic_axi_0_arprot(2 downto 0),
      mstatic_axi_0_arqos(3 downto 0) => mstatic_axi_0_arqos(3 downto 0),
      mstatic_axi_0_arready => mstatic_axi_0_arready,
      mstatic_axi_0_arsize(2 downto 0) => mstatic_axi_0_arsize(2 downto 0),
      mstatic_axi_0_arvalid => mstatic_axi_0_arvalid,
      mstatic_axi_0_awaddr(36 downto 0) => mstatic_axi_0_awaddr(36 downto 0),
      mstatic_axi_0_awburst(1 downto 0) => mstatic_axi_0_awburst(1 downto 0),
      mstatic_axi_0_awcache(3 downto 0) => mstatic_axi_0_awcache(3 downto 0),
      mstatic_axi_0_awlen(7 downto 0) => mstatic_axi_0_awlen(7 downto 0),
      mstatic_axi_0_awlock(0) => mstatic_axi_0_awlock(0),
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
      mstatic_axi_aclk_0 => mstatic_axi_aclk_0,
      mstatic_axi_aresetn_0 => mstatic_axi_aresetn_0,
      sstatic_axi_0_araddr(36 downto 0) => sstatic_axi_0_araddr(36 downto 0),
      sstatic_axi_0_arburst(1 downto 0) => sstatic_axi_0_arburst(1 downto 0),
      sstatic_axi_0_arcache(3 downto 0) => sstatic_axi_0_arcache(3 downto 0),
      sstatic_axi_0_arlen(7 downto 0) => sstatic_axi_0_arlen(7 downto 0),
      sstatic_axi_0_arlock(0) => sstatic_axi_0_arlock(0),
      sstatic_axi_0_arprot(2 downto 0) => sstatic_axi_0_arprot(2 downto 0),
      sstatic_axi_0_arqos(3 downto 0) => sstatic_axi_0_arqos(3 downto 0),
      sstatic_axi_0_arready => sstatic_axi_0_arready,
      sstatic_axi_0_arsize(2 downto 0) => sstatic_axi_0_arsize(2 downto 0),
      sstatic_axi_0_arvalid => sstatic_axi_0_arvalid,
      sstatic_axi_0_awaddr(36 downto 0) => sstatic_axi_0_awaddr(36 downto 0),
      sstatic_axi_0_awburst(1 downto 0) => sstatic_axi_0_awburst(1 downto 0),
      sstatic_axi_0_awcache(3 downto 0) => sstatic_axi_0_awcache(3 downto 0),
      sstatic_axi_0_awlen(7 downto 0) => sstatic_axi_0_awlen(7 downto 0),
      sstatic_axi_0_awlock(0) => sstatic_axi_0_awlock(0),
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
      sstatic_axi_0_wvalid => sstatic_axi_0_wvalid
    );
end STRUCTURE;
