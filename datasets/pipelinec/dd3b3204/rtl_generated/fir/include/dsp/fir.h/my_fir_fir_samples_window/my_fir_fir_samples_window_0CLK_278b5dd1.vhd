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
entity my_fir_fir_samples_window_0CLK_278b5dd1 is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 input : in int16_t_stream_t;
 return_output : out my_fir_fir_samples_window_t);
end my_fir_fir_samples_window_0CLK_278b5dd1;
architecture arch of my_fir_fir_samples_window_0CLK_278b5dd1 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function

-- All user state registers
signal window : my_fir_fir_samples_window_t := my_fir_fir_samples_window_t_NULL;
signal REG_COMB_window : my_fir_fir_samples_window_t;

-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
-- window_MUX[fir_h_l39_c3_6307]
signal window_MUX_fir_h_l39_c3_6307_cond : unsigned(0 downto 0);
signal window_MUX_fir_h_l39_c3_6307_iftrue : my_fir_fir_samples_window_t;
signal window_MUX_fir_h_l39_c3_6307_iffalse : my_fir_fir_samples_window_t;
signal window_MUX_fir_h_l39_c3_6307_return_output : my_fir_fir_samples_window_t;

function CONST_REF_RD_uint1_t_int16_t_stream_t_valid_d41d( ref_toks_0 : int16_t_stream_t) return unsigned is
 
  variable base : int16_t_stream_t; 
  variable return_output : unsigned(0 downto 0);
begin
      base := ref_toks_0;

      return_output := base.valid;
      return return_output; 
end function;

function CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_2_d41d( ref_toks_0 : my_fir_fir_samples_window_t) return signed is
 
  variable base : my_fir_fir_samples_window_t; 
  variable return_output : signed(15 downto 0);
begin
      base := ref_toks_0;

      return_output := base.data(2);
      return return_output; 
end function;

function CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_1_d41d( ref_toks_0 : my_fir_fir_samples_window_t) return signed is
 
  variable base : my_fir_fir_samples_window_t; 
  variable return_output : signed(15 downto 0);
begin
      base := ref_toks_0;

      return_output := base.data(1);
      return return_output; 
end function;

function CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_0_d41d( ref_toks_0 : my_fir_fir_samples_window_t) return signed is
 
  variable base : my_fir_fir_samples_window_t; 
  variable return_output : signed(15 downto 0);
begin
      base := ref_toks_0;

      return_output := base.data(0);
      return return_output; 
end function;

function CONST_REF_RD_int16_t_int16_t_stream_t_data_d41d( ref_toks_0 : int16_t_stream_t) return signed is
 
  variable base : int16_t_stream_t; 
  variable return_output : signed(15 downto 0);
begin
      base := ref_toks_0;

      return_output := base.data;
      return return_output; 
end function;

function CONST_REF_RD_my_fir_fir_samples_window_t_my_fir_fir_samples_window_t_c86c( ref_toks_0 : signed;
 ref_toks_1 : signed;
 ref_toks_2 : signed;
 ref_toks_3 : signed) return my_fir_fir_samples_window_t is
 
  variable base : my_fir_fir_samples_window_t; 
  variable return_output : my_fir_fir_samples_window_t;
begin
      base.data(3) := ref_toks_0;
      base.data(2) := ref_toks_1;
      base.data(1) := ref_toks_2;
      base.data(0) := ref_toks_3;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- window_MUX_fir_h_l39_c3_6307 : 0 clocks latency
