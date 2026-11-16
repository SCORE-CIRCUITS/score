// Copyright (c) 2024 ETH Zurich and University of Bologna.
// SPDX-License-Identifier: Apache-2.0
//
// Native Verilator Testbench for MAGIA Standalone Tile & RedMulE GeMM

`timescale 1ns/1ps

module tb_magia_verilator;

  import magia_tile_pkg::*;
  import magia_pkg::*;
  import magia_tile_tb_pkg::*;
  import floo_axi_nw_mesh_1x2_noc_pkg::*;
  import floo_pkg::*;

  // Clock & Reset
  logic clk;
  logic rst_n;
  logic test_mode;

  // NoC Links
  floo_req_t  noc_south_req_i, noc_south_req_o;
  floo_rsp_t  noc_south_rsp_o, noc_south_rsp_i;
  floo_wide_t noc_south_wide_i, noc_south_wide_o;

  floo_req_t  noc_east_req_i, noc_east_req_o;
  floo_rsp_t  noc_east_rsp_o, noc_east_rsp_i;
  floo_wide_t noc_east_wide_i, noc_east_wide_o;

  floo_req_t  noc_north_req_i, noc_north_req_o;
  floo_rsp_t  noc_north_rsp_o, noc_north_rsp_i;
  floo_wide_t noc_north_wide_i, noc_north_wide_o;

  floo_req_t  noc_west_req_i, noc_west_req_o;
  floo_rsp_t  noc_west_rsp_o, noc_west_rsp_i;
  floo_wide_t noc_west_wide_i, noc_west_wide_o;

  // FractalSync Interfaces
  fractal_sync_if ht_fsync_if[1]();
  fractal_sync_if hn_fsync_if[1]();
  fractal_sync_if vt_fsync_if[1]();
  fractal_sync_if vn_fsync_if[1]();

  // Control and Debug
  logic [31:0] boot_addr;
  logic [31:0] mtvec_addr;
  logic [31:0] dm_halt_addr;
  logic [31:0] dm_exception_addr;
  logic [31:0] mhartid;
  logic [ 3:0] mimpid_patch;
  logic [63:0] mcycle;
  logic [63:0] time_var;
  logic [magia_pkg::N_IRQ-1:0] irq;
  logic        fetch_enable;
  logic        core_sleep;
  logic        wu_wfe;
  logic        debug_req;
  logic        debug_havereset;
  logic        debug_running;
  logic        debug_halted;
  logic        debug_pc_valid;
  logic [31:0] debug_pc;

  // EOC and Exit
  logic        eoc;
  logic [31:0] exit_code;

  // Benchmarking counters
  longint unsigned cycle_cnt;
  longint unsigned total_instr_ret;
  longint unsigned max_cycles;
  string           image_path;

  // Hardwired signals
  assign noc_east_req_i  = '0;
  assign noc_east_rsp_i  = '0;
  assign noc_east_wide_i = '0;

  assign noc_north_req_i  = '0;
  assign noc_north_rsp_i  = '0;
  assign noc_north_wide_i = '0;

  assign noc_south_req_i  = '0;
  assign noc_south_rsp_i  = '0;
  assign noc_south_wide_i = '0;

  assign mtvec_addr        = 32'h0;
  assign dm_halt_addr      = 32'h0;
  assign dm_exception_addr = 32'h0;
  assign mhartid           = 32'h0;
  assign mimpid_patch      = 4'h0;
  assign debug_req         = 1'b0;
  assign wu_wfe            = 1'b0;
  assign irq               = '0;

  assign ht_fsync_if[0].wake   = 1'b0;
  assign ht_fsync_if[0].lvl    = '0;
  assign ht_fsync_if[0].id_rsp = '0;
  assign ht_fsync_if[0].error  = 1'b0;

  assign hn_fsync_if[0].wake   = 1'b0;
  assign hn_fsync_if[0].lvl    = '0;
  assign hn_fsync_if[0].id_rsp = '0;
  assign hn_fsync_if[0].error  = 1'b0;

  assign vt_fsync_if[0].wake   = 1'b0;
  assign vt_fsync_if[0].lvl    = '0;
  assign vt_fsync_if[0].id_rsp = '0;
  assign vt_fsync_if[0].error  = 1'b0;

  assign vn_fsync_if[0].wake   = 1'b0;
  assign vn_fsync_if[0].lvl    = '0;
  assign vn_fsync_if[0].id_rsp = '0;
  assign vn_fsync_if[0].error  = 1'b0;

  // Clock generation (200 MHz, 5ns period)
  initial begin
    clk = 1'b0;
    forever #2.5 clk = ~clk;
  end

  // DUT: MAGIA Compute Tile
  magia_tile #(
    .N_MEM_BANKS  ( magia_tile_tb_pkg::N_MEM_BANKS  ),
    .N_WORDS_BANK ( magia_tile_tb_pkg::N_WORDS_BANK )
  ) i_dut (
    .clk_i               ( clk               ),
    .rst_ni              ( rst_n             ),
    .test_mode_i         ( test_mode         ),
    .tile_enable_i       ( 1'b1              ),

    .noc_south_req_i     ( noc_south_req_i   ),
    .noc_south_rsp_o     ( noc_south_rsp_o   ),
    .noc_south_wide_i    ( noc_south_wide_i  ),
    .noc_south_req_o     ( noc_south_req_o   ),
    .noc_south_rsp_i     ( noc_south_rsp_i   ),
    .noc_south_wide_o    ( noc_south_wide_o  ),

    .noc_east_req_i      ( noc_east_req_i    ),
    .noc_east_rsp_o      ( noc_east_rsp_o    ),
    .noc_east_wide_i     ( noc_east_wide_i   ),
    .noc_east_req_o      ( noc_east_req_o    ),
    .noc_east_rsp_i      ( noc_east_rsp_i    ),
    .noc_east_wide_o     ( noc_east_wide_o   ),

    .noc_north_req_i     ( noc_north_req_i   ),
    .noc_north_rsp_o     ( noc_north_rsp_o   ),
    .noc_north_wide_i    ( noc_north_wide_i  ),
    .noc_north_req_o     ( noc_north_req_o   ),
    .noc_north_rsp_i     ( noc_north_rsp_i   ),
    .noc_north_wide_o    ( noc_north_wide_o  ),

    .noc_west_req_i      ( noc_west_req_i    ),
    .noc_west_rsp_o      ( noc_west_rsp_o    ),
    .noc_west_wide_i     ( noc_west_wide_i   ),
    .noc_west_req_o      ( noc_west_req_o    ),
    .noc_west_rsp_i      ( noc_west_rsp_i    ),
    .noc_west_wide_o     ( noc_west_wide_o   ),

    .x_id_i              ( 0                 ),
    .y_id_i              ( 0                 ),

    .ht_fsync_if_o       ( ht_fsync_if[0]    ),
    .hn_fsync_if_o       ( hn_fsync_if[0]    ),
    .vt_fsync_if_o       ( vt_fsync_if[0]    ),
    .vn_fsync_if_o       ( vn_fsync_if[0]    ),
    
    .scan_cg_en_i        ( 1'b0              ),

    .boot_addr_i         ( boot_addr         ),
    .mtvec_addr_i        ( mtvec_addr        ),
    .dm_halt_addr_i      ( dm_halt_addr      ),
    .dm_exception_addr_i ( dm_exception_addr ),
    .mhartid_i           ( mhartid           ),
    .mimpid_patch_i      ( mimpid_patch      ),

    .mcycle_o            ( mcycle            ),
    .time_i              ( time_var          ),

    .irq_i               ( irq               ),

    .debug_req_i         ( debug_req         ),
    .debug_havereset_o   ( debug_havereset   ),
    .debug_running_o     ( debug_running     ),
    .debug_halted_o      ( debug_halted      ),
    .debug_pc_valid_o    ( debug_pc_valid    ),
    .debug_pc_o          ( debug_pc          ),

    .fetch_enable_i      ( fetch_enable      ),
    .core_sleep_o        ( core_sleep        ),
    .wu_wfe_i            ( wu_wfe            )
  );

  // L2 Memory Wrapper (Synthesizable AXI memory responder)
  magia_l2_mem_wrapper #(
    .NumPorts ( 1 )
  ) i_l2_mem (
    .clk_i      ( clk               ),
    .rst_ni     ( rst_n             ),
    .noc_req_i  ( noc_west_req_o    ),
    .noc_rsp_o  ( noc_west_rsp_i    ),
    .noc_req_o  ( noc_west_req_i    ),
    .noc_rsp_i  ( noc_west_rsp_o    ),
    .noc_wide_i ( noc_west_wide_o   ),
    .noc_wide_o ( noc_west_wide_i   ),
    .eoc_o      ( eoc               ),
    .exit_code_o( exit_code         )
  );

  // Cycle & Instruction Retirement Counters
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cycle_cnt       <= '0;
      total_instr_ret <= '0;
      time_var        <= '0;
    end else begin
      cycle_cnt <= cycle_cnt + 1;
      time_var  <= time_var + 5; // 5ns per cycle
      if (i_dut.i_cv32e40p_core.cs_registers_i.id_valid_i & 
          i_dut.i_cv32e40p_core.cs_registers_i.is_decoding_i) begin
        total_instr_ret <= total_instr_ret + 1;
      end
    end
  end

  // Heartbeat & Timeout Monitor
  always_ff @(posedge clk) begin
    if (rst_n) begin
      if (cycle_cnt % 100000 == 0 && cycle_cnt > 0) begin
        $display("[TB] Heartbeat: Cycle %0d | Retired: %0d | PC: 0x%08x", 
                 cycle_cnt, total_instr_ret, i_dut.i_cv32e40p_core.id_stage_i.pc_id_i);
      end
      if (cycle_cnt > max_cycles) begin
        $fatal(1, "[TB] TIMEOUT: Exceeded max cycles (%0d) at PC 0x%08x", 
               max_cycles, i_dut.i_cv32e40p_core.id_stage_i.pc_id_i);
      end
    end
  end

  // Print Monitor (matching QuestaSim VIP)
  bit stdio_ready  = 0;
  bit stderr_ready = 0;
  always_ff @(posedge clk) begin
    if (rst_n) begin
      if ((i_dut.i_axi_xbar.mst_ports_req_o[0].aw.addr == 32'hFFFF0000) && (i_dut.i_axi_xbar.mst_ports_req_o[0].aw_valid)) stderr_ready <= 1'b1;
      if ((i_dut.i_axi_xbar.mst_ports_req_o[0].aw.addr == 32'hFFFF0004) && (i_dut.i_axi_xbar.mst_ports_req_o[0].aw_valid)) stdio_ready  <= 1'b1;
      if ((i_dut.i_axi_xbar.mst_ports_req_o[0].w_valid) && stderr_ready) begin
        if (i_dut.i_axi_xbar.mst_ports_req_o[0].w.data < 256 && i_dut.i_axi_xbar.mst_ports_req_o[0].w.data > 0) begin
          stderr_ready <= 1'b0;
        end
      end
      if ((i_dut.i_axi_xbar.mst_ports_req_o[0].w_valid) && stdio_ready) begin
        if (i_dut.i_axi_xbar.mst_ports_req_o[0].w.data < 256 && i_dut.i_axi_xbar.mst_ports_req_o[0].w.data > 0) begin
          $write("%c", i_dut.i_axi_xbar.mst_ports_req_o[0].w.data[7:0]);
          $fflush();
          stdio_ready <= 1'b0;
        end
      end
    end
  end

  // Main Test Sequence
  initial begin
    rst_n        = 1'b0;
    test_mode    = 1'b1;
    fetch_enable = 1'b0;
    boot_addr    = 32'hCC00_0080;
    max_cycles   = 5000000;

    if (!$value$plusargs("BOOT_ADDR=%h", boot_addr)) begin
      boot_addr = 32'hCC00_0080;
    end

    if (!$value$plusargs("MAX_CYCLES=%d", max_cycles)) begin
      max_cycles = 5000000;
    end

    if (!$value$plusargs("IMAGE=%s", image_path)) begin
      image_path = "";
    end

    $display("[TB] ============================================================");
    $display("[TB] Initializing MAGIA Verilator Simulation");
    $display("[TB] Preloading L2 Memory with: %s", image_path);
    $display("[TB] Max Simulation Cycles: %0d", max_cycles);
    $display("[TB] ============================================================");

    if (image_path != "") begin
      $readmemh(image_path, i_l2_mem.l2_mem);
    end

    // Hold reset for 30 cycles with test_mode active so clocks toggle during reset
    repeat (30) @(posedge clk);
    rst_n     = 1'b1;
    test_mode = 1'b0;
    $display("[TB] Reset released at cycle %0d", cycle_cnt);

    // Release fetch enable
    repeat (10) @(posedge clk);
    fetch_enable = 1'b1;
    $display("[TB] Fetch enabled at cycle %0d", cycle_cnt);

    // Wait for EOC
    wait (eoc == 1'b1);
    // Allow bus pipeline to settle
    repeat (20) @(posedge clk);

    $display("\n==============================================================");
    $display("MAGIA Simulation Finished");
    $display("Exit Code:              %0d", exit_code);
    $display("Total Cycles:           %0d", cycle_cnt);
    $display("Retired Instructions:   %0d", total_instr_ret);
    if (total_instr_ret > 0) begin
      $display("CPI:                    %0.2f", real'(cycle_cnt) / real'(total_instr_ret));
    end
    $display("==============================================================");

    if (exit_code == 0) begin
      $display("[TB] Test PASSED (Exit Code: 0)");
      $finish(0);
    end else begin
      $fatal(1, "[TB] Test FAILED (Exit Code: %0d)", exit_code);
    end
  end

endmodule
