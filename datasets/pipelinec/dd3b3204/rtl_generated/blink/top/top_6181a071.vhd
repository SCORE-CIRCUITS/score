library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;

  entity top_6181a071 is
port(
-- All clocks
clk_33p33 : in std_logic;

-- IO for each main func
blink_return_output : out unsigned(0 downto 0)
  );
end top_6181a071;
architecture arch of top_6181a071 is

attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;


signal blink_return_output_output : unsigned(0 downto 0);
signal blink_0CLK_01b2c21b_return_output_output_reg : unsigned(0 downto 0);
attribute syn_keep of blink_0CLK_01b2c21b_return_output_output_reg : signal is true;
attribute keep of blink_0CLK_01b2c21b_return_output_output_reg : signal is "true";
attribute dont_touch of blink_0CLK_01b2c21b_return_output_output_reg : signal is "true";


begin

 -- IO regs
 process(clk_33p33) is
 begin
  if rising_edge(clk_33p33) then
   blink_0CLK_01b2c21b_return_output_output_reg <= blink_return_output_output;
  end if;
 end process;
 blink_return_output <= blink_0CLK_01b2c21b_return_output_output_reg;

-- Instantiate each main
-- main functions are always clock enabled, always running
blink_0CLK_01b2c21b : entity work.blink_0CLK_01b2c21b port map (
clk_33p33,
to_unsigned(1,1),
blink_return_output_output);


end arch;
