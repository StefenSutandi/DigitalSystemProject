library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
use IEEE.numeric_std.all;

entity multiplierbin is
    port (
        x_bin: in std_logic_vector(4 downto 0);
        y_bin: in std_logic_vector(4 downto 0);
        multiplier_out: out std_logic_vector(9 downto 0)
    );
end entity multiplierbin;

architecture behavioral of multiplierbin is
    signal temp_multi: std_logic_vector(9 downto 0);
    constant y: integer
begin
process(x_bin, y_bin)

y <= to integer(unsigned(y_bin))

begin
    for i in 0 to y loop
        temp_multi <= temp_multi + x_bin ;
        end loop;

multiplier_out <= temp_mugitlti;

    end process;
end architecture behavioral;

