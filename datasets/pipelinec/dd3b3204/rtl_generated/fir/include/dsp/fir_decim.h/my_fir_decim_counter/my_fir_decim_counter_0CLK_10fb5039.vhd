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
-- Submodules: 4
entity my_fir_decim_counter_0CLK_10fb5039 is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 return_output : out unsigned(0 downto 0));
end my_fir_decim_counter_0CLK_10fb5039;
architecture arch of my_fir_decim_counter_0CLK_10fb5039 is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function

-- All user state registers
signal counter : unsigned(4 downto 0) := to_unsigned(0, 5);
signal REG_COMB_counter : unsigned(4 downto 0);

-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
-- BIN_OP_EQ[fir_decim_h_l40_c6_7a82]
signal BIN_OP_EQ_fir_decim_h_l40_c6_7a82_left : unsigned(4 downto 0);
signal BIN_OP_EQ_fir_decim_h_l40_c6_7a82_right : unsigned(0 downto 0);
signal BIN_OP_EQ_fir_decim_h_l40_c6_7a82_return_output : unsigned(0 downto 0);

-- ellapsed_MUX[fir_decim_h_l40_c3_37b1]
signal ellapsed_MUX_fir_decim_h_l40_c3_37b1_cond : unsigned(0 downto 0);
signal ellapsed_MUX_fir_decim_h_l40_c3_37b1_iftrue : unsigned(0 downto 0);
signal ellapsed_MUX_fir_decim_h_l40_c3_37b1_iffalse : unsigned(0 downto 0);
signal ellapsed_MUX_fir_decim_h_l40_c3_37b1_return_output : unsigned(0 downto 0);

-- counter_MUX[fir_decim_h_l40_c3_37b1]
signal counter_MUX_fir_decim_h_l40_c3_37b1_cond : unsigned(0 downto 0);
signal counter_MUX_fir_decim_h_l40_c3_37b1_iftrue : unsigned(4 downto 0);
signal counter_MUX_fir_decim_h_l40_c3_37b1_iffalse : unsigned(4 downto 0);
signal counter_MUX_fir_decim_h_l40_c3_37b1_return_output : unsigned(4 downto 0);

-- BIN_OP_PLUS[fir_decim_h_l44_c5_422f]
signal BIN_OP_PLUS_fir_decim_h_l44_c5_422f_left : unsigned(4 downto 0);
signal BIN_OP_PLUS_fir_decim_h_l44_c5_422f_right : unsigned(0 downto 0);
signal BIN_OP_PLUS_fir_decim_h_l44_c5_422f_return_output : unsigned(5 downto 0);


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_EQ_fir_decim_h_l40_c6_7a82 : 0 clocks latency
BIN_OP_EQ_fir_decim_h_l40_c6_7a82 : entity work.BIN_OP_EQ_uint5_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_EQ_fir_decim_h_l40_c6_7a82_left,
BIN_OP_EQ_fir_decim_h_l40_c6_7a82_right,
BIN_OP_EQ_fir_decim_h_l40_c6_7a82_return_output);

-- ellapsed_MUX_fir_decim_h_l40_c3_37b1 : 0 clocks latency
ellapsed_MUX_fir_decim_h_l40_c3_37b1 : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
ellapsed_MUX_fir_decim_h_l40_c3_37b1_cond,
ellapsed_MUX_fir_decim_h_l40_c3_37b1_iftrue,
ellapsed_MUX_fir_decim_h_l40_c3_37b1_iffalse,
ellapsed_MUX_fir_decim_h_l40_c3_37b1_return_output);

-- counter_MUX_fir_decim_h_l40_c3_37b1 : 0 clocks latency
counter_MUX_fir_decim_h_l40_c3_37b1 : entity work.MUX_uint1_t_uint5_t_uint5_t_0CLK_de264c78 port map (
counter_MUX_fir_decim_h_l40_c3_37b1_cond,
counter_MUX_fir_decim_h_l40_c3_37b1_iftrue,
counter_MUX_fir_decim_h_l40_c3_37b1_iffalse,
counter_MUX_fir_decim_h_l40_c3_37b1_return_output);

