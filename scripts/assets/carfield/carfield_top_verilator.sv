// Copyright 2026 SCORE Project
// SPDX-License-Identifier: Apache-2.0
//
// Native Verilator top-level wrapper for Carfield SoC platform.
// Connects Carfield silicon top with synthesizable serial link AXI bridge,
// JTAG, UART, and config exports for DPI-C preloader.

module carfield_top_verilator import cheshire_pkg::*; import carfield_pkg::*; #(
  parameter int unsigned SelectedCfg = 32'd0,
  parameter int unsigned RtcFreq     = 32'd0
) (
  input  logic        clk_i,
  input  logic        rst_ni,
  input  logic        rtc_i,
  input  logic [1:0]  boot_mode_i,
  // JTAG
  input  logic        jtag_tck_i,
  input  logic        jtag_trst_ni,
  input  logic        jtag_tms_i,
  input  logic        jtag_tdi_i,
  output logic        jtag_tdo_o,
  // UART
  output logic        uart_tx_o,
  input  logic        uart_rx_i,
  // AXI port into the mirror serial link (INCR bursts with ID 0)
  input  logic        slink_aw_valid_i,
  output logic        slink_aw_ready_o,
  input  logic [63:0] slink_aw_addr_i,
  input  logic [7:0]  slink_aw_len_i,
  input  logic [2:0]  slink_aw_size_i,
  input  logic        slink_w_valid_i,
  output logic        slink_w_ready_o,
  input  logic [63:0] slink_w_data_i,
  input  logic [7:0]  slink_w_strb_i,
  input  logic        slink_w_last_i,
  output logic        slink_b_valid_o,
  input  logic        slink_b_ready_i,
  output logic [1:0]  slink_b_resp_o,
  input  logic        slink_ar_valid_i,
  output logic        slink_ar_ready_o,
  input  logic [63:0] slink_ar_addr_i,
  input  logic [7:0]  slink_ar_len_i,
  input  logic [2:0]  slink_ar_size_i,
  output logic        slink_r_valid_o,
  input  logic        slink_r_ready_i,
  output logic [63:0] slink_r_data_o,
  output logic [1:0]  slink_r_resp_o,
  output logic        slink_r_last_o,
  // Debug: PC of the instruction at the commit stage of hart 0
  output logic [63:0] dbg_pc_commit_o
);

  `include "cheshire/typedef.svh"

  import cheshire_addrmap_pkg::*;

  function automatic cheshire_cfg_t gen_dut_cfg();
    cheshire_cfg_t ret = carfield_pkg::CheshireCfg;
    if (RtcFreq != 0) ret.RtcFreq = RtcFreq;
    return ret;
  endfunction

  localparam cheshire_cfg_t DutCfg = gen_dut_cfg();

  `CHESHIRE_TYPEDEF_ALL(, DutCfg)

  if (DutCfg.AxiDataWidth != 64 || DutCfg.AddrWidth > 64) begin : gen_cfg_check
    $fatal(1, "The Verilator harness requires a 64-bit AXI data width and <= 64-bit addresses.");
  end

  //////////////////////
  //  Config Exports  //
  //////////////////////

  export "DPI-C" function chs_vlt_get_cfg;

  function automatic void chs_vlt_get_cfg(
    output longint unsigned scratch_base,
    output longint unsigned llc_spm_cfg_addr,
    output byte unsigned    llc_not_bypass,
    output longint unsigned dram_base,
    output longint unsigned dram_end,
    output int unsigned     dbg_idcode,
    output int unsigned     rtc_freq
  );
    scratch_base     = REGS_SCRATCH_BASE_ADDR(0);
    llc_spm_cfg_addr = LLC_BASE_ADDR + axi_llc_reg_pkg::AXI_LLC_CFG_SPM_LOW_OFFSET;
    llc_not_bypass   = 8'(DutCfg.LlcNotBypass);
    dram_base        = DutCfg.LlcOutRegionStart;
    dram_end         = DutCfg.LlcOutRegionEnd;
    dbg_idcode       = DutCfg.DbgIdCode;
    rtc_freq         = DutCfg.RtcFreq;
  endfunction

  ///////////
  //  DUT  //
  ///////////

  logic i2c_sda_o, i2c_sda_en;
  logic i2c_scl_o, i2c_scl_en;
  logic [3:0] spih_sd_o, spih_sd_en;

  logic [SlinkNumChan-1:0]                    slink_rcv_clk_i;
  logic [SlinkNumChan-1:0]                    slink_rcv_clk_o;
  logic [SlinkNumChan-1:0][SlinkNumLanes-1:0] slink_i;
  logic [SlinkNumChan-1:0][SlinkNumLanes-1:0] slink_o;

  localparam int unsigned NumPhys  = 2;
  localparam int unsigned NumChips = 2;

  carfield #(
    .Cfg         ( DutCfg ),
    .HypNumPhys  ( NumPhys ),
    .HypNumChips ( NumChips ),
    .reg_req_t   ( reg_req_t ),
    .reg_rsp_t   ( reg_rsp_t )
  ) i_dut (
    .host_clk_i                 ( clk_i ),
    .periph_clk_i               ( clk_i ),
    .alt_clk_i                  ( clk_i ),
    .rt_clk_i                   ( rtc_i ),
    .pwr_on_rst_ni              ( rst_ni ),
    .test_mode_i                ( 1'b0 ),
    .boot_mode_i                ( boot_mode_i ),
    .jtag_tck_i                 ( jtag_tck_i ),
    .jtag_trst_ni               ( jtag_trst_ni ),
    .jtag_tms_i                 ( jtag_tms_i ),
    .jtag_tdi_i                 ( jtag_tdi_i ),
    .jtag_tdo_o                 ( jtag_tdo_o ),
    .jtag_tdo_oe_o              ( ),
    .jtag_ot_tck_i              ( 1'b0 ),
    .jtag_ot_trst_ni            ( 1'b0 ),
    .jtag_ot_tms_i              ( 1'b0 ),
    .jtag_ot_tdi_i              ( 1'b0 ),
    .jtag_ot_tdo_o              ( ),
    .jtag_ot_tdo_oe_o           ( ),
    .jtag_safety_island_tck_i   ( 1'b0 ),
    .jtag_safety_island_trst_ni ( 1'b0 ),
    .jtag_safety_island_tms_i   ( 1'b0 ),
    .jtag_safety_island_tdi_i   ( 1'b0 ),
    .jtag_safety_island_tdo_o   ( ),
    .bootmode_ot_i              ( '0 ),
    .bootmode_safe_isln_i       ( '0 ),
    .secure_boot_i              ( 1'b0 ),
    .uart_tx_o                  ( uart_tx_o ),
    .uart_rx_i                  ( uart_rx_i ),
    .uart_ot_tx_o               ( ),
    .uart_ot_rx_i               ( 1'b1 ),
    .i2c_sda_o                  ( i2c_sda_o ),
    .i2c_sda_i                  ( i2c_sda_en ? i2c_sda_o : 1'b1 ),
    .i2c_sda_en_o               ( i2c_sda_en ),
    .i2c_scl_o                  ( i2c_scl_o ),
    .i2c_scl_i                  ( i2c_scl_en ? i2c_scl_o : 1'b1 ),
    .i2c_scl_en_o               ( i2c_scl_en ),
    .spih_sck_o                 ( ),
    .spih_sck_en_o              ( ),
    .spih_csb_o                 ( ),
    .spih_csb_en_o              ( ),
    .spih_sd_o                  ( spih_sd_o ),
    .spih_sd_en_o               ( spih_sd_en ),
    .spih_sd_i                  ( (spih_sd_o & spih_sd_en) | ~spih_sd_en ),
    .spih_ot_sck_o              ( ),
    .spih_ot_sck_en_o           ( ),
    .spih_ot_csb_o              ( ),
    .spih_ot_csb_en_o           ( ),
    .spih_ot_sd_o               ( ),
    .spih_ot_sd_en_o            ( ),
    .spih_ot_sd_i               ( '1 ),
    .eth_rxck_i                 ( 1'b0 ),
    .eth_rxctl_i                ( 1'b0 ),
    .eth_rxd_i                  ( '0 ),
    .eth_md_i                   ( 1'b0 ),
    .eth_txck_o                 ( ),
    .eth_txctl_o                ( ),
    .eth_txd_o                  ( ),
    .eth_md_o                   ( ),
    .eth_md_oe                  ( ),
    .eth_mdc_o                  ( ),
    .eth_rst_n_o                ( ),
    .can_rx_i                   ( 1'b1 ),
    .can_tx_o                   ( ),
    .gpio_i                     ( '0 ),
    .gpio_o                     ( ),
    .gpio_en_o                  ( ),
    .slink_rcv_clk_i            ( slink_rcv_clk_i ),
    .slink_rcv_clk_o            ( slink_rcv_clk_o ),
    .slink_i                    ( slink_i ),
    .slink_o                    ( slink_o ),
    .hyper_cs_no                ( ),
    .hyper_ck_o                 ( ),
    .hyper_ck_no                ( ),
    .hyper_rwds_o               ( ),
    .hyper_rwds_i               ( '0 ),
    .hyper_rwds_oe_o            ( ),
    .hyper_dq_i                 ( '0 ),
    .hyper_dq_o                 ( ),
    .hyper_dq_oe_o              ( ),
    .hyper_reset_no             ( ),
    .ext_reg_async_slv_req_o    ( ),
    .ext_reg_async_slv_ack_i    ( '0 ),
    .ext_reg_async_slv_data_o   ( ),
    .ext_reg_async_slv_req_i    ( '0 ),
    .ext_reg_async_slv_ack_o    ( ),
    .ext_reg_async_slv_data_i   ( '0 ),
    .debug_signals_o            ( )
  );

  assign dbg_pc_commit_o = 64'(i_dut.i_cheshire_wrap.i_cheshire_soc.gen_cva6_cores[0].i_core_cva6.pc_commit);

  /////////////////
  // Serial Link //
  /////////////////

  axi_mst_req_t slink_axi_req;
  axi_mst_rsp_t slink_axi_rsp;

  assign slink_axi_req.aw.id     = '0;
  assign slink_axi_req.aw.addr   = slink_aw_addr_i;
  assign slink_axi_req.aw.len    = slink_aw_len_i;
  assign slink_axi_req.aw.size   = slink_aw_size_i;
  assign slink_axi_req.aw.burst  = axi_pkg::BURST_INCR;
  assign slink_axi_req.aw.lock   = 1'b0;
  assign slink_axi_req.aw.cache  = axi_pkg::CACHE_MODIFIABLE;
  assign slink_axi_req.aw.prot   = '0;
  assign slink_axi_req.aw.qos    = '0;
  assign slink_axi_req.aw.region = '0;
  assign slink_axi_req.aw.atop   = '0;
  assign slink_axi_req.aw.user   = '0;
  assign slink_axi_req.aw_valid  = slink_aw_valid_i;
  assign slink_aw_ready_o        = slink_axi_rsp.aw_ready;

  assign slink_axi_req.w.data    = slink_w_data_i;
  assign slink_axi_req.w.strb    = slink_w_strb_i;
  assign slink_axi_req.w.last    = slink_w_last_i;
  assign slink_axi_req.w.user    = '0;
  assign slink_axi_req.w_valid   = slink_w_valid_i;
  assign slink_w_ready_o         = slink_axi_rsp.w_ready;

  assign slink_b_valid_o         = slink_axi_rsp.b_valid;
  assign slink_axi_req.b_ready   = slink_b_ready_i;
  assign slink_b_resp_o          = slink_axi_rsp.b.resp;

  assign slink_axi_req.ar.id     = '0;
  assign slink_axi_req.ar.addr   = slink_ar_addr_i;
  assign slink_axi_req.ar.len    = slink_ar_len_i;
  assign slink_axi_req.ar.size   = slink_ar_size_i;
  assign slink_axi_req.ar.burst  = axi_pkg::BURST_INCR;
  assign slink_axi_req.ar.lock   = 1'b0;
  assign slink_axi_req.ar.cache  = axi_pkg::CACHE_MODIFIABLE;
  assign slink_axi_req.ar.prot   = '0;
  assign slink_axi_req.ar.qos    = '0;
  assign slink_axi_req.ar.region = '0;
  assign slink_axi_req.ar.user   = '0;
  assign slink_axi_req.ar_valid  = slink_ar_valid_i;
  assign slink_ar_ready_o        = slink_axi_rsp.ar_ready;

  assign slink_r_valid_o         = slink_axi_rsp.r_valid;
  assign slink_axi_req.r_ready   = slink_r_ready_i;
  assign slink_r_data_o          = slink_axi_rsp.r.data;
  assign slink_r_resp_o          = slink_axi_rsp.r.resp;
  assign slink_r_last_o          = slink_axi_rsp.r.last;

  serial_link #(
    .axi_req_t  ( axi_mst_req_t ),
    .axi_rsp_t  ( axi_mst_rsp_t ),
    .cfg_req_t  ( reg_req_t ),
    .cfg_rsp_t  ( reg_rsp_t ),
    .aw_chan_t  ( axi_mst_aw_chan_t ),
    .ar_chan_t  ( axi_mst_ar_chan_t ),
    .r_chan_t   ( axi_mst_r_chan_t ),
    .w_chan_t   ( axi_mst_w_chan_t ),
    .b_chan_t   ( axi_mst_b_chan_t ),
    .hw2reg_t   ( serial_link_single_channel_reg_pkg::serial_link_single_channel_hw2reg_t ),
    .reg2hw_t   ( serial_link_single_channel_reg_pkg::serial_link_single_channel_reg2hw_t ),
    .NumChannels( SlinkNumChan ),
    .NumLanes   ( SlinkNumLanes ),
    .MaxClkDiv  ( SlinkMaxClkDiv )
  ) i_host_serial_link (
    .clk_i        ( clk_i ),
    .rst_ni       ( rst_ni ),
    .clk_sl_i     ( clk_i ),
    .rst_sl_ni    ( rst_ni ),
    .clk_reg_i    ( clk_i ),
    .rst_reg_ni   ( rst_ni ),
    .testmode_i   ( 1'b0 ),
    .axi_in_req_i ( slink_axi_req ),
    .axi_in_rsp_o ( slink_axi_rsp ),
    .axi_out_req_o( ),
    .axi_out_rsp_i( '0 ),
    .cfg_req_i    ( '0 ),
    .cfg_rsp_o    ( ),
    .ddr_rcv_clk_i( slink_rcv_clk_o ),
    .ddr_rcv_clk_o( slink_rcv_clk_i ),
    .ddr_i        ( slink_o ),
    .ddr_o        ( slink_i )
  );

endmodule
