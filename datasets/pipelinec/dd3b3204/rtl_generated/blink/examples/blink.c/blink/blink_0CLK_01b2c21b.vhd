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
-- Submodules: 5
entity blink_0CLK_01b2c21b is
port(
 clk : in std_logic;
 CLOCK_ENABLE : in unsigned(0 downto 0);
 return_output : out unsigned(0 downto 0));
end blink_0CLK_01b2c21b;
architecture arch of blink_0CLK_01b2c21b is
-- Types and such
-- Declarations
attribute mark_debug : string;
constant ADDED_PIPELINE_LATENCY : integer := 0;
-- All of the wires/regs in function

-- All user state registers
signal counter : unsigned(24 downto 0) := to_unsigned(0, 25);
signal led : unsigned(0 downto 0) := to_unsigned(0, 1);
signal REG_COMB_counter : unsigned(24 downto 0);
signal REG_COMB_led : unsigned(0 downto 0);

-- Resolved maybe from input reg clock enable
signal clk_en_internal : std_logic;
-- Each function instance gets signals
-- BIN_OP_EQ[blink_c_l20_c6_31d2]
signal BIN_OP_EQ_blink_c_l20_c6_31d2_left : unsigned(24 downto 0);
signal BIN_OP_EQ_blink_c_l20_c6_31d2_right : unsigned(24 downto 0);
signal BIN_OP_EQ_blink_c_l20_c6_31d2_return_output : unsigned(0 downto 0);

-- counter_MUX[blink_c_l20_c3_d27f]
signal counter_MUX_blink_c_l20_c3_d27f_cond : unsigned(0 downto 0);
signal counter_MUX_blink_c_l20_c3_d27f_iftrue : unsigned(24 downto 0);
signal counter_MUX_blink_c_l20_c3_d27f_iffalse : unsigned(24 downto 0);
signal counter_MUX_blink_c_l20_c3_d27f_return_output : unsigned(24 downto 0);

-- led_MUX[blink_c_l20_c3_d27f]
signal led_MUX_blink_c_l20_c3_d27f_cond : unsigned(0 downto 0);
signal led_MUX_blink_c_l20_c3_d27f_iftrue : unsigned(0 downto 0);
signal led_MUX_blink_c_l20_c3_d27f_iffalse : unsigned(0 downto 0);
signal led_MUX_blink_c_l20_c3_d27f_return_output : unsigned(0 downto 0);

-- UNARY_OP_NOT[blink_c_l23_c12_6e43]
signal UNARY_OP_NOT_blink_c_l23_c12_6e43_expr : unsigned(0 downto 0);
signal UNARY_OP_NOT_blink_c_l23_c12_6e43_return_output : unsigned(0 downto 0);

-- BIN_OP_PLUS[blink_c_l29_c5_6d96]
signal BIN_OP_PLUS_blink_c_l29_c5_6d96_left : unsigned(24 downto 0);
signal BIN_OP_PLUS_blink_c_l29_c5_6d96_right : unsigned(0 downto 0);
signal BIN_OP_PLUS_blink_c_l29_c5_6d96_return_output : unsigned(25 downto 0);


begin

-- SUBMODULE INSTANCES 
-- BIN_OP_EQ_blink_c_l20_c6_31d2 : 0 clocks latency
BIN_OP_EQ_blink_c_l20_c6_31d2 : entity work.BIN_OP_EQ_uint25_t_uint25_t_0CLK_de264c78 port map (
BIN_OP_EQ_blink_c_l20_c6_31d2_left,
BIN_OP_EQ_blink_c_l20_c6_31d2_right,
BIN_OP_EQ_blink_c_l20_c6_31d2_return_output);

-- counter_MUX_blink_c_l20_c3_d27f : 0 clocks latency
counter_MUX_blink_c_l20_c3_d27f : entity work.MUX_uint1_t_uint25_t_uint25_t_0CLK_de264c78 port map (
counter_MUX_blink_c_l20_c3_d27f_cond,
counter_MUX_blink_c_l20_c3_d27f_iftrue,
counter_MUX_blink_c_l20_c3_d27f_iffalse,
counter_MUX_blink_c_l20_c3_d27f_return_output);

-- led_MUX_blink_c_l20_c3_d27f : 0 clocks latency
led_MUX_blink_c_l20_c3_d27f : entity work.MUX_uint1_t_uint1_t_uint1_t_0CLK_de264c78 port map (
led_MUX_blink_c_l20_c3_d27f_cond,
led_MUX_blink_c_l20_c3_d27f_iftrue,
led_MUX_blink_c_l20_c3_d27f_iffalse,
led_MUX_blink_c_l20_c3_d27f_return_output);

