library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ascii_bcd is
    port (
        input_ascii_x, input_ascii_y: in std_logic_vector(31 downto 0);
        output_bcd_x, output_bcd_y: out std_logic_vector(15 downto 0)
    );
end ascii_bcd;

architecture behavioral of ascii_bcd is
begin
    process(input_ascii_x, input_ascii_y)
        variable bcd_temp_x: std_logic_vector(15 downto 0);
        variable bcd_temp_y: std_logic_vector(15 downto 0);

    begin

        bcd_temp_x(15 downto 12) := input_ascii_x(27 downto 24);
        bcd_temp_x(11 downto 8)  := input_ascii_x(19 downto 16);
        bcd_temp_x(7 downto 4)   := input_ascii_x(11 downto 8);
        bcd_temp_x(3 downto 0)   := input_ascii_x(3 downto 0);

        output_bcd_x <= bcd_temp_x;

        bcd_temp_y(15 downto 12) := input_ascii_y(27 downto 24);
        bcd_temp_y(11 downto 8)  := input_ascii_y(19 downto 16);
        bcd_temp_y(7 downto 4)   := input_ascii_y(11 downto 8);
        bcd_temp_y(3 downto 0)   := input_ascii_y(3 downto 0);

        output_bcd_y <= bcd_temp_y;
    end process;
end behavioral;
