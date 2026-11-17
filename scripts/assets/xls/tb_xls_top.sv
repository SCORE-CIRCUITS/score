// Top-level testbench wrapper for Google XLS HLS/DSLX synthesized pipelines
// Integrates:
// 1. x_plus_y_plus_z: 32-bit pipelined reduction tree (II=1, 3 stages)
// 2. identity_of_mul: 8-bit pipelined multiplier (II=1, 2 stages)
// 3. ValidSignal: 8-bit pipelined valid/ready select (2 stages)
// 4. repeat_byte_4: byte-to-word expansion
// 5. xls_uart_ident_top: streaming loopback accelerator (ClocksPerBaud=16 for sim)

module tb_xls_top (
  input  wire        clk,
  input  wire        rst_n,

  // Tree of adds pipeline (3 stages)
  input  wire [31:0] tree_a,
  input  wire [31:0] tree_b,
  input  wire [31:0] tree_c,
  input  wire [31:0] tree_d,
  input  wire [31:0] tree_e,
  output wire [31:0] tree_out,

  // Multiplier pipeline (2 stages)
  input  wire [7:0]  mul_x,
  input  wire [7:0]  mul_y,
  output wire [7:0]  mul_out,

  // ValidSignal pipeline (2 stages)
  input  wire        val_in_valid,
  input  wire [1:0]  val_s,
  input  wire [7:0]  val_x,
  input  wire [7:0]  val_y,
  input  wire [7:0]  val_z,
  input  wire [7:0]  val_a,
  output wire        val_out_valid,
  output wire [7:0]  val_out,

  // Repeat byte datapath
  input  wire [7:0]  rep_x,
  output wire [31:0] rep_out,

  // UART streaming loopback
  input  wire        uart_rx,
  output wire        uart_tx,
  output wire        uart_cts_n
);

  // 1. Reduction Tree Pipeline
  x_plus_y_plus_z u_tree (
    .clk (clk),
    .a   (tree_a),
    .b   (tree_b),
    .c   (tree_c),
    .d   (tree_d),
    .e   (tree_e),
    .out (tree_out)
  );

  // 2. Multiplier Pipeline
  identity_of_mul u_mul (
    .clk (clk),
    .x   (mul_x),
    .y   (mul_y),
    .out (mul_out)
  );

  // 3. ValidSignal Pipeline
  ValidSignal u_val (
    .clk       (clk),
    .in_valid  (val_in_valid),
    .s         (val_s),
    .x         (val_x),
    .y         (val_y),
    .z         (val_z),
    .a         (val_a),
    .out_valid (val_out_valid),
    .out       (val_out)
  );

  // 4. Repeat Byte Datapath
  repeat_byte_4 u_rep (
    .x   (rep_x),
    .out (rep_out)
  );

  // 5. Streaming UART Accelerator (fast baud 16 cycles for simulation)
  xls_uart_ident_top #(
    .ClocksPerBaud (16)
  ) u_uart (
    .clk                 (clk),
    .rx_in               (uart_rx),
    .tx_out              (uart_tx),
    .clear_to_send_out_n (uart_cts_n)
  );

endmodule

