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
-- Submodules: 7
entity my_fir_fir_adder_tree_0CLK_e116da74 is
port(
 data : in int34_t_4;
 return_output : out signed(33 downto 0));
end my_fir_fir_adder_tree_0CLK_e116da74;
architecture arch of my_fir_fir_adder_tree_0CLK_e116da74 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Each function instance gets signals
-- FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS[fir_h_l52_c358_0c33]
signal FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_left : signed(33 downto 0);
signal FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_right : signed(33 downto 0);
signal FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output : signed(34 downto 0);

-- FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS[fir_h_l52_c358_0c33]
signal FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_left : signed(33 downto 0);
signal FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_right : signed(33 downto 0);
signal FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output : signed(34 downto 0);

-- FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS[fir_h_l52_c358_0c33]
signal FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_left : signed(33 downto 0);
signal FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_right : signed(33 downto 0);
signal FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output : signed(34 downto 0);

function CONST_REF_RD_int34_t_int34_t_4_0_d41d( ref_toks_0 : int34_t_4) return signed is
 
  variable base : int34_t_4; 
  variable return_output : signed(33 downto 0);
begin
      base := ref_toks_0;

      return_output := base(0);
      return return_output; 
end function;

function CONST_REF_RD_int34_t_int34_t_4_1_d41d( ref_toks_0 : int34_t_4) return signed is
 
  variable base : int34_t_4; 
  variable return_output : signed(33 downto 0);
begin
      base := ref_toks_0;

      return_output := base(1);
      return return_output; 
end function;

function CONST_REF_RD_int34_t_int34_t_4_2_d41d( ref_toks_0 : int34_t_4) return signed is
 
  variable base : int34_t_4; 
  variable return_output : signed(33 downto 0);
begin
      base := ref_toks_0;

      return_output := base(2);
      return return_output; 
end function;

function CONST_REF_RD_int34_t_int34_t_4_3_d41d( ref_toks_0 : int34_t_4) return signed is
 
  variable base : int34_t_4; 
  variable return_output : signed(33 downto 0);
begin
      base := ref_toks_0;

      return_output := base(3);
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33 : 0 clocks latency
FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33 : entity work.BIN_OP_PLUS_int34_t_int34_t_0CLK_de264c78 port map (
FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_left,
FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_right,
FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output);

-- FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33 : 0 clocks latency
FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33 : entity work.BIN_OP_PLUS_int34_t_int34_t_0CLK_de264c78 port map (
FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_left,
FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_right,
FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output);

-- FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33 : 0 clocks latency
FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33 : entity work.BIN_OP_PLUS_int34_t_int34_t_0CLK_de264c78 port map (
FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_left,
FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_right,
FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output);



