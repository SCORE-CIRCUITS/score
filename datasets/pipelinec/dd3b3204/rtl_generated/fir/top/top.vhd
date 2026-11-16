library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;

  entity top is
port(
-- All clocks
clk_100p0 : in std_logic;

-- IO for each main func
main_input : in int16_t_stream_t;
main_return_output : out int16_t_stream_t
  );
end top;
architecture arch of top is

attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;


begin

-- Instantiate each main
-- main functions are always clock enabled, always running
main_0CLK_8b9b63e1 : entity work.main_0CLK_8b9b63e1 port map (
clk_100p0,
to_unsigned(1,1),
main_input,
main_return_output);


end arch;
