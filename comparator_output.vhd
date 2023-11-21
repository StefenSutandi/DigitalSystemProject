library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator_output is
    port (
        bcd_input: in std_logic_vector(3 downto 0); -- Input BCD from mux
        ascii_output: out std_logic_vector(7 downto 0); -- Output ASCII
        error_flag: out std_logic  -- Output error flag
    );
end entity comparator_output;

architecture behavioral of comparator_output is
begin
    process(bcd_input)
        variable bcd_value: natural range 0 to 15;
    begin
        -- BCD to ASCII Conversion
        bcd_value := to_integer(unsigned(bcd_input));

        -- Comparison logic 
        if (bcd_value > 12) then
            ascii_output <= "00000000"; -- Output '0' for invalid BCD characters
            error_flag <= '1';  -- Set error flag if BCD value is greater than 12
        else
            ascii_output <= std_logic_vector(to_unsigned(bcd_value + 48, 8));  -- Convert BCD to ASCII
            error_flag <= '0';  -- Clear error flag for valid BCD characters
        end if;
        
        -- Check for value greater than 999_999_999
        if (to_integer(unsigned(bcd_input)) > 999_999_999) then
            error_flag <= '1';  -- Set error flag if input is greater than 999_999_999
        end if;
    end process;
end behavioral;