-- Combinatorial process for pipeline stages
process (
 -- Inputs
 data,
 -- All submodule outputs
 FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output,
 FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output,
 FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : signed(33 downto 0);
 variable VAR_data : int34_t_4;
 variable VAR_tree_nodes : int34_t_3_4;
 variable VAR_i : unsigned(31 downto 0);
 variable VAR_FOR_fir_h_l52_c91_f471_ITER_0_CONST_REF_RD_int34_t_int34_t_4_0_d41d_fir_h_l52_c134_f8c8_return_output : signed(33 downto 0);
 variable VAR_FOR_fir_h_l52_c91_f471_ITER_1_CONST_REF_RD_int34_t_int34_t_4_1_d41d_fir_h_l52_c134_f8c8_return_output : signed(33 downto 0);
 variable VAR_FOR_fir_h_l52_c91_f471_ITER_2_CONST_REF_RD_int34_t_int34_t_4_2_d41d_fir_h_l52_c134_f8c8_return_output : signed(33 downto 0);
 variable VAR_FOR_fir_h_l52_c91_f471_ITER_3_CONST_REF_RD_int34_t_int34_t_4_3_d41d_fir_h_l52_c134_f8c8_return_output : signed(33 downto 0);
 variable VAR_n_inputs_curr : unsigned(31 downto 0);
 variable VAR_n_inputs_next : unsigned(31 downto 0);
 variable VAR_level : unsigned(31 downto 0);
 variable VAR_op_count : unsigned(31 downto 0);
 variable VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_tree_nodes_1_0_fir_h_l52_c328_52ee : signed(33 downto 0);
 variable VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_left : signed(33 downto 0);
 variable VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_right : signed(33 downto 0);
 variable VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output : signed(34 downto 0);
 variable VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_tree_nodes_1_1_fir_h_l52_c328_52ee : signed(33 downto 0);
 variable VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_left : signed(33 downto 0);
 variable VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_right : signed(33 downto 0);
 variable VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output : signed(34 downto 0);
 variable VAR_FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_tree_nodes_2_0_fir_h_l52_c328_52ee : signed(33 downto 0);
 variable VAR_FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_left : signed(33 downto 0);
 variable VAR_FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_right : signed(33 downto 0);
 variable VAR_FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output : signed(34 downto 0);
 variable VAR_result : signed(33 downto 0);
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in inputs
     VAR_data := data;

     -- Submodule level 0
     -- FOR_fir_h_l52_c91_f471_ITER_0_CONST_REF_RD_int34_t_int34_t_4_0_d41d[fir_h_l52_c134_f8c8] LATENCY=0
     VAR_FOR_fir_h_l52_c91_f471_ITER_0_CONST_REF_RD_int34_t_int34_t_4_0_d41d_fir_h_l52_c134_f8c8_return_output := VAR_data(0);

     -- FOR_fir_h_l52_c91_f471_ITER_1_CONST_REF_RD_int34_t_int34_t_4_1_d41d[fir_h_l52_c134_f8c8] LATENCY=0
     VAR_FOR_fir_h_l52_c91_f471_ITER_1_CONST_REF_RD_int34_t_int34_t_4_1_d41d_fir_h_l52_c134_f8c8_return_output := VAR_data(1);

     -- FOR_fir_h_l52_c91_f471_ITER_2_CONST_REF_RD_int34_t_int34_t_4_2_d41d[fir_h_l52_c134_f8c8] LATENCY=0
     VAR_FOR_fir_h_l52_c91_f471_ITER_2_CONST_REF_RD_int34_t_int34_t_4_2_d41d_fir_h_l52_c134_f8c8_return_output := VAR_data(2);

     -- FOR_fir_h_l52_c91_f471_ITER_3_CONST_REF_RD_int34_t_int34_t_4_3_d41d[fir_h_l52_c134_f8c8] LATENCY=0
     VAR_FOR_fir_h_l52_c91_f471_ITER_3_CONST_REF_RD_int34_t_int34_t_4_3_d41d_fir_h_l52_c134_f8c8_return_output := VAR_data(3);

     -- Submodule level 1
     VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_left := VAR_FOR_fir_h_l52_c91_f471_ITER_0_CONST_REF_RD_int34_t_int34_t_4_0_d41d_fir_h_l52_c134_f8c8_return_output;
     VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_right := VAR_FOR_fir_h_l52_c91_f471_ITER_1_CONST_REF_RD_int34_t_int34_t_4_1_d41d_fir_h_l52_c134_f8c8_return_output;
     VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_left := VAR_FOR_fir_h_l52_c91_f471_ITER_2_CONST_REF_RD_int34_t_int34_t_4_2_d41d_fir_h_l52_c134_f8c8_return_output;
     VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_right := VAR_FOR_fir_h_l52_c91_f471_ITER_3_CONST_REF_RD_int34_t_int34_t_4_3_d41d_fir_h_l52_c134_f8c8_return_output;
     -- FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS[fir_h_l52_c358_0c33] LATENCY=0
     -- Inputs
     FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_left <= VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_left;
     FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_right <= VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_right;
     -- Outputs
     VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output := FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output;

     -- FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS[fir_h_l52_c358_0c33] LATENCY=0
     -- Inputs
     FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_left <= VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_left;
     FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_right <= VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_right;
     -- Outputs
     VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output := FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output;

     -- Submodule level 2
     VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_tree_nodes_1_0_fir_h_l52_c328_52ee := signed(std_logic_vector(resize(unsigned(std_logic_vector(VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output)), 34)));
     VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_tree_nodes_1_1_fir_h_l52_c328_52ee := signed(std_logic_vector(resize(unsigned(std_logic_vector(VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output)), 34)));
     VAR_FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_left := VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_0_tree_nodes_1_0_fir_h_l52_c328_52ee;
     VAR_FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_right := VAR_FOR_fir_h_l52_c217_4d2b_ITER_0_WHILE_fir_h_l52_c279_ec6f_ITER_1_tree_nodes_1_1_fir_h_l52_c328_52ee;
     -- FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS[fir_h_l52_c358_0c33] LATENCY=0
     -- Inputs
     FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_left <= VAR_FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_left;
     FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_right <= VAR_FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_right;
     -- Outputs
     VAR_FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output := FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output;

     -- Submodule level 3
     VAR_FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_tree_nodes_2_0_fir_h_l52_c328_52ee := signed(std_logic_vector(resize(unsigned(std_logic_vector(VAR_FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_BIN_OP_PLUS_fir_h_l52_c358_0c33_return_output)), 34)));
     VAR_return_output := VAR_FOR_fir_h_l52_c217_4d2b_ITER_1_WHILE_fir_h_l52_c279_ec6f_ITER_0_tree_nodes_2_0_fir_h_l52_c328_52ee;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