-- UNARY_OP_NOT_blink_c_l23_c12_6e43 : 0 clocks latency
UNARY_OP_NOT_blink_c_l23_c12_6e43 : entity work.UNARY_OP_NOT_uint1_t_0CLK_de264c78 port map (
UNARY_OP_NOT_blink_c_l23_c12_6e43_expr,
UNARY_OP_NOT_blink_c_l23_c12_6e43_return_output);

-- BIN_OP_PLUS_blink_c_l29_c5_6d96 : 0 clocks latency
BIN_OP_PLUS_blink_c_l29_c5_6d96 : entity work.BIN_OP_PLUS_uint25_t_uint1_t_0CLK_de264c78 port map (
BIN_OP_PLUS_blink_c_l29_c5_6d96_left,
BIN_OP_PLUS_blink_c_l29_c5_6d96_right,
BIN_OP_PLUS_blink_c_l29_c5_6d96_return_output);



-- Resolve what clock enable to use for user logic
clk_en_internal <= CLOCK_ENABLE(0);
-- Combinatorial process for pipeline stages
process (
CLOCK_ENABLE,
clk_en_internal,
 -- Registers
 counter,
 led,
 -- All submodule outputs
 BIN_OP_EQ_blink_c_l20_c6_31d2_return_output,
 counter_MUX_blink_c_l20_c3_d27f_return_output,
 led_MUX_blink_c_l20_c3_d27f_return_output,
 UNARY_OP_NOT_blink_c_l23_c12_6e43_return_output,
 BIN_OP_PLUS_blink_c_l29_c5_6d96_return_output)
is 
 -- All of the wires in function
 variable VAR_CLOCK_ENABLE : unsigned(0 downto 0);
 variable VAR_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_EQ_blink_c_l20_c6_31d2_left : unsigned(24 downto 0);
 variable VAR_BIN_OP_EQ_blink_c_l20_c6_31d2_right : unsigned(24 downto 0);
 variable VAR_BIN_OP_EQ_blink_c_l20_c6_31d2_return_output : unsigned(0 downto 0);
 variable VAR_counter_MUX_blink_c_l20_c3_d27f_iftrue : unsigned(24 downto 0);
 variable VAR_counter_MUX_blink_c_l20_c3_d27f_iffalse : unsigned(24 downto 0);
 variable VAR_counter_blink_c_l29_c5_39a3 : unsigned(24 downto 0);
 variable VAR_counter_MUX_blink_c_l20_c3_d27f_return_output : unsigned(24 downto 0);
 variable VAR_counter_MUX_blink_c_l20_c3_d27f_cond : unsigned(0 downto 0);
 variable VAR_led_MUX_blink_c_l20_c3_d27f_iftrue : unsigned(0 downto 0);
 variable VAR_led_MUX_blink_c_l20_c3_d27f_iffalse : unsigned(0 downto 0);
 variable VAR_led_MUX_blink_c_l20_c3_d27f_return_output : unsigned(0 downto 0);
 variable VAR_led_MUX_blink_c_l20_c3_d27f_cond : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_blink_c_l23_c12_6e43_expr : unsigned(0 downto 0);
 variable VAR_UNARY_OP_NOT_blink_c_l23_c12_6e43_return_output : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_blink_c_l29_c5_6d96_left : unsigned(24 downto 0);
 variable VAR_BIN_OP_PLUS_blink_c_l29_c5_6d96_right : unsigned(0 downto 0);
 variable VAR_BIN_OP_PLUS_blink_c_l29_c5_6d96_return_output : unsigned(25 downto 0);
 -- State registers comb logic variables