-- BIN_OP_PLUS_fir_decim_h_l44_c5_422f : 0 clocks latency
BIN_OP_PLUS_fir_decim_h_l44_c5_422f : entity work.BIN_OP_PLUS_uint5_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_PLUS_fir_decim_h_l44_c5_422f_left,
BIN_OP_PLUS_fir_decim_h_l44_c5_422f_right,
BIN_OP_PLUS_fir_decim_h_l44_c5_422f_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Registers
 counter,
 -- All submodule outputs
 BIN_OP_EQ_fir_decim_h_l40_c6_7a82_return_output,
 ellapsed_MUX_fir_decim_h_l40_c3_37b1_return_output,
 counter_MUX_fir_decim_h_l40_c3_37b1_return_output,
 BIN_OP_PLUS_fir_decim_h_l44_c5_422f_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : unsigned(0 downto 0);
 variable VAR_ellapsed : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_fir_decim_h_l40_c6_7a82_left : unsigned(4 downto 0);
 variable VAR_BIN_OP_EQ_fir_decim_h_l40_c6_7a82_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_fir_decim_h_l40_c6_7a82_return_output : unsigned(0 downto 0);
 variable VAR_ellapsed_MUX_fir_decim_h_l40_c3_37b1_iftrue : unsigned(0 downto 0);
 variable VAR_ellapsed_MUX_fir_decim_h_l40_c3_37b1_iffalse : unsigned(0 downto 0);
 variable VAR_ellapsed_MUX_fir_decim_h_l40_c3_37b1_return_output : unsigned(0 downto 0);
 variable VAR_ellapsed_MUX_fir_decim_h_l40_c3_37b1_cond : unsigned(0 downto 0);
 variable VAR_counter_MUX_fir_decim_h_l40_c3_37b1_iftrue : unsigned(4 downto 0);
 variable VAR_counter_MUX_fir_decim_h_l40_c3_37b1_iffalse : unsigned(4 downto 0);
 variable VAR_counter_fir_decim_h_l44_c5_6c98 : unsigned(4 downto 0);
 variable VAR_counter_MUX_fir_decim_h_l40_c3_37b1_return_output : unsigned(4 downto 0);
 variable VAR_counter_MUX_fir_decim_h_l40_c3_37b1_cond : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_fir_decim_h_l44_c5_422f_left : unsigned(4 downto 0);
 variable VAR_BIN_OP_PLUS_fir_decim_h_l44_c5_422f_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_fir_decim_h_l44_c5_422f_return_output : unsigned(5 downto 0);
 -- State registers comb logic variables
