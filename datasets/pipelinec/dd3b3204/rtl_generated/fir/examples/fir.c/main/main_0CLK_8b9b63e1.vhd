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
-- Submodules: 1
entity main_0CLK_8b9b63e1 is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 input : in int16_t_stream_t;
 return_output : out int16_t_stream_t);
end main_0CLK_8b9b63e1;
architecture arch of main_0CLK_8b9b63e1 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function
-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
-- my_fir[fir_c_l54_c10_7484]
signal my_fir_fir_c_l54_c10_7484_CLOCK_ENABLE : unsigned(0 downto 0);
signal my_fir_fir_c_l54_c10_7484_input : int16_t_stream_t;
signal my_fir_fir_c_l54_c10_7484_return_output : int16_t_stream_t;


begin

-- SUBMODULE INSTANCES 
-- my_fir_fir_c_l54_c10_7484 : 0 clocks latency
my_fir_fir_c_l54_c10_7484 : entity work.my_fir_0CLK_db82ffa6 port map (
clk,
my_fir_fir_c_l54_c10_7484_CLOCK_ENABLE,
my_fir_fir_c_l54_c10_7484_input,
my_fir_fir_c_l54_c10_7484_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Inputs
 input,
 -- All submodule outputs
 my_fir_fir_c_l54_c10_7484_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : int16_t_stream_t;
 variable VAR_input : int16_t_stream_t;
 variable VAR_my_fir_fir_c_l54_c10_7484_input : int16_t_stream_t;
 variable VAR_my_fir_fir_c_l54_c10_7484_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_my_fir_fir_c_l54_c10_7484_return_output : int16_t_stream_t;
begin

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;
     -- Mux in inputs
     VAR_input := input;

     -- Submodule level 0
     VAR_my_fir_fir_c_l54_c10_7484_CLOCK_ENABLE := VAR_CLOCK_ENABLE;
     VAR_my_fir_fir_c_l54_c10_7484_input := VAR_input;
     -- my_fir[fir_c_l54_c10_7484] LATENCY=0
     -- Clock enable
     my_fir_fir_c_l54_c10_7484_CLOCK_ENABLE <= VAR_my_fir_fir_c_l54_c10_7484_CLOCK_ENABLE;
     -- Inputs
     my_fir_fir_c_l54_c10_7484_input <= VAR_my_fir_fir_c_l54_c10_7484_input;
     -- Outputs
     VAR_my_fir_fir_c_l54_c10_7484_return_output := my_fir_fir_c_l54_c10_7484_return_output;

     -- Submodule level 1
     VAR_return_output := VAR_my_fir_fir_c_l54_c10_7484_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

end process;

end arch;
