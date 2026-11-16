-- Timing params:
--   Pipeline Slices: []
--   Input regs?: False
--   Output regs?: False
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.c_structs_pkg.all;
-- Submodules: 11
entity my_fir_fir_func_0CLK_9b22146f is
port(
 data : in int16_t_4;
 return_output : out signed(15 downto 0));
end my_fir_fir_func_0CLK_9b22146f;
architecture arch of my_fir_fir_func_0CLK_9b22146f is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT[fir_h_l66_c19_ea51]
signal FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left : signed(15 downto 0);
signal FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right : signed(15 downto 0);
signal FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output : signed(31 downto 0);

-- FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT[fir_h_l66_c19_ea51]
signal FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left : signed(15 downto 0);
signal FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right : signed(15 downto 0);
signal FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output : signed(31 downto 0);

-- FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT[fir_h_l66_c19_ea51]
signal FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left : signed(15 downto 0);
signal FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right : signed(15 downto 0);
signal FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output : signed(31 downto 0);

-- FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT[fir_h_l66_c19_ea51]
signal FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left : signed(15 downto 0);
signal FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right : signed(15 downto 0);
signal FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output : signed(31 downto 0);

-- my_fir_fir_adder_tree[fir_h_l70_c16_41c9]
signal my_fir_fir_adder_tree_fir_h_l70_c16_41c9_data : int34_t_4;
signal my_fir_fir_adder_tree_fir_h_l70_c16_41c9_return_output : signed(33 downto 0);

-- CONST_SR_15[fir_h_l76_c8_fc15]
signal CONST_SR_15_fir_h_l76_c8_fc15_x : signed(33 downto 0);
signal CONST_SR_15_fir_h_l76_c8_fc15_return_output : signed(33 downto 0);

function CONST_REF_RD_int16_t_int16_t_4_0_d41d( ref_toks_0 : int16_t_4) return signed is
 
  variable base : int16_t_4; 
  variable return_output : signed(15 downto 0);
begin
      base := ref_toks_0;

      return_output := base(0);
      return return_output; 
end function;

function CONST_REF_RD_int16_t_int16_t_4_1_d41d( ref_toks_0 : int16_t_4) return signed is
 
  variable base : int16_t_4; 
  variable return_output : signed(15 downto 0);
begin
      base := ref_toks_0;

      return_output := base(1);
      return return_output; 
end function;

function CONST_REF_RD_int16_t_int16_t_4_2_d41d( ref_toks_0 : int16_t_4) return signed is
 
  variable base : int16_t_4; 
  variable return_output : signed(15 downto 0);
begin
      base := ref_toks_0;

      return_output := base(2);
      return return_output; 
end function;

function CONST_REF_RD_int16_t_int16_t_4_3_d41d( ref_toks_0 : int16_t_4) return signed is
 
  variable base : int16_t_4; 
  variable return_output : signed(15 downto 0);
begin
      base := ref_toks_0;

      return_output := base(3);
      return return_output; 
end function;

function CONST_REF_RD_int34_t_4_int34_t_4_2346( ref_toks_0 : signed;
 ref_toks_1 : signed;
 ref_toks_2 : signed;
 ref_toks_3 : signed) return int34_t_4 is
 
  variable base : int34_t_4; 
  variable return_output : int34_t_4;
begin
      base(0) := ref_toks_0;
      base(1) := ref_toks_1;
      base(2) := ref_toks_2;
      base(3) := ref_toks_3;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51 : 0 clocks latency
FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51 : entity work.BIN_OP_INFERRED_MULT_int16_t_int16_t_0CLK_de264c78 port map (
FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left,
FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right,
FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output);

-- FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51 : 0 clocks latency
FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51 : entity work.BIN_OP_INFERRED_MULT_int16_t_int16_t_0CLK_de264c78 port map (
FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left,
FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right,
FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output);

-- FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51 : 0 clocks latency
FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51 : entity work.BIN_OP_INFERRED_MULT_int16_t_int16_t_0CLK_de264c78 port map (
FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left,
FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right,
FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output);

-- FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51 : 0 clocks latency
FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51 : entity work.BIN_OP_INFERRED_MULT_int16_t_int16_t_0CLK_de264c78 port map (
FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left,
FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right,
FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output);

-- my_fir_fir_adder_tree_fir_h_l70_c16_41c9 : 0 clocks latency
my_fir_fir_adder_tree_fir_h_l70_c16_41c9 : entity work.my_fir_fir_adder_tree_0CLK_e116da74 port map (
my_fir_fir_adder_tree_fir_h_l70_c16_41c9_data,
my_fir_fir_adder_tree_fir_h_l70_c16_41c9_return_output);

