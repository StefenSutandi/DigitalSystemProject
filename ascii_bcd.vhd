library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_ascii is
    port(
        bcd_input: in std_logic_vector(7 downto 0);
        ascii_output: out std_logic_vector(3 downto 0)
    );
end bcd_ascii

architecture behavioral of bcd_ascii is
begin   
    process(bcd_input)
        variable : integer
    begin
        digit := to_integer (unsigned(bcd_input))

        case digit is
            when 0 to 9 =>
                ascii_output <= std_logic_vector(to_unsigned( digit + 48, 8));
            when others =>
                ascii_output <= '000000000'
        
        end case;
    end process;
end behavioral;
    