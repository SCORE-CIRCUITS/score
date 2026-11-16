// Copyright 2026 SCORE Project.
// Standalone Verilator Testbench for Chimera Multi-Cluster Heterogeneous SoC.
// Replaces commercial QuestaSim VIP collar with native cycle-accurate simulation.

`timescale 1ns/1ps

module tb_chimera_verilator;
  import cheshire_pkg::*;
  import chimera_pkg::*;
  import chimera_reg_pkg::*;

  //----------------------------------------------------------------------------
  // Clock and Reset Signals
  //----------------------------------------------------------------------------
  logic soc_clk;
  logic clu_clk;
  logic rst_n;
  logic rtc;

  // 100 MHz SoC Clock (Period 10ns)
  initial begin
    soc_clk = 1'b0;
    forever #5.0 soc_clk = ~soc_clk;
  end

  // 100 MHz Cluster Clock (Synchronous)
  initial begin
    clu_clk = 1'b0;
    forever #5.0 clu_clk = ~clu_clk;
  end

  // RTC Clock (~32.768 kHz, toggled every 15258ns or divided from soc_clk)
  logic [11:0] rtc_cnt;
  always_ff @(posedge soc_clk or negedge rst_n) begin
    if (!rst_n) begin
      rtc_cnt <= '0;
      rtc     <= 1'b0;
    end else begin
      rtc_cnt <= rtc_cnt + 1'b1;
      if (rtc_cnt == 12'd1525) begin
        rtc_cnt <= '0;
        rtc     <= ~rtc;
      end
    end
  end

  //----------------------------------------------------------------------------
  // DUT IO Signals
  //----------------------------------------------------------------------------
  logic [1:0]  boot_mode;
  logic        test_mode;
  logic        uart_tx;
  logic        uart_rx;
  logic [31:0] gpio_in;
  logic [31:0] gpio_out;
  logic [31:0] gpio_en;

  apb_req_t  apb_req;
  apb_resp_t apb_rsp;

  assign test_mode = 1'b0;
  assign boot_mode = 2'b00; // Passive / Idle Boot
  assign uart_rx   = 1'b1;
  assign gpio_in   = 32'h0;
  assign apb_rsp   = '0;

  // PMU Signals
  logic [ExtClusters-1:0] pmu_rst_clusters_n;
  logic [ExtClusters-1:0] pmu_clkgate_en_clusters;
  logic [ExtClusters-1:0] pmu_iso_en_clusters;
  logic [ExtClusters-1:0] pmu_iso_ack_clusters;

  assign pmu_rst_clusters_n        = {ExtClusters{rst_n}};
  assign pmu_clkgate_en_clusters   = '0;
  assign pmu_iso_en_clusters       = '0;

  // Hyperbus Signals
  logic [HypNumPhys-1:0][HypNumChips-1:0] hyper_cs_no;
  logic [HypNumPhys-1:0]                  hyper_ck_o;
  logic [HypNumPhys-1:0]                  hyper_ck_no;
  logic [HypNumPhys-1:0]                  hyper_rwds_o;
  logic [HypNumPhys-1:0]                  hyper_rwds_i;
  logic [HypNumPhys-1:0]                  hyper_rwds_oe_o;
  logic [HypNumPhys-1:0][            7:0] hyper_dq_i;
  logic [HypNumPhys-1:0][            7:0] hyper_dq_o;
  logic [HypNumPhys-1:0]                  hyper_dq_oe_o;
  logic [HypNumPhys-1:0]                  hyper_reset_no;

  assign hyper_rwds_i = '0;
  assign hyper_dq_i   = '0;

  // SPI Host Signals
  logic                 spih_sck_o;
  logic                 spih_sck_en_o;
  logic [SpihNumCs-1:0] spih_csb_o;
  logic [SpihNumCs-1:0] spih_csb_en_o;
  logic [          3:0] spih_sd_o;
  logic [          3:0] spih_sd_en_o;
  logic [          3:0] spih_sd_i;

  assign spih_sd_i = 4'h0;

  // I2C Signals
  logic i2c_sda_o, i2c_sda_i, i2c_sda_en_o;
  logic i2c_scl_o, i2c_scl_i, i2c_scl_en_o;

  assign i2c_sda_i = 1'b1;
  assign i2c_scl_i = 1'b1;

  //----------------------------------------------------------------------------
  // Chimera Top Wrapper DUT Instantiation
  //----------------------------------------------------------------------------
  chimera_top_wrapper #(
    .SelectedCfg(0)
  ) i_dut (
    .soc_clk_i                 ( soc_clk                 ),
    .clu_clk_i                 ( clu_clk                 ),
    .rst_ni                    ( rst_n                   ),
    .test_mode_i               ( test_mode               ),
    .boot_mode_i               ( boot_mode               ),
    .rtc_i                     ( rtc                     ),
    // JTAG
    .jtag_tck_i                ( 1'b0                    ),
    .jtag_trst_ni              ( 1'b0                    ),
    .jtag_tms_i                ( 1'b0                    ),
    .jtag_tdi_i                ( 1'b0                    ),
    .jtag_tdo_o                (                         ),
    .jtag_tdo_oe_o             (                         ),
    // UART
    .uart_tx_o                 ( uart_tx                 ),
    .uart_rx_i                 ( uart_rx                 ),
    .uart_rts_no               (                         ),
    .uart_dtr_no               (                         ),
    .uart_cts_ni               ( 1'b0                    ),
    .uart_dsr_ni               ( 1'b0                    ),
    .uart_dcd_ni               ( 1'b0                    ),
    .uart_rin_ni               ( 1'b0                    ),
    // I2C
    .i2c_sda_o                 ( i2c_sda_o               ),
    .i2c_sda_i                 ( i2c_sda_i               ),
    .i2c_sda_en_o              ( i2c_sda_en_o            ),
    .i2c_scl_o                 ( i2c_scl_o               ),
    .i2c_scl_i                 ( i2c_scl_i               ),
    .i2c_scl_en_o              ( i2c_scl_en_o            ),
    // SPI Host
    .spih_sck_o                ( spih_sck_o              ),
    .spih_sck_en_o             ( spih_sck_en_o           ),
    .spih_csb_o                ( spih_csb_o              ),
    .spih_csb_en_o             ( spih_csb_en_o           ),
    .spih_sd_o                 ( spih_sd_o               ),
    .spih_sd_en_o              ( spih_sd_en_o            ),
    .spih_sd_i                 ( spih_sd_i               ),
    // GPIO
    .gpio_i                    ( gpio_in                 ),
    .gpio_o                    ( gpio_out                ),
    .gpio_en_o                 ( gpio_en                 ),
    // Hyperbus
    .hyper_cs_no               ( hyper_cs_no             ),
    .hyper_ck_o                ( hyper_ck_o              ),
    .hyper_ck_no               ( hyper_ck_no             ),
    .hyper_rwds_o              ( hyper_rwds_o            ),
    .hyper_rwds_i              ( hyper_rwds_i            ),
    .hyper_rwds_oe_o           ( hyper_rwds_oe_o         ),
    .hyper_dq_i                ( hyper_dq_i              ),
    .hyper_dq_o                ( hyper_dq_o              ),
    .hyper_dq_oe_o             ( hyper_dq_oe_o           ),
    .hyper_reset_no            ( hyper_reset_no          ),
    // APB
    .apb_rsp_i                 ( apb_rsp                 ),
    .apb_req_o                 ( apb_req                 ),
    // PMU
    .pmu_rst_clusters_ni       ( pmu_rst_clusters_n       ),
    .pmu_clkgate_en_clusters_i ( pmu_clkgate_en_clusters ),
    .pmu_iso_en_clusters_i     ( pmu_iso_en_clusters     ),
    .pmu_iso_ack_clusters_o    ( pmu_iso_ack_clusters    )
  );

  //----------------------------------------------------------------------------
  // Performance Counters
  //----------------------------------------------------------------------------
  longint unsigned cycle_cnt;
  longint unsigned retired_inst_cnt;

  always_ff @(posedge soc_clk or negedge rst_n) begin
    if (!rst_n) begin
      cycle_cnt        <= 64'd0;
      retired_inst_cnt <= 64'd0;
    end else begin
      cycle_cnt <= cycle_cnt + 64'd1;
      if (i_dut.i_cheshire.gen_cva6_cores[0].i_core_cva6.commit_ack[0]) begin
        retired_inst_cnt <= retired_inst_cnt + 64'd1;
        if (retired_inst_cnt < 35 || (cycle_cnt > 10000 && cycle_cnt < 10200)) begin
          $display("[CVA6] cycle=%0d retired=%0d pc=%h ex=%b",
                   cycle_cnt, retired_inst_cnt,
                   i_dut.i_cheshire.gen_cva6_cores[0].i_core_cva6.commit_instr_id_commit[0].pc,
                   i_dut.i_cheshire.gen_cva6_cores[0].i_core_cva6.commit_instr_id_commit[0].ex.valid);
        end
      end
    end
  end

  //----------------------------------------------------------------------------
  // UART Output Monitor (Console Output)
  //----------------------------------------------------------------------------
  always_ff @(posedge soc_clk) begin
    if (rst_n) begin
      // When software writes to OpenTitan/Cheshire UART TX data register
      if (i_dut.i_cheshire.gen_uart.i_uart.reg_req_i.valid &&
          i_dut.i_cheshire.gen_uart.i_uart.reg_req_i.write &&
          (i_dut.i_cheshire.gen_uart.i_uart.reg_req_i.addr[4:2] == 3'b000)) begin
        $write("%c", i_dut.i_cheshire.gen_uart.i_uart.reg_req_i.wdata[7:0]);
        $fflush();
      end
    end
  end

  //----------------------------------------------------------------------------
  // Memory Island Word Writer (Interleaved 8 Banks)
  //----------------------------------------------------------------------------
  task automatic write_memisl_word(input logic [31:0] addr, input logic [31:0] data);
    automatic logic [31:0] offset = addr - 32'h4800_0000;
    automatic logic bank_i        = offset[4];         // bit 4: WideBankSel
    automatic logic [1:0] bank_j  = offset[3:2];       // bits 3:2: SubBankSel
    automatic int word_idx        = (offset >> 5) & 1023; // bits 14:5: InBankAddr

    case ({bank_i, bank_j})
      3'b000: i_dut.i_memisland_domain.i_memory_island.i_memory_island.gen_wide_banks[0].gen_narrow_banks[0].i_bank.sram[word_idx] = data;
      3'b001: i_dut.i_memisland_domain.i_memory_island.i_memory_island.gen_wide_banks[0].gen_narrow_banks[1].i_bank.sram[word_idx] = data;
      3'b010: i_dut.i_memisland_domain.i_memory_island.i_memory_island.gen_wide_banks[0].gen_narrow_banks[2].i_bank.sram[word_idx] = data;
      3'b011: i_dut.i_memisland_domain.i_memory_island.i_memory_island.gen_wide_banks[0].gen_narrow_banks[3].i_bank.sram[word_idx] = data;
      3'b100: i_dut.i_memisland_domain.i_memory_island.i_memory_island.gen_wide_banks[1].gen_narrow_banks[0].i_bank.sram[word_idx] = data;
      3'b101: i_dut.i_memisland_domain.i_memory_island.i_memory_island.gen_wide_banks[1].gen_narrow_banks[1].i_bank.sram[word_idx] = data;
      3'b110: i_dut.i_memisland_domain.i_memory_island.i_memory_island.gen_wide_banks[1].gen_narrow_banks[2].i_bank.sram[word_idx] = data;
      3'b111: i_dut.i_memisland_domain.i_memory_island.i_memory_island.gen_wide_banks[1].gen_narrow_banks[3].i_bank.sram[word_idx] = data;
    endcase
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
      $fatal(1, "[CHIMERA TB] Error: Failed to open hex file %s", filename);
    end
    $display("[CHIMERA TB] Loading hex binary from %s...", filename);

    addr = 32'h4800_0000;
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
          if (addr >= 32'h4800_0000 && addr < 32'h4800_8000) begin
            write_memisl_word(addr, data);
            words_loaded++;
          end
          addr += 4;
          data = 32'h0;
          byte_count = 0;
        end
      end
      if (byte_count > 0) begin
        if (addr >= 32'h4800_0000 && addr < 32'h4800_8000) begin
          write_memisl_word(addr, data);
          words_loaded++;
        end
        addr += 4;
      end
    end
    $fclose(file);
    $display("[CHIMERA TB] Loaded %0d 32-bit words into Memory Island successfully.", words_loaded);
  endtask

  //----------------------------------------------------------------------------
  // Boot Orchestration & Execution Loop
  //----------------------------------------------------------------------------
  string binary_hex;
  longint unsigned max_cycles;
  logic [31:0] return_code;

  initial begin
    rst_n = 1'b0;

    if (!$value$plusargs("hex=%s", binary_hex)) begin
      if (!$value$plusargs("binary=%s", binary_hex)) begin
        binary_hex = "";
      end
    end

    if (!$value$plusargs("max_cycles=%d", max_cycles)) begin
      max_cycles = 64'd50_000_000; // Default 50M cycles limit
    end

    // Hold reset for 30 cycles
    repeat (30) @(posedge soc_clk);

    if (binary_hex != "") begin
      load_hex(binary_hex);
    end else begin
      $display("[CHIMERA TB] WARNING: No +hex= or +binary= argument given.");
    end

    // Release reset
    @(negedge soc_clk);
    rst_n = 1'b1;

    $display("[CHIMERA TB] Reset released! Host CVA6 booting directly from Memory Island (0x4800_0000)...");
  end

  //----------------------------------------------------------------------------
  // EOC (End of Computation) Monitor & Heartbeat
  //----------------------------------------------------------------------------
  always_ff @(posedge soc_clk) begin
    if (rst_n) begin
      if (cycle_cnt > 0 && (cycle_cnt % 5000 == 0)) begin
        $display("[CHIMERA TB] Heartbeat: cycle=%0d, retired=%0d", cycle_cnt, retired_inst_cnt);
      end

      // When software completes in _exit, it writes (return_code << 1) | 1 to SCRATCH[2]
      if (cycle_cnt > 50 && i_dut.i_cheshire.i_regs.u_scratch_2.q[0] == 1'b1) begin
        return_code = i_dut.i_cheshire.i_regs.u_scratch_2.q >> 1;
        $display("\n==================================================");
        $display("[CHIMERA] End of Computation (EOC) detected!");
        $display("[CHIMERA] Return code:       %0d", return_code);
        $display("[CHIMERA] Total cycles:      %0d", cycle_cnt);
        $display("[CHIMERA] Instructions ret:  %0d", retired_inst_cnt);
        $display("==================================================");
        if (return_code == 0) begin
          $display("SUCCESS: Test completed with code 0");
        end else begin
          $display("FAILURE: Test failed with return code %0d", return_code);
        end
        $finish;
      end

      // Simulation Timeout Check
      if (cycle_cnt >= max_cycles) begin
        $display("\n[CHIMERA TB] ERROR: Simulation exceeded %0d cycles limit! Timeout.", max_cycles);
        $finish;
      end
    end
  end

endmodule