-- CONST_SR_15_fir_h_l76_c8_fc15 : 0 clocks latency
CONST_SR_15_fir_h_l76_c8_fc15 : entity work.CONST_SR_15_int34_t_0CLK_de264c78 port map (
CONST_SR_15_fir_h_l76_c8_fc15_x,
CONST_SR_15_fir_h_l76_c8_fc15_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 data,
 -- All submodule outputs
 FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output,
 FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output,
 FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output,
 FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output,
 my_fir_fir_adder_tree_fir_h_l70_c16_41c9_return_output,
 CONST_SR_15_fir_h_l76_c8_fc15_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : signed(15 downto 0);
 variable VAR_data : int16_t_4;
 variable VAR_coeffs : int16_t_4;
 variable VAR_products : int34_t_4;
 variable VAR_i : unsigned(31 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_0_products_0_fir_h_l66_c5_b754 : signed(33 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_0_CONST_REF_RD_int16_t_int16_t_4_0_d41d_fir_h_l66_c19_4ac4_return_output : signed(15 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left : signed(15 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right : signed(15 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output : signed(31 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_1_products_1_fir_h_l66_c5_b754 : signed(33 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_1_CONST_REF_RD_int16_t_int16_t_4_1_d41d_fir_h_l66_c19_4ac4_return_output : signed(15 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left : signed(15 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right : signed(15 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output : signed(31 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_2_products_2_fir_h_l66_c5_b754 : signed(33 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_2_CONST_REF_RD_int16_t_int16_t_4_2_d41d_fir_h_l66_c19_4ac4_return_output : signed(15 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left : signed(15 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right : signed(15 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output : signed(31 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_3_products_3_fir_h_l66_c5_b754 : signed(33 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_3_CONST_REF_RD_int16_t_int16_t_4_3_d41d_fir_h_l66_c19_4ac4_return_output : signed(15 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left : signed(15 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right : signed(15 downto 0);
 variable VAR_FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output : signed(31 downto 0);
 variable VAR_rv : signed(33 downto 0);
 variable VAR_my_fir_fir_adder_tree_fir_h_l70_c16_41c9_data : int34_t_4;
 variable VAR_CONST_REF_RD_int34_t_4_int34_t_4_2346_fir_h_l70_c38_c07f_return_output : int34_t_4;
 variable VAR_my_fir_fir_adder_tree_fir_h_l70_c16_41c9_return_output : signed(33 downto 0);
 variable VAR_rv_fir_h_l76_c3_fa96 : signed(33 downto 0);
 variable VAR_CONST_SR_15_fir_h_l76_c8_fc15_return_output : signed(33 downto 0);
 variable VAR_CONST_SR_15_fir_h_l76_c8_fc15_x : signed(33 downto 0);
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right := to_signed(-2, 16);
     VAR_FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right := to_signed(-4, 16);
     VAR_FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right := to_signed(1, 16);
     VAR_FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right := to_signed(3, 16);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_data := data;

     -- Submodule level 0
     -- FOR_fir_h_l64_c3_58e8_ITER_0_CONST_REF_RD_int16_t_int16_t_4_0_d41d[fir_h_l66_c19_4ac4] LATENCY=0
     VAR_FOR_fir_h_l64_c3_58e8_ITER_0_CONST_REF_RD_int16_t_int16_t_4_0_d41d_fir_h_l66_c19_4ac4_return_output := VAR_data(0);

     -- FOR_fir_h_l64_c3_58e8_ITER_1_CONST_REF_RD_int16_t_int16_t_4_1_d41d[fir_h_l66_c19_4ac4] LATENCY=0
     VAR_FOR_fir_h_l64_c3_58e8_ITER_1_CONST_REF_RD_int16_t_int16_t_4_1_d41d_fir_h_l66_c19_4ac4_return_output := VAR_data(1);

     -- FOR_fir_h_l64_c3_58e8_ITER_2_CONST_REF_RD_int16_t_int16_t_4_2_d41d[fir_h_l66_c19_4ac4] LATENCY=0
     VAR_FOR_fir_h_l64_c3_58e8_ITER_2_CONST_REF_RD_int16_t_int16_t_4_2_d41d_fir_h_l66_c19_4ac4_return_output := VAR_data(2);

     -- FOR_fir_h_l64_c3_58e8_ITER_3_CONST_REF_RD_int16_t_int16_t_4_3_d41d[fir_h_l66_c19_4ac4] LATENCY=0
     VAR_FOR_fir_h_l64_c3_58e8_ITER_3_CONST_REF_RD_int16_t_int16_t_4_3_d41d_fir_h_l66_c19_4ac4_return_output := VAR_data(3);

     -- Submodule level 1
     VAR_FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left := VAR_FOR_fir_h_l64_c3_58e8_ITER_0_CONST_REF_RD_int16_t_int16_t_4_0_d41d_fir_h_l66_c19_4ac4_return_output;
     VAR_FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left := VAR_FOR_fir_h_l64_c3_58e8_ITER_1_CONST_REF_RD_int16_t_int16_t_4_1_d41d_fir_h_l66_c19_4ac4_return_output;
     VAR_FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left := VAR_FOR_fir_h_l64_c3_58e8_ITER_2_CONST_REF_RD_int16_t_int16_t_4_2_d41d_fir_h_l66_c19_4ac4_return_output;
     VAR_FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left := VAR_FOR_fir_h_l64_c3_58e8_ITER_3_CONST_REF_RD_int16_t_int16_t_4_3_d41d_fir_h_l66_c19_4ac4_return_output;
     -- FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT[fir_h_l66_c19_ea51] LATENCY=0
     -- Inputs
     FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left <= VAR_FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left;
     FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right <= VAR_FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right;
     -- Outputs
     VAR_FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output := FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output;

     -- FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT[fir_h_l66_c19_ea51] LATENCY=0
     -- Inputs
     FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left <= VAR_FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left;
     FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right <= VAR_FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right;
     -- Outputs
     VAR_FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output := FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output;

     -- FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT[fir_h_l66_c19_ea51] LATENCY=0
     -- Inputs
     FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left <= VAR_FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left;
     FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right <= VAR_FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right;
     -- Outputs
     VAR_FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output := FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output;

     -- FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT[fir_h_l66_c19_ea51] LATENCY=0
     -- Inputs
     FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left <= VAR_FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_left;
     FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right <= VAR_FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_right;
     -- Outputs
     VAR_FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output := FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output;

     -- Submodule level 2
     VAR_FOR_fir_h_l64_c3_58e8_ITER_0_products_0_fir_h_l66_c5_b754 := resize(VAR_FOR_fir_h_l64_c3_58e8_ITER_0_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output, 34);
     VAR_FOR_fir_h_l64_c3_58e8_ITER_1_products_1_fir_h_l66_c5_b754 := resize(VAR_FOR_fir_h_l64_c3_58e8_ITER_1_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output, 34);
     VAR_FOR_fir_h_l64_c3_58e8_ITER_2_products_2_fir_h_l66_c5_b754 := resize(VAR_FOR_fir_h_l64_c3_58e8_ITER_2_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output, 34);
     VAR_FOR_fir_h_l64_c3_58e8_ITER_3_products_3_fir_h_l66_c5_b754 := resize(VAR_FOR_fir_h_l64_c3_58e8_ITER_3_BIN_OP_INFERRED_MULT_fir_h_l66_c19_ea51_return_output, 34);
     -- CONST_REF_RD_int34_t_4_int34_t_4_2346[fir_h_l70_c38_c07f] LATENCY=0
     VAR_CONST_REF_RD_int34_t_4_int34_t_4_2346_fir_h_l70_c38_c07f_return_output := CONST_REF_RD_int34_t_4_int34_t_4_2346(
     VAR_FOR_fir_h_l64_c3_58e8_ITER_0_products_0_fir_h_l66_c5_b754,
     VAR_FOR_fir_h_l64_c3_58e8_ITER_1_products_1_fir_h_l66_c5_b754,
     VAR_FOR_fir_h_l64_c3_58e8_ITER_2_products_2_fir_h_l66_c5_b754,
     VAR_FOR_fir_h_l64_c3_58e8_ITER_3_products_3_fir_h_l66_c5_b754);

     -- Submodule level 3
     VAR_my_fir_fir_adder_tree_fir_h_l70_c16_41c9_data := VAR_CONST_REF_RD_int34_t_4_int34_t_4_2346_fir_h_l70_c38_c07f_return_output;
     -- my_fir_fir_adder_tree[fir_h_l70_c16_41c9] LATENCY=0
     -- Inputs
     my_fir_fir_adder_tree_fir_h_l70_c16_41c9_data <= VAR_my_fir_fir_adder_tree_fir_h_l70_c16_41c9_data;
     -- Outputs
     VAR_my_fir_fir_adder_tree_fir_h_l70_c16_41c9_return_output := my_fir_fir_adder_tree_fir_h_l70_c16_41c9_return_output;

     -- Submodule level 4
     VAR_CONST_SR_15_fir_h_l76_c8_fc15_x := VAR_my_fir_fir_adder_tree_fir_h_l70_c16_41c9_return_output;
     -- CONST_SR_15[fir_h_l76_c8_fc15] LATENCY=0
     -- Inputs
     CONST_SR_15_fir_h_l76_c8_fc15_x <= VAR_CONST_SR_15_fir_h_l76_c8_fc15_x;
     -- Outputs
     VAR_CONST_SR_15_fir_h_l76_c8_fc15_return_output := CONST_SR_15_fir_h_l76_c8_fc15_return_output;

     -- Submodule level 5
     VAR_rv_fir_h_l76_c3_fa96 := VAR_CONST_SR_15_fir_h_l76_c8_fc15_return_output;
     VAR_return_output := signed(std_logic_vector(resize(unsigned(std_logic_vector(VAR_rv_fir_h_l76_c3_fa96)), 16)));
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
