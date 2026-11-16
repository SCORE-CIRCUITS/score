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
-- Submodules: 8
entity my_fir_0CLK_db82ffa6 is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 input : in int16_t_stream_t;
 return_output : out int16_t_stream_t);
end my_fir_0CLK_db82ffa6;
architecture arch of my_fir_0CLK_db82ffa6 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
-- my_fir_fir_samples_window[fir_decim_h_l56_c47_f495]
signal my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_CLOCK_ENABLE : unsigned(0 downto 0);
signal my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_input : int16_t_stream_t;
signal my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_return_output : my_fir_fir_samples_window_t;

-- TRUE_CLOCK_ENABLE_MUX[fir_decim_h_l60_c1_c0f1]
signal TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_cond : unsigned(0 downto 0);
signal TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_iftrue : unsigned(0 downto 0);
signal TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_iffalse : unsigned(0 downto 0);
signal TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_return_output : unsigned(0 downto 0);

-- decim_count_ellapsed_MUX[fir_decim_h_l60_c3_87f9]
signal decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_cond : unsigned(0 downto 0);
signal decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_iftrue : unsigned(0 downto 0);
signal decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_iffalse : unsigned(0 downto 0);
signal decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_return_output : unsigned(0 downto 0);

-- my_fir_decim_counter[fir_decim_h_l61_c28_1dbd]
signal my_fir_decim_counter_fir_decim_h_l61_c28_1dbd_CLOCK_ENABLE : unsigned(0 downto 0);
signal my_fir_decim_counter_fir_decim_h_l61_c28_1dbd_return_output : unsigned(0 downto 0);

-- my_fir_fir_func[fir_decim_h_l70_c15_c9a3]
signal my_fir_fir_func_fir_decim_h_l70_c15_c9a3_data : int16_t_4;
signal my_fir_fir_func_fir_decim_h_l70_c15_c9a3_return_output : signed(15 downto 0);

function CONST_REF_RD_uint1_t_int16_t_stream_t_valid_d41d( ref_toks_0 : int16_t_stream_t) return unsigned is
 
  variable base : int16_t_stream_t; 
  variable return_output : unsigned(0 downto 0);
begin
      base := ref_toks_0;

      return_output := base.valid;
      return return_output; 
end function;

function CONST_REF_RD_int16_t_4_my_fir_fir_samples_window_t_data_d41d( ref_toks_0 : my_fir_fir_samples_window_t) return int16_t_4 is
 
  variable base : my_fir_fir_samples_window_t; 
  variable return_output : int16_t_4;
begin
      base := ref_toks_0;

      return_output := base.data;
      return return_output; 
end function;

function CONST_REF_RD_int16_t_stream_t_int16_t_stream_t_1095( ref_toks_0 : unsigned;
 ref_toks_1 : signed) return int16_t_stream_t is
 
  variable base : int16_t_stream_t; 
  variable return_output : int16_t_stream_t;
begin
      base.valid := ref_toks_0;
      base.data := ref_toks_1;

      return_output := base;
      return return_output; 
end function;


begin

-- SUBMODULE INSTANCES 
-- my_fir_fir_samples_window_fir_decim_h_l56_c47_f495 : 0 clocks latency
my_fir_fir_samples_window_fir_decim_h_l56_c47_f495 : entity work.my_fir_fir_samples_window_0CLK_278b5dd1 port map (
clk,
my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_CLOCK_ENABLE,
my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_input,
my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_return_output);

-- TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1 : 0 clocks latency
TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_cond,
TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_iftrue,
TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_iffalse,
TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_return_output);

-- decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9 : 0 clocks latency
decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_cond,
decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_iftrue,
decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_iffalse,
decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_return_output);

-- my_fir_decim_counter_fir_decim_h_l61_c28_1dbd : 0 clocks latency
my_fir_decim_counter_fir_decim_h_l61_c28_1dbd : entity work.my_fir_decim_counter_0CLK_10fb5039 port map (
clk,
my_fir_decim_counter_fir_decim_h_l61_c28_1dbd_CLOCK_ENABLE,
my_fir_decim_counter_fir_decim_h_l61_c28_1dbd_return_output);