variable REG_VAR_counter : unsigned(4 downto 0);
begin

  -- STATE REGS
  -- Default read regs into vars
  REG_VAR_counter := counter;
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_counter_MUX_fir_decim_h_l40_c3_37b1_iftrue := to_unsigned(0, 5);
     VAR_BIN_OP_EQ_fir_decim_h_l40_c6_7a82_right := to_unsigned(1, 1);
     VAR_ellapsed_MUX_fir_decim_h_l40_c3_37b1_iftrue := to_unsigned(1, 1);
     VAR_BIN_OP_PLUS_fir_decim_h_l44_c5_422f_right := to_unsigned(1, 1);
     VAR_ellapsed_MUX_fir_decim_h_l40_c3_37b1_iffalse := to_unsigned(0, 1);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_BIN_OP_EQ_fir_decim_h_l40_c6_7a82_left := counter;
     VAR_BIN_OP_PLUS_fir_decim_h_l44_c5_422f_left := counter;
     -- BIN_OP_EQ[fir_decim_h_l40_c6_7a82] LATENCY=0
     -- Inputs
     BIN_OP_EQ_fir_decim_h_l40_c6_7a82_left <= VAR_BIN_OP_EQ_fir_decim_h_l40_c6_7a82_left;
     BIN_OP_EQ_fir_decim_h_l40_c6_7a82_right <= VAR_BIN_OP_EQ_fir_decim_h_l40_c6_7a82_right;
     -- Outputs
     VAR_BIN_OP_EQ_fir_decim_h_l40_c6_7a82_return_output := BIN_OP_EQ_fir_decim_h_l40_c6_7a82_return_output;

     -- BIN_OP_PLUS[fir_decim_h_l44_c5_422f] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_fir_decim_h_l44_c5_422f_left <= VAR_BIN_OP_PLUS_fir_decim_h_l44_c5_422f_left;
     BIN_OP_PLUS_fir_decim_h_l44_c5_422f_right <= VAR_BIN_OP_PLUS_fir_decim_h_l44_c5_422f_right;
     -- Outputs
     VAR_BIN_OP_PLUS_fir_decim_h_l44_c5_422f_return_output := BIN_OP_PLUS_fir_decim_h_l44_c5_422f_return_output;

     -- Submodule level 1
     VAR_counter_MUX_fir_decim_h_l40_c3_37b1_cond := VAR_BIN_OP_EQ_fir_decim_h_l40_c6_7a82_return_output;
     VAR_ellapsed_MUX_fir_decim_h_l40_c3_37b1_cond := VAR_BIN_OP_EQ_fir_decim_h_l40_c6_7a82_return_output;
     VAR_counter_fir_decim_h_l44_c5_6c98 := resize(VAR_BIN_OP_PLUS_fir_decim_h_l44_c5_422f_return_output, 5);
     VAR_counter_MUX_fir_decim_h_l40_c3_37b1_iffalse := VAR_counter_fir_decim_h_l44_c5_6c98;
     -- counter_MUX[fir_decim_h_l40_c3_37b1] LATENCY=0
     -- Inputs
     counter_MUX_fir_decim_h_l40_c3_37b1_cond <= VAR_counter_MUX_fir_decim_h_l40_c3_37b1_cond;
     counter_MUX_fir_decim_h_l40_c3_37b1_iftrue <= VAR_counter_MUX_fir_decim_h_l40_c3_37b1_iftrue;
     counter_MUX_fir_decim_h_l40_c3_37b1_iffalse <= VAR_counter_MUX_fir_decim_h_l40_c3_37b1_iffalse;
     -- Outputs
     VAR_counter_MUX_fir_decim_h_l40_c3_37b1_return_output := counter_MUX_fir_decim_h_l40_c3_37b1_return_output;

     -- ellapsed_MUX[fir_decim_h_l40_c3_37b1] LATENCY=0
     -- Inputs
     ellapsed_MUX_fir_decim_h_l40_c3_37b1_cond <= VAR_ellapsed_MUX_fir_decim_h_l40_c3_37b1_cond;
     ellapsed_MUX_fir_decim_h_l40_c3_37b1_iftrue <= VAR_ellapsed_MUX_fir_decim_h_l40_c3_37b1_iftrue;
     ellapsed_MUX_fir_decim_h_l40_c3_37b1_iffalse <= VAR_ellapsed_MUX_fir_decim_h_l40_c3_37b1_iffalse;
     -- Outputs
     VAR_ellapsed_MUX_fir_decim_h_l40_c3_37b1_return_output := ellapsed_MUX_fir_decim_h_l40_c3_37b1_return_output;

     -- Submodule level 2
     REG_VAR_counter := VAR_counter_MUX_fir_decim_h_l40_c3_37b1_return_output;
     VAR_return_output := VAR_ellapsed_MUX_fir_decim_h_l40_c3_37b1_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

-- Write regs vars to comb logic
REG_COMB_counter <= REG_VAR_counter;
end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
 if clk_en_internal='1' then
     counter <= REG_COMB_counter;
 end if;
 end if;
end process;

end arch;