variable REG_VAR_counter : unsigned(24 downto 0);
variable REG_VAR_led : unsigned(0 downto 0);
begin

  -- STATE REGS
  -- Default read regs into vars
  REG_VAR_counter := counter;
  REG_VAR_led := led;
 -- Constants and things derived from constants alone
     -- Submodule level 0
     VAR_counter_MUX_blink_c_l20_c3_d27f_iftrue := to_unsigned(0, 25);
     VAR_BIN_OP_PLUS_blink_c_l29_c5_6d96_right := to_unsigned(1, 1);
     VAR_BIN_OP_EQ_blink_c_l20_c6_31d2_right := to_unsigned(33333332, 25);

 -- Loop to construct simultaneous register transfers for each of the pipeline stages
 -- LATENCY=0 is combinational Logic
 for STAGE in 0 to ADDED_PIPELINE_LATENCY loop
   if STAGE = 0 then
     -- Mux in clock enable
     VAR_CLOCK_ENABLE(0) := clk_en_internal;

     -- Submodule level 0
     VAR_BIN_OP_EQ_blink_c_l20_c6_31d2_left := counter;
     VAR_BIN_OP_PLUS_blink_c_l29_c5_6d96_left := counter;
     VAR_UNARY_OP_NOT_blink_c_l23_c12_6e43_expr := led;
     VAR_led_MUX_blink_c_l20_c3_d27f_iffalse := led;
     -- BIN_OP_EQ[blink_c_l20_c6_31d2] LATENCY=0
     -- Inputs
     BIN_OP_EQ_blink_c_l20_c6_31d2_left <= VAR_BIN_OP_EQ_blink_c_l20_c6_31d2_left;
     BIN_OP_EQ_blink_c_l20_c6_31d2_right <= VAR_BIN_OP_EQ_blink_c_l20_c6_31d2_right;
     -- Outputs
     VAR_BIN_OP_EQ_blink_c_l20_c6_31d2_return_output := BIN_OP_EQ_blink_c_l20_c6_31d2_return_output;

     -- BIN_OP_PLUS[blink_c_l29_c5_6d96] LATENCY=0
     -- Inputs
     BIN_OP_PLUS_blink_c_l29_c5_6d96_left <= VAR_BIN_OP_PLUS_blink_c_l29_c5_6d96_left;
     BIN_OP_PLUS_blink_c_l29_c5_6d96_right <= VAR_BIN_OP_PLUS_blink_c_l29_c5_6d96_right;
     -- Outputs
     VAR_BIN_OP_PLUS_blink_c_l29_c5_6d96_return_output := BIN_OP_PLUS_blink_c_l29_c5_6d96_return_output;

     -- UNARY_OP_NOT[blink_c_l23_c12_6e43] LATENCY=0
     -- Inputs
     UNARY_OP_NOT_blink_c_l23_c12_6e43_expr <= VAR_UNARY_OP_NOT_blink_c_l23_c12_6e43_expr;
     -- Outputs
     VAR_UNARY_OP_NOT_blink_c_l23_c12_6e43_return_output := UNARY_OP_NOT_blink_c_l23_c12_6e43_return_output;

     -- Submodule level 1
     VAR_counter_MUX_blink_c_l20_c3_d27f_cond := VAR_BIN_OP_EQ_blink_c_l20_c6_31d2_return_output;
     VAR_led_MUX_blink_c_l20_c3_d27f_cond := VAR_BIN_OP_EQ_blink_c_l20_c6_31d2_return_output;
     VAR_counter_blink_c_l29_c5_39a3 := resize(VAR_BIN_OP_PLUS_blink_c_l29_c5_6d96_return_output, 25);
     VAR_led_MUX_blink_c_l20_c3_d27f_iftrue := VAR_UNARY_OP_NOT_blink_c_l23_c12_6e43_return_output;
     VAR_counter_MUX_blink_c_l20_c3_d27f_iffalse := VAR_counter_blink_c_l29_c5_39a3;
     -- counter_MUX[blink_c_l20_c3_d27f] LATENCY=0
     -- Inputs
     counter_MUX_blink_c_l20_c3_d27f_cond <= VAR_counter_MUX_blink_c_l20_c3_d27f_cond;
     counter_MUX_blink_c_l20_c3_d27f_iftrue <= VAR_counter_MUX_blink_c_l20_c3_d27f_iftrue;
     counter_MUX_blink_c_l20_c3_d27f_iffalse <= VAR_counter_MUX_blink_c_l20_c3_d27f_iffalse;
     -- Outputs
     VAR_counter_MUX_blink_c_l20_c3_d27f_return_output := counter_MUX_blink_c_l20_c3_d27f_return_output;

     -- led_MUX[blink_c_l20_c3_d27f] LATENCY=0
     -- Inputs
     led_MUX_blink_c_l20_c3_d27f_cond <= VAR_led_MUX_blink_c_l20_c3_d27f_cond;
     led_MUX_blink_c_l20_c3_d27f_iftrue <= VAR_led_MUX_blink_c_l20_c3_d27f_iftrue;
     led_MUX_blink_c_l20_c3_d27f_iffalse <= VAR_led_MUX_blink_c_l20_c3_d27f_iffalse;
     -- Outputs
     VAR_led_MUX_blink_c_l20_c3_d27f_return_output := led_MUX_blink_c_l20_c3_d27f_return_output;

     -- Submodule level 2
     REG_VAR_counter := VAR_counter_MUX_blink_c_l20_c3_d27f_return_output;
     REG_VAR_led := VAR_led_MUX_blink_c_l20_c3_d27f_return_output;
     VAR_return_output := VAR_led_MUX_blink_c_l20_c3_d27f_return_output;
     -- Last stage of pipeline return wire to return port/reg
     return_output <= VAR_return_output;
   end if;
 end loop;

-- Write regs vars to comb logic
REG_COMB_counter <= REG_VAR_counter;
REG_COMB_led <= REG_VAR_led;
end process;

-- Register comb signals
process(clk) is
begin
 if rising_edge(clk) then
 if clk_en_internal='1' then
     counter <= REG_COMB_counter;
     led <= REG_COMB_led;
 end if;
 end if;
end process;

end arch;
