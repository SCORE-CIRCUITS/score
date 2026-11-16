library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;

  entity top is
port(
-- All clocks
clk_33p33 : in std_logic;

-- IO for each main func
blink_return_output : out unsigned(0 downto 0)
  );
end top;
architecture arch of top is

attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;


begin

-- Instantiate each main
-- main functions are always clock enabled, always running
blink_0CLK_01b2c21b : entity work.blink_0CLK_01b2c21b port map (
clk_33p33,
to_unsigned(1,1),
blink_return_output);


end arch;
