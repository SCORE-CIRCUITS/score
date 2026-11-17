// Copyright 2026 SCORE Project.
// Simulation Testbench Wrapper for RoaLogic RV12 (RV32IM AHB3-Lite)

`timescale 1ns/1ps

import riscv_state_pkg::*;
import riscv_pma_pkg::*;
import riscv_du_pkg::*;
import biu_constants_pkg::*;
import ahb3lite_pkg::*;

module tb_rv12_top #(
  parameter int PMA_CNT        = 4,
  parameter int MXLEN          = 32,
  parameter int ALEN           = 32,
  parameter [31:0] TOHOST_ADDR = 32'h8010_0008,
  parameter [31:0] UART_ADDR   = 32'h8010_0000,
  parameter [31:0] RAM_BASE    = 32'h8000_0000
) (
  input  logic        HCLK,
  input  logic        HRESETn,

  output logic        uart_valid_o,
  output logic [7:0]  uart_char_o,

  output logic        tohost_valid_o,
  output logic [31:0] tohost_val_o,

  output logic        inst_retired_o,
  output logic [31:0] inst_pc_o
);

  // PMA configuration
  pmacfg_t          pma_cfg [PMA_CNT];
  logic [ALEN -1:0] pma_adr [PMA_CNT];

  // Region 0: 1MB RAM (0x8000_0000 - 0x800F_FFFF)
  assign pma_adr[0]          = (32'h8000_0000 | (32'h000F_FFFF >> 1)) >> 2;
  assign pma_cfg[0].mem_type = MEM_TYPE_MAIN;
  assign pma_cfg[0].r        = 1'b1;
  assign pma_cfg[0].w        = 1'b1;
  assign pma_cfg[0].x        = 1'b1;
  assign pma_cfg[0].c        = 1'b1;
  assign pma_cfg[0].cc       = 1'b0;
  assign pma_cfg[0].ri       = 1'b0;
  assign pma_cfg[0].wi       = 1'b0;
  assign pma_cfg[0].m        = 1'b0;
  assign pma_cfg[0].amo_type = AMO_TYPE_NONE;
  assign pma_cfg[0].a        = NAPOT;

  // Region 1: 4KB MMIO (0x8010_0000 - 0x8010_0FFF)
  assign pma_adr[1]          = (32'h8010_0000 | (32'h0000_0FFF >> 1)) >> 2;
  assign pma_cfg[1].mem_type = MEM_TYPE_IO;
  assign pma_cfg[1].r        = 1'b1;
  assign pma_cfg[1].w        = 1'b1;
  assign pma_cfg[1].x        = 1'b0;
  assign pma_cfg[1].c        = 1'b0;
  assign pma_cfg[1].cc       = 1'b0;
  assign pma_cfg[1].ri       = 1'b0;
  assign pma_cfg[1].wi       = 1'b0;
  assign pma_cfg[1].m        = 1'b0;
  assign pma_cfg[1].amo_type = AMO_TYPE_NONE;
  assign pma_cfg[1].a        = NAPOT;

  // Region 2 & 3: unused
  assign pma_adr[2]          = 32'h0;
  assign pma_cfg[2]          = '0;
  assign pma_adr[3]          = 32'h0;
  assign pma_cfg[3]          = '0;

  // AHB signals
  logic        ins_HSEL;
  logic [31:0] ins_HADDR;
  logic [31:0] ins_HWDATA;
  logic [31:0] ins_HRDATA;
  logic        ins_HWRITE;
  logic [2:0]  ins_HSIZE;
  logic [2:0]  ins_HBURST;
  logic [3:0]  ins_HPROT;
  logic [1:0]  ins_HTRANS;
  logic        ins_HMASTLOCK;
  logic        ins_HREADY;
  logic        ins_HRESP;

  logic        dat_HSEL;
  logic [31:0] dat_HADDR;
  logic [31:0] dat_HWDATA;
  logic [31:0] dat_HRDATA;
  logic        dat_HWRITE;
  logic [2:0]  dat_HSIZE;
  logic [2:0]  dat_HBURST;
  logic [3:0]  dat_HPROT;
  logic [1:0]  dat_HTRANS;
  logic        dat_HMASTLOCK;
  logic        dat_HREADY;
  logic        dat_HRESP;

  // Instantiate RoaLogic RV12
  riscv_top_ahb3lite #(
    .MXLEN            ( 32              ),
    .ALEN             ( 32              ),
    .PC_INIT          ( 32'h8000_0000   ),
    .HAS_USER         ( 1               ),
    .HAS_SUPER        ( 1               ),
    .HAS_HYPER        ( 0               ),
    .HAS_BPU          ( 1               ),
    .HAS_FPU          ( 0               ),
    .HAS_MMU          ( 0               ),
    .HAS_RVM          ( 1               ),
    .HAS_RVA          ( 0               ),
    .HAS_RVC          ( 0               ),
    .IS_RV32E         ( 0               ),
    .MULT_LATENCY     ( 0               ),
    .BREAKPOINTS      ( 3               ),
    .PMA_CNT          ( PMA_CNT         ),
    .PMP_CNT          ( 0               ),
    .BP_GLOBAL_BITS   ( 2               ),
    .BP_LOCAL_BITS    ( 10              ),
    .RSB_DEPTH        ( 4               ),
    .ICACHE_SIZE      ( 0               ),
    .DCACHE_SIZE      ( 0               ),
    .TECHNOLOGY       ( "GENERIC"       ),
    .MTVEC_DEFAULT    ( 32'h8000_0004   ),
    .HARTID           ( 0               ),
    .STRICT_AHB       ( 1               )
  ) dut (
    .HRESETn          ( HRESETn         ),
    .HCLK             ( HCLK            ),

    .pma_cfg_i        ( pma_cfg         ),
    .pma_adr_i        ( pma_adr         ),

    .ins_HSEL         ( ins_HSEL        ),
    .ins_HADDR        ( ins_HADDR       ),
    .ins_HWDATA       ( ins_HWDATA      ),
    .ins_HRDATA       ( ins_HRDATA      ),
    .ins_HWRITE       ( ins_HWRITE      ),
    .ins_HSIZE        ( ins_HSIZE       ),
    .ins_HBURST       ( ins_HBURST      ),
    .ins_HPROT        ( ins_HPROT       ),
    .ins_HTRANS       ( ins_HTRANS      ),
    .ins_HMASTLOCK    ( ins_HMASTLOCK   ),
    .ins_HREADY       ( ins_HREADY      ),
    .ins_HRESP        ( ins_HRESP       ),

    .dat_HSEL         ( dat_HSEL        ),
    .dat_HADDR        ( dat_HADDR       ),
    .dat_HWDATA       ( dat_HWDATA      ),
    .dat_HRDATA       ( dat_HRDATA      ),
    .dat_HWRITE       ( dat_HWRITE      ),
    .dat_HSIZE        ( dat_HSIZE       ),
    .dat_HBURST       ( dat_HBURST      ),
    .dat_HPROT        ( dat_HPROT       ),
    .dat_HTRANS       ( dat_HTRANS      ),
    .dat_HMASTLOCK    ( dat_HMASTLOCK   ),
    .dat_HREADY       ( dat_HREADY      ),
    .dat_HRESP        ( dat_HRESP       ),

    .ext_nmi          ( 1'b0            ),
    .ext_tint         ( 1'b0            ),
    .ext_sint         ( 1'b0            ),
    .ext_int          ( 4'h0            ),

    .dbg_stall        ( 1'b0            ),
    .dbg_strb         ( 1'b0            ),
    .dbg_we           ( 1'b0            ),
    .dbg_addr         ( 16'h0           ),
    .dbg_dati         ( 32'h0           ),
    .dbg_dato         (                 ),
    .dbg_ack          (                 ),
    .dbg_bp           (                 )
  );

  // Expose retired instruction count and PC
  assign inst_retired_o = dut.core.wb_insn.retired;
  assign inst_pc_o      = dut.core.wb_pc;

  // -------------------------------------------------------------
  // Hookup RoaLogic Official AHB3-Lite Memory Model
  // -------------------------------------------------------------
  logic             mem_hsel   [2];
  logic [      1:0] mem_htrans [2];
  logic [      2:0] mem_hburst [2];
  logic             mem_hready [2];
  logic             mem_hresp  [2];
  logic [     31:0] mem_haddr  [2];
  logic [     31:0] mem_hwdata [2];
  logic [     31:0] mem_hrdata [2];
  logic [      2:0] mem_hsize  [2];
  logic             mem_hwrite [2];

  assign mem_hsel  [0] = ins_HSEL;
  assign mem_htrans[0] = ins_HTRANS;
  assign mem_hburst[0] = ins_HBURST;
  assign mem_haddr [0] = ins_HADDR;
  assign mem_hwrite[0] = ins_HWRITE;
  assign mem_hsize [0] = 3'h2;
  assign mem_hwdata[0] = 32'h0;
  assign ins_HRDATA    = mem_hrdata[0];
  assign ins_HREADY    = mem_hready[0];
  assign ins_HRESP     = mem_hresp [0];

  assign mem_hsel  [1] = dat_HSEL;
  assign mem_htrans[1] = dat_HTRANS;
  assign mem_hburst[1] = dat_HBURST;
  assign mem_haddr [1] = dat_HADDR;
  assign mem_hwrite[1] = dat_HWRITE;
  assign mem_hsize [1] = dat_HSIZE;
  assign mem_hwdata[1] = dat_HWDATA;
  assign dat_HRDATA    = mem_hrdata[1];
  assign dat_HREADY    = mem_hready[1];
  assign dat_HRESP     = mem_hresp [1];

  memory_model_ahb3lite #(
    .DATA_WIDTH ( 32            ),
    .ADDR_WIDTH ( 32            ),
    .BASE       ( RAM_BASE      ),
    .PORTS      ( 2             ),
    .LATENCY    ( 1             )
  ) unified_memory (
    .HRESETn    ( HRESETn       ),
    .HCLK       ( HCLK          ),
    .HSEL       ( mem_hsel      ),
    .HTRANS     ( mem_htrans    ),
    .HREADYOUT  ( mem_hready    ),
    .HREADY     ( mem_hready    ),
    .HRESP      ( mem_hresp     ),
    .HADDR      ( mem_haddr     ),
    .HWRITE     ( mem_hwrite    ),
    .HSIZE      ( mem_hsize     ),
    .HBURST     ( mem_hburst    ),
    .HWDATA     ( mem_hwdata    ),
    .HRDATA     ( mem_hrdata    )
  );

  // -------------------------------------------------------------
  // MMIO Interface Snoop (UART and TOHOST)
  // -------------------------------------------------------------
  logic [ 1:0] dHTRANS;
  logic [31:0] dHADDR;
  logic        dHWRITE;

  always_ff @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
      dHTRANS        <= 2'b00;
      dHADDR         <= 32'h0;
      dHWRITE        <= 1'b0;
      uart_valid_o   <= 1'b0;
      uart_char_o    <= 8'h0;
      tohost_valid_o <= 1'b0;
      tohost_val_o   <= 32'h0;
    end else begin
      uart_valid_o   <= 1'b0;
      tohost_valid_o <= 1'b0;

      if (dat_HREADY) begin
        dHTRANS <= dat_HTRANS;
        dHADDR  <= dat_HADDR;
        dHWRITE <= dat_HWRITE;

        if (dHTRANS == HTRANS_NONSEQ && dHWRITE) begin
          if (dHADDR == UART_ADDR) begin
            uart_valid_o <= 1'b1;
            uart_char_o  <= dat_HWDATA[7:0];
          end else if (dHADDR == TOHOST_ADDR) begin
            tohost_valid_o <= 1'b1;
            tohost_val_o   <= dat_HWDATA;
          end
        end
      end
    end
  end

endmodule