window_MUX_fir_h_l39_c3_6307 : entity work.MUX_uint1_t_my_fir_fir_samples_window_t_my_fir_fir_samples_window_t_0CLK_de264c78 port map (
window_MUX_fir_h_l39_c3_6307_cond,
window_MUX_fir_h_l39_c3_6307_iftrue,
window_MUX_fir_h_l39_c3_6307_iffalse,
window_MUX_fir_h_l39_c3_6307_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Inputs
 input,
 -- Registers
 window,
 -- All submodule outputs
 window_MUX_fir_h_l39_c3_6307_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : my_fir_fir_samples_window_t;
 variable VAR_input : int16_t_stream_t;
 variable VAR_CONST_REF_RD_uint1_t_int16_t_stream_t_valid_d41d_fir_h_l39_c6_cac0_return_output : unsigned(0 downto 0);
 variable VAR_window_MUX_fir_h_l39_c3_6307_iftrue : my_fir_fir_samples_window_t;
 variable VAR_window_TRUE_INPUT_MUX_CONST_REF_RD_my_fir_fir_samples_window_t_my_fir_fir_samples_window_t_c86c_fir_h_l39_c3_6307_return_output : my_fir_fir_samples_window_t;
 variable VAR_window_MUX_fir_h_l39_c3_6307_iffalse : my_fir_fir_samples_window_t;
 variable VAR_window_MUX_fir_h_l39_c3_6307_return_output : my_fir_fir_samples_window_t;
 variable VAR_window_MUX_fir_h_l39_c3_6307_cond : unsigned(0 downto 0);
 variable VAR_i : unsigned(31 downto 0);
 variable VAR_FOR_fir_h_l41_c5_d262_ITER_0_CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_2_d41d_fir_h_l43_c24_a9c2_return_output : signed(15 downto 0);
 variable VAR_FOR_fir_h_l41_c5_d262_ITER_1_CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_1_d41d_fir_h_l43_c24_a9c2_return_output : signed(15 downto 0);
 variable VAR_FOR_fir_h_l41_c5_d262_ITER_2_CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_0_d41d_fir_h_l43_c24_a9c2_return_output : signed(15 downto 0);
 variable VAR_CONST_REF_RD_int16_t_int16_t_stream_t_data_d41d_fir_h_l45_c22_6570_return_output : signed(15 downto 0);
 -- State registers comb logic variables
variable REG_VAR_window : my_fir_fir_samples_window_t;
begin

  -- STATE REGS
  -- Default read regs into vars
  REG_VAR_window := window;

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;
     -- Mux in inputs
     VAR_input := input;

     -- Submodule level 0
     VAR_window_MUX_fir_h_l39_c3_6307_iffalse := window;
     -- CONST_REF_RD_int16_t_int16_t_stream_t_data_d41d[fir_h_l45_c22_6570] LATENCY=0
     VAR_CONST_REF_RD_int16_t_int16_t_stream_t_data_d41d_fir_h_l45_c22_6570_return_output := VAR_input.data;

     -- CONST_REF_RD_uint1_t_int16_t_stream_t_valid_d41d[fir_h_l39_c6_cac0] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_int16_t_stream_t_valid_d41d_fir_h_l39_c6_cac0_return_output := VAR_input.valid;

     -- FOR_fir_h_l41_c5_d262_ITER_0_CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_2_d41d[fir_h_l43_c24_a9c2] LATENCY=0
     VAR_FOR_fir_h_l41_c5_d262_ITER_0_CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_2_d41d_fir_h_l43_c24_a9c2_return_output := window.data(2);

     -- FOR_fir_h_l41_c5_d262_ITER_1_CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_1_d41d[fir_h_l43_c24_a9c2] LATENCY=0
     VAR_FOR_fir_h_l41_c5_d262_ITER_1_CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_1_d41d_fir_h_l43_c24_a9c2_return_output := window.data(1);

     -- FOR_fir_h_l41_c5_d262_ITER_2_CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_0_d41d[fir_h_l43_c24_a9c2] LATENCY=0
     VAR_FOR_fir_h_l41_c5_d262_ITER_2_CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_0_d41d_fir_h_l43_c24_a9c2_return_output := window.data(0);

     -- Submodule level 1
     VAR_window_MUX_fir_h_l39_c3_6307_cond := VAR_CONST_REF_RD_uint1_t_int16_t_stream_t_valid_d41d_fir_h_l39_c6_cac0_return_output;
     -- window_TRUE_INPUT_MUX_CONST_REF_RD_my_fir_fir_samples_window_t_my_fir_fir_samples_window_t_c86c[fir_h_l39_c3_6307] LATENCY=0
     VAR_window_TRUE_INPUT_MUX_CONST_REF_RD_my_fir_fir_samples_window_t_my_fir_fir_samples_window_t_c86c_fir_h_l39_c3_6307_return_output := CONST_REF_RD_my_fir_fir_samples_window_t_my_fir_fir_samples_window_t_c86c(
     VAR_FOR_fir_h_l41_c5_d262_ITER_0_CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_2_d41d_fir_h_l43_c24_a9c2_return_output,
     VAR_FOR_fir_h_l41_c5_d262_ITER_1_CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_1_d41d_fir_h_l43_c24_a9c2_return_output,
     VAR_FOR_fir_h_l41_c5_d262_ITER_2_CONST_REF_RD_int16_t_my_fir_fir_samples_window_t_data_0_d41d_fir_h_l43_c24_a9c2_return_output,
     VAR_CONST_REF_RD_int16_t_int16_t_stream_t_data_d41d_fir_h_l45_c22_6570_return_output);

     -- Submodule level 2
     VAR_window_MUX_fir_h_l39_c3_6307_iftrue := VAR_window_TRUE_INPUT_MUX_CONST_REF_RD_my_fir_fir_samples_window_t_my_fir_fir_samples_window_t_c86c_fir_h_l39_c3_6307_return_output;
     -- window_MUX[fir_h_l39_c3_6307] LATENCY=0
     -- Inputs
     window_MUX_fir_h_l39_c3_6307_cond <= VAR_window_MUX_fir_h_l39_c3_6307_cond;
     window_MUX_fir_h_l39_c3_6307_iftrue <= VAR_window_MUX_fir_h_l39_c3_6307_iftrue;
     window_MUX_fir_h_l39_c3_6307_iffalse <= VAR_window_MUX_fir_h_l39_c3_6307_iffalse;
     -- Outputs
     VAR_window_MUX_fir_h_l39_c3_6307_return_output := window_MUX_fir_h_l39_c3_6307_return_output;

     -- Submodule level 3
     VAR_return_output := VAR_window_MUX_fir_h_l39_c3_6307_return_output;
     REG_VAR_window := VAR_window_MUX_fir_h_l39_c3_6307_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

-- Write regs vars to comb logic
REG_COMB_window <= REG_VAR_window;
end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
 if clk_en_internal='1' then
     window <= REG_COMB_window;
 end if;
 end if;
end process;

end arch;
