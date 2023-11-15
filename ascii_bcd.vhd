library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ascii_bcd is
    port (
        ascii_input: in std_logic_vector(7 downto 0);
        bcd_output: out std_logic_vector(3 downto 0)
    );
end entity ascii_bcd;

architecture behavioral of ascii_bcd is
begin   
    process(ascii_input)
        variable digit: integer;
    begin
        digit := to_integer(unsigned(ascii_input));

        case digit is
            when 48 to 57 =>  -- ASCII values for '0' to '9'
                bcd_output <= std_logic_vector(to_unsigned(digit - 48, 4));  -- Convert ASCII to BCD
            when others =>
                bcd_output <= "0000";  -- Output '0000' for invalid ASCII characters
        end case;
    end process;
end architecture behavioral;