// Copyright 2026 SCORE Project
// SPDX-License-Identifier: Apache-2.0
//
// Native Verilator behavioral stub for configurable_delay.
`timescale 1ps/1ps

module configurable_delay #(
  parameter int unsigned NUM_STEPS = 16,
  localparam DELAY_SEL_WIDTH = $clog2(NUM_STEPS)
) (
  input  logic                       clk_i,
  input  logic                       enable_i,
  input  logic [DELAY_SEL_WIDTH-1:0] delay_i,
  output logic                      clk_o
);

  assign clk_o = clk_i;

endmodule
