library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ascii_bcdo is
    port (
        input_ascii: in std_logic_vector(31 downto 0);
        output_bcd: out std_logic_vector(15 downto 0)
    );
end ascii_bcdo;

architecture behavioral of ascii_bcd is
begin
    process(input_ascii)
        variable bcd_temp: std_logic_vector(15 downto 0);
    begin

        bcd_temp(15 downto 12) := input_ascii(27 downto 24);
        bcd_temp(11 downto 8)  := input_ascii(19 downto 16);
        bcd_temp(7 downto 4)   := input_ascii(11 downto 8);
        bcd_temp(3 downto 0)   := input_ascii(3 downto 0);

        output_bcd <= bcd_temp;
    end process;
end behavioral;
