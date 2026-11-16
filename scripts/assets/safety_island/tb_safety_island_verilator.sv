// Copyright 2026 SCORE Project.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Standalone Verilator Testbench for Safety Island SoC.
// Boots preloaded software binaries via AXI slave port without commercial EDA tools.

`include "axi/typedef.svh"

module tb_safety_island_verilator;
  import safety_island_pkg::*;

  localparam time ClkPeriodSys = 10ns; // 100 MHz
  localparam time ClkPeriodRtc = 30518ns; // 32.768 kHz RTC

  localparam int unsigned GlobalAddrWidth  = 32;
  localparam bit [GlobalAddrWidth-1:0] BaseAddr = 32'h0000_0000;
  localparam bit [31:0]   AddrRange        = 32'h0080_0000;
  localparam bit [31:0]   MemOffset        = 32'h0000_0000;
  localparam bit [31:0]   PeriphOffset     = 32'h0020_0000;

  localparam int unsigned AxiDataWidth     = 64;
  localparam int unsigned AxiAddrWidth     = GlobalAddrWidth;
  localparam int unsigned AxiInputIdWidth  = 6;
  localparam int unsigned AxiUserWidth     = 10;
  localparam int unsigned AxiOutputIdWidth = 2;

  `AXI_TYPEDEF_ALL(axi_input,
                   logic[AxiAddrWidth-1:0],
                   logic[AxiInputIdWidth-1:0],
                   logic[AxiDataWidth-1:0],
                   logic[AxiDataWidth/8-1:0],
                   logic[AxiUserWidth-1:0])
  `AXI_TYPEDEF_ALL(axi_output,
                   logic[AxiAddrWidth-1:0],
                   logic[AxiOutputIdWidth-1:0],
                   logic[AxiDataWidth-1:0],
                   logic[AxiDataWidth/8-1:0],
                   logic[AxiUserWidth-1:0])

  localparam bit [AxiAddrWidth-1:0] SocCtrlAddr = BaseAddr + PeriphOffset + SocCtrlAddrOffset;
  localparam bit [AxiAddrWidth-1:0] BootAddrAddr = SocCtrlAddr + safety_soc_ctrl_reg_pkg::SAFETY_SOC_CTRL_BOOTADDR_OFFSET;
  localparam bit [AxiAddrWidth-1:0] FetchEnAddr  = SocCtrlAddr + safety_soc_ctrl_reg_pkg::SAFETY_SOC_CTRL_FETCHEN_OFFSET;
  localparam bit [AxiAddrWidth-1:0] CoreStatusAddr = SocCtrlAddr + safety_soc_ctrl_reg_pkg::SAFETY_SOC_CTRL_CORESTATUS_OFFSET;

  logic clk;
  logic ref_clk;
  logic rst_n;
  logic fetch_en;
  logic [63:0] cycle_cnt;

  axi_input_req_t   from_ext_req;
  axi_input_resp_t  from_ext_resp;

  axi_output_req_t  to_ext_req;
  axi_output_resp_t to_ext_resp;

  // Clock generation
  initial begin
    clk = 0;
    forever #(ClkPeriodSys/2) clk = ~clk;
  end

  initial begin
    ref_clk = 0;
    forever #(ClkPeriodRtc/2) ref_clk = ~ref_clk;
  end

  // Cycle counter
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cycle_cnt <= 64'd0;
    end else begin
      cycle_cnt <= cycle_cnt + 64'd1;
    end
  end

  // Tie off external AXI master responses (DUT master -> outside)
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      to_ext_resp <= '0;
    end else begin
      to_ext_resp.aw_ready <= 1'b1;
      to_ext_resp.w_ready  <= 1'b1;
      to_ext_resp.ar_ready <= 1'b1;

      if (to_ext_req.aw_valid && to_ext_req.w_valid) begin
        to_ext_resp.b_valid <= 1'b1;
        to_ext_resp.b.id    <= to_ext_req.aw.id;
        to_ext_resp.b.resp  <= axi_pkg::RESP_OKAY;
        to_ext_resp.b.user  <= '0;
      end else if (to_ext_req.b_ready) begin
        to_ext_resp.b_valid <= 1'b0;
      end

      if (to_ext_req.ar_valid) begin
        to_ext_resp.r_valid <= 1'b1;
        to_ext_resp.r.id    <= to_ext_req.ar.id;
        to_ext_resp.r.data  <= 64'd0;
        to_ext_resp.r.resp  <= axi_pkg::RESP_OKAY;
        to_ext_resp.r.last  <= 1'b1;
        to_ext_resp.r.user  <= '0;
      end else if (to_ext_req.r_ready) begin
        to_ext_resp.r_valid <= 1'b0;
      end
    end
  end

  // DUT instantiation
  safety_island_top #(
    .GlobalAddrWidth  ( GlobalAddrWidth  ),
    .BaseAddr         ( BaseAddr         ),
    .AddrRange        ( AddrRange        ),
    .MemOffset        ( MemOffset        ),
    .PeriphOffset     ( PeriphOffset     ),
    .AxiDataWidth     ( AxiDataWidth     ),
    .AxiAddrWidth     ( AxiAddrWidth     ),
    .AxiInputIdWidth  ( AxiInputIdWidth  ),
    .AxiUserWidth     ( AxiUserWidth     ),
    .AxiOutputIdWidth ( AxiOutputIdWidth ),
    .axi_input_req_t  ( axi_input_req_t  ),
    .axi_input_resp_t ( axi_input_resp_t ),
    .axi_output_req_t ( axi_output_req_t ),
    .axi_output_resp_t( axi_output_resp_t)
  ) i_dut (
    .clk_i            ( clk           ),
    .ref_clk_i        ( ref_clk       ),
    .rst_ni           ( rst_n         ),
    .test_enable_i    ( 1'b0          ),
    .jtag_tck_i       ( 1'b0          ),
    .jtag_tdi_i       ( 1'b0          ),
    .jtag_tdo_o       (               ),
    .jtag_tms_i       ( 1'b0          ),
    .jtag_trst_ni     ( 1'b1          ),
    .bootmode_i       ( safety_island_pkg::Preloaded ),
    .fetch_enable_i   ( fetch_en      ),
    .irqs_i           ( '0            ),
    .debug_req_o      (               ),
    .axi_input_req_i  ( from_ext_req  ),
    .axi_input_resp_o ( from_ext_resp ),
    .axi_output_req_o ( to_ext_req    ),
    .axi_output_resp_i( to_ext_resp   )
  );

  // AXI single 32-bit write helper task
  task automatic axi_write32(input logic [31:0] addr, input logic [31:0] data);
    bit aw_done, w_done;
    aw_done = 0;
    w_done = 0;

    from_ext_req.aw.addr   = addr;
    from_ext_req.aw.size   = 3'd2; // 4 bytes
    from_ext_req.aw.len    = 8'd0; // 1 beat
    from_ext_req.aw.burst  = 2'b01; // INCR
    from_ext_req.aw.id     = '0;
    from_ext_req.aw.user   = '0;
    from_ext_req.aw.lock   = '0;
    from_ext_req.aw.cache  = '0;
    from_ext_req.aw.prot   = '0;
    from_ext_req.aw.qos    = '0;
    from_ext_req.aw.region = '0;
    from_ext_req.aw_valid  = 1'b1;

    if (addr[2]) begin
      from_ext_req.w.data = {data, 32'h0};
      from_ext_req.w.strb = 8'hF0;
    end else begin
      from_ext_req.w.data = {32'h0, data};
      from_ext_req.w.strb = 8'h0F;
    end
    from_ext_req.w.last    = 1'b1;
    from_ext_req.w.user    = '0;
    from_ext_req.w_valid   = 1'b1;
    from_ext_req.b_ready   = 1'b1;

    while (!aw_done || !w_done) begin
      @(posedge clk);
      if (from_ext_req.aw_valid && from_ext_resp.aw_ready) begin
        from_ext_req.aw_valid = 1'b0;
        aw_done = 1'b1;
      end
      if (from_ext_req.w_valid && from_ext_resp.w_ready) begin
        from_ext_req.w_valid = 1'b0;
        w_done = 1'b1;
      end
    end

    while (!from_ext_resp.b_valid) begin
      @(posedge clk);
    end
    @(posedge clk);
  endtask

  // Hex file loader task
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
      $fatal(1, "[SAFETY ISLAND TB] Error: Failed to open file %s", filename);
    end
    $display("[SAFETY ISLAND TB] Loading hex binary from %s...", filename);

    addr = 32'h0;
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
          axi_write32(addr, data);
          addr += 4;
          data = 32'h0;
          byte_count = 0;
          words_loaded++;
        end
      end
      if (byte_count > 0) begin
        axi_write32(addr, data);
        addr += 4;
        words_loaded++;
      end
    end
    $fclose(file);
    $display("[SAFETY ISLAND TB] Loaded %0d 32-bit words successfully.", words_loaded);
  endtask

  // Testbench Main Flow
  string binary_hex;
  longint unsigned max_cycles;

  initial begin
    from_ext_req = '0;
    from_ext_req.b_ready = 1'b1;
    from_ext_req.r_ready = 1'b1;
    fetch_en = 1'b0;
    rst_n = 1'b0;

    if (!$value$plusargs("hex=%s", binary_hex)) begin
      if (!$value$plusargs("binary=%s", binary_hex)) begin
        binary_hex = "";
      end
    end

    if (!$value$plusargs("max_cycles=%d", max_cycles)) begin
      max_cycles = 64'd100_000_000; // Default 100M cycles limit
    end

    // Reset pulse
    repeat (20) @(posedge clk);
    rst_n = 1'b1;
    repeat (10) @(posedge clk);

    if (binary_hex != "") begin
      load_hex(binary_hex);
    end else begin
      $display("[SAFETY ISLAND TB] WARNING: No +hex= or +binary= argument given.");
    end

    // Set Boot Address to 0x0000_0000 (SRAM origin)
    $display("[SAFETY ISLAND TB] Writing Boot Address 0x0000_0000 to SocCtrl...");
    axi_write32(BootAddrAddr, 32'h0000_0000);

    // Set Fetch Enable
    $display("[SAFETY ISLAND TB] Writing Fetch Enable to SocCtrl...");
    axi_write32(FetchEnAddr, 32'h0000_0001);
    fetch_en = 1'b1;

    $display("[SAFETY ISLAND TB] Core released! Execution started at cycle %0d.", cycle_cnt);
  end


  // Core Status / EOC Monitor
  always_ff @(posedge clk) begin
    if (rst_n && fetch_en) begin
      // Monitor CoreStatus register: bit 31 indicates completion
      if (i_dut.i_soc_ctrl.reg2hw.corestatus.q[31]) begin
        $display("\n==================================================");
        $display("[SAFETY ISLAND] End of Computation (EOC) detected!");
        $display("[SAFETY ISLAND] Core Status: 0x%08x", i_dut.i_soc_ctrl.reg2hw.corestatus.q);
        $display("[SAFETY ISLAND] Exit code:   %0d", i_dut.i_soc_ctrl.reg2hw.corestatus.q[30:0]);
        $display("[SAFETY ISLAND] Total cycles: %0d", cycle_cnt);
        $display("==================================================");
        if (i_dut.i_soc_ctrl.reg2hw.corestatus.q[30:0] == 0) begin
          $display("SUCCESS: Test completed with code 0");
          $finish;
        end else begin
          $display("ERROR: Test failed with return code %0d", i_dut.i_soc_ctrl.reg2hw.corestatus.q[30:0]);
          $fatal(1, "Test failed with non-zero exit code");
        end
      end

      // Timeout watchdog
      if (cycle_cnt >= max_cycles) begin
        $display("\n[SAFETY ISLAND] FATAL: Simulation timed out after %0d cycles!", cycle_cnt);
        $fatal(1, "Simulation timeout");
      end
    end
  end

endmodule
