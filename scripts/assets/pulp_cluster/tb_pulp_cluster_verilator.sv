// Copyright 2026 SCORE Project.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Standalone Verilator Testbench for 8-core PULP Cluster SoC.
// Boots preloaded software binaries via synchronous AXI & Gray CDC without commercial EDA tools.

`timescale 1ns/1ps

`include "axi/typedef.svh"

module tb_pulp_cluster_verilator;
  import pulp_cluster_package::*;

  localparam time ClkPeriodSys = 10ns; // 100 MHz

  localparam int unsigned AxiAw = 32;
  localparam int unsigned AxiDw = 64;
  localparam int unsigned AxiIdInWidth = 4;
  localparam int unsigned AxiIdOutWidth = 6;
  localparam int unsigned AxiUw = 10;
  localparam int unsigned AxiCdcLogDepth = 3;
  localparam int unsigned AxiCdcSyncStages = 3;

  localparam bit [AxiAw-1:0] ClustBase       = 32'h1000_0000;
  localparam bit [AxiAw-1:0] ClustPeriphOffs = 32'h0020_0000;
  localparam bit [AxiAw-1:0] ClustReturnInt  = ClustBase + ClustPeriphOffs + 32'h100; // 0x1020_0100
  localparam bit [AxiAw-1:0] EocRegAddr      = ClustBase + ClustPeriphOffs + 32'h000; // 0x1020_0000
  localparam bit [AxiAw-1:0] FetchEnRegAddr  = ClustBase + ClustPeriphOffs + 32'h008; // 0x1020_0008
  localparam bit [AxiAw-1:0] BootAddrRegBase = ClustBase + ClustPeriphOffs + 32'h040; // 0x1020_0040 + i*4

  localparam bit [AxiAw-1:0] L2BaseAddr      = 32'h1C00_0000;
  localparam int unsigned    L2SizeBytes     = 1024 * 1024; // 1MB L2 memory
  localparam int unsigned    L2Words64       = L2SizeBytes / 8; // 131,072 64-bit words

  localparam bit [AxiAw-1:0] MockUartBase    = 32'h0300_2000;
  localparam bit [AxiAw-1:0] MockUartEnd     = 32'h0300_3000;

  // Type definitions for Cluster-to-SoC (c2s): Cluster is Master (IdWidth = 6)
  `AXI_TYPEDEF_AW_CHAN_T(c2s_aw_chan_t, logic [AxiAw-1:0], logic [AxiIdOutWidth-1:0], logic [AxiUw-1:0])
  `AXI_TYPEDEF_W_CHAN_T(c2s_w_chan_t, logic [AxiDw-1:0], logic [AxiDw/8-1:0], logic [AxiUw-1:0])
  `AXI_TYPEDEF_B_CHAN_T(c2s_b_chan_t, logic [AxiIdOutWidth-1:0], logic [AxiUw-1:0])
  `AXI_TYPEDEF_AR_CHAN_T(c2s_ar_chan_t, logic [AxiAw-1:0], logic [AxiIdOutWidth-1:0], logic [AxiUw-1:0])
  `AXI_TYPEDEF_R_CHAN_T(c2s_r_chan_t, logic [AxiDw-1:0], logic [AxiIdOutWidth-1:0], logic [AxiUw-1:0])
  `AXI_TYPEDEF_REQ_T(c2s_req_t, c2s_aw_chan_t, c2s_w_chan_t, c2s_ar_chan_t)
  `AXI_TYPEDEF_RESP_T(c2s_resp_t, c2s_b_chan_t, c2s_r_chan_t)

  // Type definitions for SoC-to-Cluster (s2c): SoC is Master (IdWidth = 4)
  `AXI_TYPEDEF_AW_CHAN_T(s2c_aw_chan_t, logic [AxiAw-1:0], logic [AxiIdInWidth-1:0], logic [AxiUw-1:0])
  `AXI_TYPEDEF_W_CHAN_T(s2c_w_chan_t, logic [AxiDw-1:0], logic [AxiDw/8-1:0], logic [AxiUw-1:0])
  `AXI_TYPEDEF_B_CHAN_T(s2c_b_chan_t, logic [AxiIdInWidth-1:0], logic [AxiUw-1:0])
  `AXI_TYPEDEF_AR_CHAN_T(s2c_ar_chan_t, logic [AxiAw-1:0], logic [AxiIdInWidth-1:0], logic [AxiUw-1:0])
  `AXI_TYPEDEF_R_CHAN_T(s2c_r_chan_t, logic [AxiDw-1:0], logic [AxiIdInWidth-1:0], logic [AxiUw-1:0])
  `AXI_TYPEDEF_REQ_T(s2c_req_t, s2c_aw_chan_t, s2c_w_chan_t, s2c_ar_chan_t)
  `AXI_TYPEDEF_RESP_T(s2c_resp_t, s2c_b_chan_t, s2c_r_chan_t)

  // Clock, Reset, and Control
  logic clk;
  logic rst_n;
  logic s_cluster_en_sa_boot;
  logic s_cluster_fetch_en;
  logic s_cluster_eoc;
  logic s_cluster_busy;

  longint unsigned cycle_cnt;
  longint unsigned total_instr_ret;

  // L2 Memory Array (1MB = 131072 x 64-bit words)
  logic [63:0] l2_mem [0:L2Words64-1];

  // Synchronous AXI requests and responses
  s2c_req_t   s2c_req;
  s2c_resp_t  s2c_resp;

  c2s_req_t   c2s_req;
  c2s_resp_t  c2s_resp;

  // Async Gray CDC signals between testbench and pulp_cluster
  localparam int unsigned AsyncInAwDatawidth  = (2**AxiCdcLogDepth) * $bits(s2c_aw_chan_t);
  localparam int unsigned AsyncInArDatawidth  = (2**AxiCdcLogDepth) * $bits(s2c_ar_chan_t);
  localparam int unsigned AsyncInWDatawidth   = (2**AxiCdcLogDepth) * $bits(s2c_w_chan_t);
  localparam int unsigned AsyncInRDataWidth   = (2**AxiCdcLogDepth) * $bits(s2c_r_chan_t);
  localparam int unsigned AsyncInBDataWidth   = (2**AxiCdcLogDepth) * $bits(s2c_b_chan_t);

  localparam int unsigned AsyncOutAwDataWidth = (2**AxiCdcLogDepth) * $bits(c2s_aw_chan_t);
  localparam int unsigned AsyncOutArDataWidth = (2**AxiCdcLogDepth) * $bits(c2s_ar_chan_t);
  localparam int unsigned AsyncOutWDataWidth  = (2**AxiCdcLogDepth) * $bits(c2s_w_chan_t);
  localparam int unsigned AsyncOutRDataWidth  = (2**AxiCdcLogDepth) * $bits(c2s_r_chan_t);
  localparam int unsigned AsyncOutBDataWidth  = (2**AxiCdcLogDepth) * $bits(c2s_b_chan_t);

  logic [AxiCdcLogDepth:0]       async_s2c_aw_wptr;
  logic [AxiCdcLogDepth:0]       async_s2c_aw_rptr;
  logic [AsyncInAwDatawidth-1:0] async_s2c_aw_data;
  logic [AxiCdcLogDepth:0]       async_s2c_ar_wptr;
  logic [AxiCdcLogDepth:0]       async_s2c_ar_rptr;
  logic [AsyncInArDatawidth-1:0] async_s2c_ar_data;
  logic [AxiCdcLogDepth:0]       async_s2c_w_wptr;
  logic [AxiCdcLogDepth:0]       async_s2c_w_rptr;
  logic [AsyncInWDatawidth-1:0]  async_s2c_w_data;
  logic [AxiCdcLogDepth:0]       async_s2c_b_wptr;
  logic [AxiCdcLogDepth:0]       async_s2c_b_rptr;
  logic [AsyncInBDataWidth-1:0]  async_s2c_b_data;
  logic [AxiCdcLogDepth:0]       async_s2c_r_wptr;
  logic [AxiCdcLogDepth:0]       async_s2c_r_rptr;
  logic [AsyncInRDataWidth-1:0]  async_s2c_r_data;

  logic [AxiCdcLogDepth:0]        async_c2s_aw_wptr;
  logic [AxiCdcLogDepth:0]        async_c2s_aw_rptr;
  logic [AsyncOutAwDataWidth-1:0] async_c2s_aw_data;
  logic [AxiCdcLogDepth:0]        async_c2s_ar_wptr;
  logic [AxiCdcLogDepth:0]        async_c2s_ar_rptr;
  logic [AsyncOutArDataWidth-1:0] async_c2s_ar_data;
  logic [AxiCdcLogDepth:0]        async_c2s_w_wptr;
  logic [AxiCdcLogDepth:0]        async_c2s_w_rptr;
  logic [AsyncOutWDataWidth-1:0]  async_c2s_w_data;
  logic [AxiCdcLogDepth:0]        async_c2s_b_wptr;
  logic [AxiCdcLogDepth:0]        async_c2s_b_rptr;
  logic [AsyncOutBDataWidth-1:0]  async_c2s_b_data;
  logic [AxiCdcLogDepth:0]        async_c2s_r_wptr;
  logic [AxiCdcLogDepth:0]        async_c2s_r_rptr;
  logic [AsyncOutRDataWidth-1:0]  async_c2s_r_data;

  // Clock generation
  initial begin
    clk = 0;
    forever #(ClkPeriodSys/2) clk = ~clk;
  end

  // Cycle counter
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cycle_cnt <= 64'd0;
    end else begin
      cycle_cnt <= cycle_cnt + 64'd1;
    end
  end

  // Instruction retirement monitoring across 8 cores
  logic [7:0] core_instr_ret;
  for (genvar c = 0; c < 8; c++) begin : gen_retire_mon
    assign core_instr_ret[c] = i_dut.CORE[c].core_region_i.RI5CY_CORE.RI5CY_CORE.id_stage_i.instr_valid_i &
                               i_dut.CORE[c].core_region_i.RI5CY_CORE.RI5CY_CORE.id_stage_i.is_decoding_o;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      total_instr_ret <= 64'd0;
    end else if (s_cluster_fetch_en) begin
      total_instr_ret <= total_instr_ret + $countones(core_instr_ret);
    end
  end

  //----------------------------------------------------------------------------
  // CDC Converters
  //----------------------------------------------------------------------------
  // SoC-to-Cluster: Converts synchronous s2c AXI to async gray pointers
  axi_cdc_src #(
    .aw_chan_t   ( s2c_aw_chan_t     ),
    .w_chan_t    ( s2c_w_chan_t      ),
    .b_chan_t    ( s2c_b_chan_t      ),
    .ar_chan_t   ( s2c_ar_chan_t     ),
    .r_chan_t    ( s2c_r_chan_t      ),
    .axi_req_t   ( s2c_req_t         ),
    .axi_resp_t  ( s2c_resp_t        ),
    .LogDepth    ( AxiCdcLogDepth    ),
    .SyncStages  ( AxiCdcSyncStages  )
  ) i_s2c_cdc_src (
    .src_clk_i                   ( clk               ),
    .src_rst_ni                  ( rst_n             ),
    .src_req_i                   ( s2c_req           ),
    .src_resp_o                  ( s2c_resp          ),
    .async_data_master_aw_wptr_o ( async_s2c_aw_wptr ),
    .async_data_master_aw_rptr_i ( async_s2c_aw_rptr ),
    .async_data_master_aw_data_o ( async_s2c_aw_data ),
    .async_data_master_w_wptr_o  ( async_s2c_w_wptr  ),
    .async_data_master_w_rptr_i  ( async_s2c_w_rptr  ),
    .async_data_master_w_data_o  ( async_s2c_w_data  ),
    .async_data_master_b_wptr_i  ( async_s2c_b_wptr  ),
    .async_data_master_b_rptr_o  ( async_s2c_b_rptr  ),
    .async_data_master_b_data_i  ( async_s2c_b_data  ),
    .async_data_master_ar_wptr_o ( async_s2c_ar_wptr ),
    .async_data_master_ar_rptr_i ( async_s2c_ar_rptr ),
    .async_data_master_ar_data_o ( async_s2c_ar_data ),
    .async_data_master_r_wptr_i  ( async_s2c_r_wptr  ),
    .async_data_master_r_rptr_o  ( async_s2c_r_rptr  ),
    .async_data_master_r_data_i  ( async_s2c_r_data  )
  );

  // Cluster-to-SoC: Converts async gray pointers from cluster to synchronous c2s AXI
  axi_cdc_dst #(
    .aw_chan_t   ( c2s_aw_chan_t     ),
    .w_chan_t    ( c2s_w_chan_t      ),
    .b_chan_t    ( c2s_b_chan_t      ),
    .ar_chan_t   ( c2s_ar_chan_t     ),
    .r_chan_t    ( c2s_r_chan_t      ),
    .axi_req_t   ( c2s_req_t         ),
    .axi_resp_t  ( c2s_resp_t        ),
    .LogDepth    ( AxiCdcLogDepth    ),
    .SyncStages  ( AxiCdcSyncStages  )
  ) i_c2s_cdc_dst (
    .dst_clk_i                  ( clk               ),
    .dst_rst_ni                 ( rst_n             ),
    .dst_req_o                  ( c2s_req           ),
    .dst_resp_i                 ( c2s_resp          ),
    .async_data_slave_aw_wptr_i ( async_c2s_aw_wptr ),
    .async_data_slave_aw_rptr_o ( async_c2s_aw_rptr ),
    .async_data_slave_aw_data_i ( async_c2s_aw_data ),
    .async_data_slave_w_wptr_i  ( async_c2s_w_wptr  ),
    .async_data_slave_w_rptr_o  ( async_c2s_w_rptr  ),
    .async_data_slave_w_data_i  ( async_c2s_w_data  ),
    .async_data_slave_b_wptr_o  ( async_c2s_b_wptr  ),
    .async_data_slave_b_rptr_i  ( async_c2s_b_rptr  ),
    .async_data_slave_b_data_o  ( async_c2s_b_data  ),
    .async_data_slave_ar_wptr_i ( async_c2s_ar_wptr ),
    .async_data_slave_ar_rptr_o ( async_c2s_ar_rptr ),
    .async_data_slave_ar_data_i ( async_c2s_ar_data ),
    .async_data_slave_r_wptr_o  ( async_c2s_r_wptr  ),
    .async_data_slave_r_rptr_i  ( async_c2s_r_rptr  ),
    .async_data_slave_r_data_o  ( async_c2s_r_data  )
  );

  //----------------------------------------------------------------------------
  // DUT Instantiation: pulp_cluster
  //----------------------------------------------------------------------------
  pulp_cluster i_dut (
    .clk_i                       ( clk                         ),
    .rst_ni                      ( rst_n                       ),
    .pwr_on_rst_ni               ( rst_n                       ),
    .ref_clk_i                   ( clk                         ),
    .axi_isolate_i               ( 1'b0                        ),
    .axi_isolated_o              (                             ),
    .pmu_mem_pwdn_i              ( 1'b0                        ),
    .base_addr_i                 ( ClustBase[31:28]            ), // 4'h1
    .test_mode_i                 ( 1'b0                        ),
    .en_sa_boot_i                ( s_cluster_en_sa_boot        ),
    .cluster_id_i                ( 6'd0                        ),
    .fetch_en_i                  ( s_cluster_fetch_en          ),
    .eoc_o                       ( s_cluster_eoc               ),
    .busy_o                      ( s_cluster_busy              ),
    .dma_pe_evt_ack_i            ( 1'b1                        ),
    .dma_pe_evt_valid_o          (                             ),
    .dma_pe_irq_ack_i            ( 1'b1                        ),
    .dma_pe_irq_valid_o          (                             ),
    .pf_evt_ack_i                ( 1'b1                        ),
    .pf_evt_valid_o              (                             ),
    .dbg_irq_valid_i             ( '0                          ),
    .mbox_irq_i                  ( 1'b0                        ),
    .async_cluster_events_wptr_i ( '0                          ),
    .async_cluster_events_rptr_o (                             ),
    .async_cluster_events_data_i ( '0                          ),

    // Slave CDC (SoC -> Cluster)
    .async_data_slave_aw_wptr_i  ( async_s2c_aw_wptr           ),
    .async_data_slave_aw_data_i  ( async_s2c_aw_data           ),
    .async_data_slave_aw_rptr_o  ( async_s2c_aw_rptr           ),
    .async_data_slave_ar_wptr_i  ( async_s2c_ar_wptr           ),
    .async_data_slave_ar_data_i  ( async_s2c_ar_data           ),
    .async_data_slave_ar_rptr_o  ( async_s2c_ar_rptr           ),
    .async_data_slave_w_wptr_i   ( async_s2c_w_wptr            ),
    .async_data_slave_w_data_i   ( async_s2c_w_data            ),
    .async_data_slave_w_rptr_o   ( async_s2c_w_rptr            ),
    .async_data_slave_r_wptr_o   ( async_s2c_r_wptr            ),
    .async_data_slave_r_data_o   ( async_s2c_r_data            ),
    .async_data_slave_r_rptr_i   ( async_s2c_r_rptr            ),
    .async_data_slave_b_wptr_o   ( async_s2c_b_wptr            ),
    .async_data_slave_b_data_o   ( async_s2c_b_data            ),
    .async_data_slave_b_rptr_i   ( async_s2c_b_rptr            ),

    // Master CDC (Cluster -> SoC)
    .async_data_master_aw_wptr_o ( async_c2s_aw_wptr           ),
    .async_data_master_aw_data_o ( async_c2s_aw_data           ),
    .async_data_master_aw_rptr_i ( async_c2s_aw_rptr           ),
    .async_data_master_ar_wptr_o ( async_c2s_ar_wptr           ),
    .async_data_master_ar_data_o ( async_c2s_ar_data           ),
    .async_data_master_ar_rptr_i ( async_c2s_ar_rptr           ),
    .async_data_master_w_wptr_o  ( async_c2s_w_wptr            ),
    .async_data_master_w_data_o  ( async_c2s_w_data            ),
    .async_data_master_w_rptr_i  ( async_c2s_w_rptr            ),
    .async_data_master_r_wptr_i  ( async_c2s_r_wptr            ),
    .async_data_master_r_data_i  ( async_c2s_r_data            ),
    .async_data_master_r_rptr_o  ( async_c2s_r_rptr            ),
    .async_data_master_b_wptr_i  ( async_c2s_b_wptr            ),
    .async_data_master_b_data_i  ( async_c2s_b_data            ),
    .async_data_master_b_rptr_o  ( async_c2s_b_rptr            )
  );

  //----------------------------------------------------------------------------
  // AXI to Memory Adapter & L2 Memory / UART Responder
  //----------------------------------------------------------------------------
  logic [0:0]           mem_req;
  logic [0:0]           mem_gnt;
  logic [0:0][AxiAw-1:0] mem_addr;
  logic [0:0][AxiDw-1:0] mem_wdata;
  logic [0:0][AxiDw/8-1:0] mem_strb;
  axi_pkg::atop_t [0:0] mem_atop;
  logic [0:0]           mem_we;
  logic [0:0]           mem_rvalid;
  logic [0:0][AxiDw-1:0] mem_rdata;

  axi_to_mem #(
    .axi_req_t    ( c2s_req_t     ),
    .axi_resp_t   ( c2s_resp_t    ),
    .AddrWidth    ( AxiAw         ),
    .DataWidth    ( AxiDw         ),
    .IdWidth      ( AxiIdOutWidth ),
    .NumBanks     ( 1             ),
    .BufDepth     ( 1             ),
    .HideStrb     ( 1'b0          ),
    .OutFifoDepth ( 1             )
  ) i_axi_to_mem (
    .clk_i        ( clk           ),
    .rst_ni       ( rst_n         ),
    .busy_o       (               ),
    .axi_req_i    ( c2s_req       ),
    .axi_resp_o   ( c2s_resp      ),
    .mem_req_o    ( mem_req       ),
    .mem_gnt_i    ( mem_gnt       ),
    .mem_addr_o   ( mem_addr      ),
    .mem_wdata_o  ( mem_wdata     ),
    .mem_strb_o   ( mem_strb      ),
    .mem_atop_o   ( mem_atop      ),
    .mem_we_o     ( mem_we        ),
    .mem_rvalid_i ( mem_rvalid    ),
    .mem_rdata_i  ( mem_rdata     )
  );

  assign mem_gnt[0] = 1'b1;

  // L2 Memory access and UART stdout handler
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mem_rvalid[0] <= 1'b0;
      mem_rdata[0]  <= 64'd0;
    end else begin
      mem_rvalid[0] <= mem_req[0];
      if (mem_req[0]) begin
        if (mem_we[0]) begin
          // Write operation
          if (mem_addr[0] >= L2BaseAddr && mem_addr[0] < (L2BaseAddr + L2SizeBytes)) begin
            automatic int word_idx = (mem_addr[0] - L2BaseAddr) >> 3;
            for (int b = 0; b < 8; b++) begin
              if (mem_strb[0][b]) begin
                l2_mem[word_idx][b*8 +: 8] <= mem_wdata[0][b*8 +: 8];
              end
            end
          end else if (mem_addr[0] >= MockUartBase && mem_addr[0] < MockUartEnd) begin
            // UART stdout write
            $write("%c", mem_wdata[0][7:0]);
            $fflush();
          end
        end else begin
          // Read operation
          if (mem_addr[0] >= L2BaseAddr && mem_addr[0] < (L2BaseAddr + L2SizeBytes)) begin
            automatic int word_idx = (mem_addr[0] - L2BaseAddr) >> 3;
            mem_rdata[0] <= l2_mem[word_idx];
          end else if (mem_addr[0] >= MockUartBase && mem_addr[0] < MockUartEnd) begin
            // Return UART line status: LSR bit 5 & 6 = 1 (TX holding empty / transmitter empty)
            mem_rdata[0] <= 64'h0000_0060;
          end else begin
            mem_rdata[0] <= 64'd0;
          end
        end
      end
    end
  end

  //----------------------------------------------------------------------------
  // Host AXI Tasks for Cluster Configuration and Boot
  //----------------------------------------------------------------------------
  task automatic s2c_write32(input logic [31:0] addr, input logic [31:0] data);
    s2c_req.aw.addr   = addr;
    s2c_req.aw.size   = 3'd3; // 8 bytes (64-bit bus)
    s2c_req.aw.len    = 8'd0; // 1 beat
    s2c_req.aw.burst  = 2'b01; // INCR
    s2c_req.aw.id     = '0;
    s2c_req.aw.user   = '0;
    s2c_req.aw.lock   = '0;
    s2c_req.aw.cache  = '0;
    s2c_req.aw.prot   = '0;
    s2c_req.aw.qos    = '0;
    s2c_req.aw.region = '0;
    s2c_req.aw_valid  = 1'b1;

    s2c_req.w.data    = {data, data};
    s2c_req.w.strb    = 8'hFF;
    s2c_req.w.last    = 1'b1;
    s2c_req.w.user    = '0;
    s2c_req.w_valid   = 1'b1;
    s2c_req.b_ready   = 1'b1;

    while (!(s2c_resp.aw_ready && s2c_resp.w_ready)) begin
      @(posedge clk);
    end
    @(posedge clk);
    s2c_req.aw_valid = 1'b0;
    s2c_req.w_valid  = 1'b0;

    while (!s2c_resp.b_valid) begin
      @(posedge clk);
    end
    @(posedge clk);
  endtask

  task automatic s2c_read32(input logic [31:0] addr, output logic [31:0] data);
    s2c_req.ar.addr   = addr;
    s2c_req.ar.size   = 3'd3; // 8 bytes
    s2c_req.ar.len    = 8'd0; // 1 beat
    s2c_req.ar.burst  = 2'b01; // INCR
    s2c_req.ar.id     = '0;
    s2c_req.ar.user   = '0;
    s2c_req.ar.lock   = '0;
    s2c_req.ar.cache  = '0;
    s2c_req.ar.prot   = '0;
    s2c_req.ar.qos    = '0;
    s2c_req.ar.region = '0;
    s2c_req.ar_valid  = 1'b1;
    s2c_req.r_ready   = 1'b1;

    while (!s2c_resp.ar_ready) begin
      @(posedge clk);
    end
    @(posedge clk);
    s2c_req.ar_valid = 1'b0;

    while (!s2c_resp.r_valid) begin
      @(posedge clk);
    end
    if (addr[2]) begin
      data = s2c_resp.r.data[63:32];
    end else begin
      data = s2c_resp.r.data[31:0];
    end
    @(posedge clk);
  endtask

  //----------------------------------------------------------------------------
  // Hex Binary Loader
  //----------------------------------------------------------------------------
  task automatic load_hex(input string filename);
    int file;
    int status;
    string line;
    logic [31:0] addr;
    logic [31:0] data;
    logic [7:0]  byte_data;
    int byte_count;
    int words_loaded;

    file = $fopen(filename, "r");
    if (file == 0) begin
      $fatal(1, "[PULP CLUSTER TB] Error: Failed to open hex file %s", filename);
    end
    $display("[PULP CLUSTER TB] Loading hex binary from %s...", filename);

    addr = L2BaseAddr;
    words_loaded = 0;
    while (!$feof(file)) begin
      if ($fgets(line, file) == 0) break;
      if (line.len() == 0) continue;

      if (line[0] == "@") begin
        status = $sscanf(line, "@%h", addr);
        continue;
      end

      byte_count = 0;
      data = 32'h0;
      while (line.len() > 0) begin
        status = $sscanf(line, "%h", byte_data);
        if (status != 1) break;

        data = {byte_data, data[31:8]};
        byte_count++;

        if (line.len() >= 3)
          line = line.substr(3, line.len()-1);
        else
          line = "";

        if (byte_count == 4) begin
          if (addr >= L2BaseAddr && addr < (L2BaseAddr + L2SizeBytes)) begin
            automatic int word_idx = (addr - L2BaseAddr) >> 3;
            if (addr[2]) begin
              l2_mem[word_idx][63:32] = data;
            end else begin
              l2_mem[word_idx][31:0]  = data;
            end
          end
          addr += 4;
          data = 32'h0;
          byte_count = 0;
          words_loaded++;
        end
      end
      if (byte_count > 0) begin
        if (addr >= L2BaseAddr && addr < (L2BaseAddr + L2SizeBytes)) begin
          automatic int word_idx = (addr - L2BaseAddr) >> 3;
          if (addr[2]) begin
            l2_mem[word_idx][63:32] = data;
          end else begin
            l2_mem[word_idx][31:0]  = data;
          end
        end
        addr += 4;
        words_loaded++;
      end
    end
    $fclose(file);
    $display("[PULP CLUSTER TB] Loaded %0d 32-bit words into L2 memory successfully.", words_loaded);
  endtask

  //----------------------------------------------------------------------------
  // Main Boot Orchestration Flow
  //----------------------------------------------------------------------------
  string binary_hex;
  longint unsigned max_cycles;
  logic [31:0] return_code;

  initial begin
    s2c_req = '0;
    s2c_req.b_ready = 1'b1;
    s2c_req.r_ready = 1'b1;
    s_cluster_en_sa_boot = 1'b0;
    s_cluster_fetch_en   = 1'b0;
    rst_n = 1'b0;

    // Initialize L2 memory
    for (int i = 0; i < L2Words64; i++) begin
      l2_mem[i] = 64'h0;
    end

    if (!$value$plusargs("hex=%s", binary_hex)) begin
      if (!$value$plusargs("binary=%s", binary_hex)) begin
        binary_hex = "";
      end
    end

    if (!$value$plusargs("max_cycles=%d", max_cycles)) begin
      max_cycles = 64'd100_000_000; // Default 100M cycles limit
    end

    // Reset pulse
    repeat (30) @(posedge clk);
    rst_n = 1'b1;
    repeat (20) @(posedge clk);

    if (binary_hex != "") begin
      load_hex(binary_hex);
    end else begin
      $display("[PULP CLUSTER TB] WARNING: No +hex= or +binary= argument given.");
    end

    // Release all 8 cores to fetch from default BOOT_ADDR (0x1C00_0000)
    @(negedge clk);
    s_cluster_fetch_en = 1'b1;

    $display("[PULP CLUSTER TB] Cluster cores released! Execution started at cycle %0d.", cycle_cnt);
  end

  //----------------------------------------------------------------------------
  // EOC and Timeout Watchdog Monitor
  //----------------------------------------------------------------------------
  always_ff @(posedge clk) begin
    if (rst_n && s_cluster_fetch_en) begin
      // Check for End of Computation
      if (s_cluster_eoc) begin
        return_code = i_dut.cluster_peripherals_i.cluster_control_unit_i.ret_val_q;
        $display("\n==================================================");
        $display("[PULP CLUSTER] End of Computation (EOC) detected!");
        $display("[PULP CLUSTER] Return code:       %0d", return_code[30:0]);
        $display("[PULP CLUSTER] Total cycles:      %0d", cycle_cnt);
        $display("[PULP CLUSTER] Instructions ret:  %0d", total_instr_ret);
        $display("==================================================");

        if (return_code[30:0] == 0) begin
          $display("SUCCESS: Test completed with code 0");
          $finish;
        end else begin
          $display("ERROR: Test failed with return code %0d", return_code[30:0]);
          $fatal(1, "Test failed with non-zero exit code");
        end
      end

      // Timeout watchdog
      if (cycle_cnt >= max_cycles) begin
        $display("\n[PULP CLUSTER] FATAL: Simulation timed out after %0d cycles!", cycle_cnt);
        $fatal(1, "Simulation timeout");
      end
    end
  end

endmodule
