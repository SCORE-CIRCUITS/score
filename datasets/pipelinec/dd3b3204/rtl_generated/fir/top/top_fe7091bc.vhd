library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.c_structs_pkg.all;

  entity top_fe7091bc is
port(
-- All clocks
clk_100p0 : in std_logic;

-- IO for each main func
main_input : in int16_t_stream_t;
main_return_output : out int16_t_stream_t
  );
end top_fe7091bc;
architecture arch of top_fe7091bc is

attribute syn_keep : boolean;
attribute keep : string;
attribute dont_touch : string;

signal main_0CLK_8b9b63e1_input_input_reg : int16_t_stream_t := int16_t_stream_t_NULL;
attribute syn_keep of main_0CLK_8b9b63e1_input_input_reg : signal is true;
attribute keep of main_0CLK_8b9b63e1_input_input_reg : signal is "true";
attribute dont_touch of main_0CLK_8b9b63e1_input_input_reg : signal is "true";

signal main_return_output_output : int16_t_stream_t;
signal main_0CLK_8b9b63e1_return_output_output_reg : int16_t_stream_t;
attribute syn_keep of main_0CLK_8b9b63e1_return_output_output_reg : signal is true;
attribute keep of main_0CLK_8b9b63e1_return_output_output_reg : signal is "true";
attribute dont_touch of main_0CLK_8b9b63e1_return_output_output_reg : signal is "true";


begin

 -- IO regs
 process(clk_100p0) is
 begin
  if rising_edge(clk_100p0) then
   main_0CLK_8b9b63e1_input_input_reg <= main_input;
   main_0CLK_8b9b63e1_return_output_output_reg <= main_return_output_output;
  end if;
 end process;
 main_return_output <= main_0CLK_8b9b63e1_return_output_output_reg;

-- Instantiate each main
-- main functions are always clock enabled, always running
main_0CLK_8b9b63e1 : entity work.main_0CLK_8b9b63e1 port map (
clk_100p0,
to_unsigned(1,1),
main_0CLK_8b9b63e1_input_input_reg,
main_return_output_output);


end arch;