-- my_fir_fir_func_fir_decim_h_l70_c15_c9a3 : 0 clocks latency
my_fir_fir_func_fir_decim_h_l70_c15_c9a3 : entity work.my_fir_fir_func_0CLK_9b22146f port map (
my_fir_fir_func_fir_decim_h_l70_c15_c9a3_data,
my_fir_fir_func_fir_decim_h_l70_c15_c9a3_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Inputs
 input,
 -- All submodule outputs
 my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_return_output,
 TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_return_output,
 decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_return_output,
 my_fir_decim_counter_fir_decim_h_l61_c28_1dbd_return_output,
 my_fir_fir_func_fir_decim_h_l70_c15_c9a3_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : int16_t_stream_t;
 variable VAR_input : int16_t_stream_t;
 variable VAR_sample_window : my_fir_fir_samples_window_t;
 variable VAR_my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_input : int16_t_stream_t;
 variable VAR_my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_return_output : my_fir_fir_samples_window_t;
 variable VAR_decim_count_ellapsed : unsigned(0 downto 0);
 variable VAR_CONST_REF_RD_uint1_t_int16_t_stream_t_valid_d41d_fir_decim_h_l60_c6_4cb3_return_output : unsigned(0 downto 0);
 variable VAR_TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_return_output : unsigned(0 downto 0);
 variable VAR_TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_cond : unsigned(0 downto 0);
 variable VAR_TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_iftrue : unsigned(0 downto 0);
 variable VAR_TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_iffalse : unsigned(0 downto 0);
 variable VAR_decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_iftrue : unsigned(0 downto 0);
 variable VAR_decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_iffalse : unsigned(0 downto 0);
 variable VAR_decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_return_output : unsigned(0 downto 0);
 variable VAR_decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_cond : unsigned(0 downto 0);
 variable VAR_my_fir_decim_counter_fir_decim_h_l61_c28_1dbd_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_my_fir_decim_counter_fir_decim_h_l61_c28_1dbd_return_output : unsigned(0 downto 0);
 variable VAR_rv : int16_t_stream_t;
 variable VAR_my_fir_fir_func_fir_decim_h_l70_c15_c9a3_data : int16_t_4;
 variable VAR_CONST_REF_RD_int16_t_4_my_fir_fir_samples_window_t_data_d41d_fir_decim_h_l70_c31_930d_return_output : int16_t_4;
 variable VAR_my_fir_fir_func_fir_decim_h_l70_c15_c9a3_return_output : signed(15 downto 0);
 variable VAR_CONST_REF_RD_int16_t_stream_t_int16_t_stream_t_1095_fir_decim_h_l73_c10_1df2_return_output : int16_t_stream_t;
begin
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_iffalse := to_unsigned(0, 1);
     VAR_decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_iffalse := to_unsigned(0, 1);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;
     -- Mux in inputs
     VAR_input := input;

     -- Submodule level 0
     VAR_TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_iftrue := VAR_CLOCK_ENABLE;
     VAR_my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_CLOCK_ENABLE := VAR_CLOCK_ENABLE;
     VAR_my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_input := VAR_input;
     -- CONST_REF_RD_uint1_t_int16_t_stream_t_valid_d41d[fir_decim_h_l60_c6_4cb3] LATENCY=0
     VAR_CONST_REF_RD_uint1_t_int16_t_stream_t_valid_d41d_fir_decim_h_l60_c6_4cb3_return_output := VAR_input.valid;

     -- my_fir_fir_samples_window[fir_decim_h_l56_c47_f495] LATENCY=0
     -- Clock enable
     my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_CLOCK_ENABLE <= VAR_my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_CLOCK_ENABLE;
     -- Inputs
     my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_input <= VAR_my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_input;
     -- Outputs
     VAR_my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_return_output := my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_return_output;

     -- Submodule level 1
     VAR_TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_cond := VAR_CONST_REF_RD_uint1_t_int16_t_stream_t_valid_d41d_fir_decim_h_l60_c6_4cb3_return_output;
     VAR_decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_cond := VAR_CONST_REF_RD_uint1_t_int16_t_stream_t_valid_d41d_fir_decim_h_l60_c6_4cb3_return_output;
     -- CONST_REF_RD_int16_t_4_my_fir_fir_samples_window_t_data_d41d[fir_decim_h_l70_c31_930d] LATENCY=0
     VAR_CONST_REF_RD_int16_t_4_my_fir_fir_samples_window_t_data_d41d_fir_decim_h_l70_c31_930d_return_output := VAR_my_fir_fir_samples_window_fir_decim_h_l56_c47_f495_return_output.data;

     -- TRUE_CLOCK_ENABLE_MUX[fir_decim_h_l60_c1_c0f1] LATENCY=0
     -- Inputs
     TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_cond <= VAR_TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_cond;
     TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_iftrue <= VAR_TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_iftrue;
     TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_iffalse <= VAR_TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_iffalse;
     -- Outputs
     VAR_TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_return_output := TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_return_output;

     -- Submodule level 2
     VAR_my_fir_fir_func_fir_decim_h_l70_c15_c9a3_data := VAR_CONST_REF_RD_int16_t_4_my_fir_fir_samples_window_t_data_d41d_fir_decim_h_l70_c31_930d_return_output;
     VAR_my_fir_decim_counter_fir_decim_h_l61_c28_1dbd_CLOCK_ENABLE := VAR_TRUE_CLOCK_ENABLE_MUX_fir_decim_h_l60_c1_c0f1_return_output;
     -- my_fir_decim_counter[fir_decim_h_l61_c28_1dbd] LATENCY=0
     -- Clock enable
     my_fir_decim_counter_fir_decim_h_l61_c28_1dbd_CLOCK_ENABLE <= VAR_my_fir_decim_counter_fir_decim_h_l61_c28_1dbd_CLOCK_ENABLE;
     -- Inputs
     -- Outputs
     VAR_my_fir_decim_counter_fir_decim_h_l61_c28_1dbd_return_output := my_fir_decim_counter_fir_decim_h_l61_c28_1dbd_return_output;

     -- my_fir_fir_func[fir_decim_h_l70_c15_c9a3] LATENCY=0
     -- Inputs
     my_fir_fir_func_fir_decim_h_l70_c15_c9a3_data <= VAR_my_fir_fir_func_fir_decim_h_l70_c15_c9a3_data;
     -- Outputs
     VAR_my_fir_fir_func_fir_decim_h_l70_c15_c9a3_return_output := my_fir_fir_func_fir_decim_h_l70_c15_c9a3_return_output;

     -- Submodule level 3
     VAR_decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_iftrue := VAR_my_fir_decim_counter_fir_decim_h_l61_c28_1dbd_return_output;
     -- decim_count_ellapsed_MUX[fir_decim_h_l60_c3_87f9] LATENCY=0
     -- Inputs
     decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_cond <= VAR_decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_cond;
     decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_iftrue <= VAR_decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_iftrue;
     decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_iffalse <= VAR_decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_iffalse;
     -- Outputs
     VAR_decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_return_output := decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_return_output;

     -- Submodule level 4
     -- CONST_REF_RD_int16_t_stream_t_int16_t_stream_t_1095[fir_decim_h_l73_c10_1df2] LATENCY=0
     VAR_CONST_REF_RD_int16_t_stream_t_int16_t_stream_t_1095_fir_decim_h_l73_c10_1df2_return_output := CONST_REF_RD_int16_t_stream_t_int16_t_stream_t_1095(
     VAR_decim_count_ellapsed_MUX_fir_decim_h_l60_c3_87f9_return_output,
     VAR_my_fir_fir_func_fir_decim_h_l70_c15_c9a3_return_output);

     -- Submodule level 5
     VAR_return_output := VAR_CONST_REF_RD_int16_t_stream_t_int16_t_stream_t_1095_fir_decim_h_l73_c10_1df2_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
