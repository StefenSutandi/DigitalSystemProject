library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_ascii is
    port (
        bcd_input: in std_logic_vector(3 downto 0); -- Input BCD from mux
        ascii_output: out std_logic_vector(7 downto 0) -- Output ASCII
    );
end entity bcd_ascii;

architecture behavioral of bcd_ascii is
begin
    process(bcd_input)
        variable bcd_value: natural range 0 to 9;
    begin
        -- BCD to ASCII Conversion
        bcd_value := to_integer(unsigned(bcd_input));
        
        case bcd_value is
            when 0 to 9 =>  -- BCD values for 0 to 9
                ascii_output <= std_logic_vector(to_unsigned(bcd_value + 48, 8));  -- Convert BCD to ASCII
            when others =>
                ascii_output <= "00000000";  -- Output '0' for invalid BCD characters
        end case;
    end process;
end architecture behavioral;