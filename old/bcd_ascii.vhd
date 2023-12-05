library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_ascii is
    port (
        bcd_input: in std_logic_vector(47 downto 0); -- Input BCD (12-digit x 4-bit each)
        ascii_output: out std_logic_vector(47 downto 0) -- Output ASCII (48-bit)
    );
end entity bcd_ascii;

architecture behavioral of bcd_ascii is
begin
    process(bcd_input)
        variable temp_ascii: std_logic_vector(3 downto 0); -- Temporary variable x for 4-bit ASCII
    begin
        for i in 0 to 11 loop -- Loop through 12 sets of 4-bit BCD in 48 bits
            temp_ascii := "0000"; -- Initialize temporary ASCII variable x value

            -- Convert BCD to ASCII for each digit (4 bits)
            case bcd_input(i * 4 + 3 downto i * 4) is
                when "0000" to "1001" =>  -- BCD values for '0' to '9'
                    temp_ascii := std_logic_vector(unsigned(bcd_input(i * 4 + 3 downto i * 4)) + "0011");  -- Convert BCD to ASCII
                when others =>
                    temp_ascii := "0000";  -- Output '0000' for invalid BCD characters
            end case;
            
            -- Assign the temporary ASCII to the corresponding section in the output
            ascii_output(i * 4 + 3 downto i * 4) <= temp_ascii;
        end loop;
    end process;
end architecture behavioral;