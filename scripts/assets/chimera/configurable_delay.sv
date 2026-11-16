// Copyright 2026 SCORE Project.
// Behavioral pass-through model for configurable_delay under Verilator simulation.

`timescale 1ns/1ps

module configurable_delay #(
  parameter int unsigned NUM_STEPS = 16,
  localparam DELAY_SEL_WIDTH = (NUM_STEPS > 1) ? $clog2(NUM_STEPS) : 1
) (
  input  logic clk_i,
  input  logic enable_i,
  input  logic [DELAY_SEL_WIDTH-1:0] delay_i,
  output logic clk_o
);
  assign clk_o = clk_i;
endmodule
