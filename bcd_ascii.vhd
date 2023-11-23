library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_ascii is
    port (
        bcd_x_input: in std_logic_vector(47 downto 0); -- Input BCD (12-digit x 4-bit each)
        bcd_y_input: in std_logic_vector(47 downto 0); -- Input BCD (12-digit x 4-bit each)
        ascii_x_output: out std_logic_vector(47 downto 0); -- Output ASCII (48-bit)
        ascii_y_output: out std_logic_vector(47 downto 0) -- Output ASCII (48-bit)
    );
end entity bcd_ascii;

architecture behavioral of bcd_ascii is
begin
    process(bcd_x_input, bcd_y_input)
        variable temp_x_ascii: std_logic_vector(3 downto 0); -- Temporary variable x for 4-bit ASCII
        variable temp_y_ascii: std_logic_vector(3 downto 0); -- Temporary variable y for 4-bit ASCII
    begin
        for i in 0 to 11 loop -- Loop through 12 sets of 4-bit BCD in 48 bits
            temp_x_ascii := "0000"; -- Initialize temporary ASCII variable x value
            temp_y_ascii := "0000"; -- Initialize temporary ASCII variable y value

            -- Convert BCD to ASCII for each digit (4 bits)
            case bcd_x_input(i * 4 + 3 downto i * 4) is
                when "0000" to "1001" =>  -- BCD values for '0' to '9'
                    temp_x_ascii := std_logic_vector(unsigned(bcd_x_input(i * 4 + 3 downto i * 4)) + "0011");  -- Convert BCD to ASCII
                when others =>
                    temp_x_ascii := "0000";  -- Output '0000' for invalid BCD characters
            end case;

            case bcd_y_input(i * 4 + 3 downto i * 4) is
                when "0000" to "1001" =>  -- BCD values for '0' to '9'
                    temp_y_ascii := std_logic_vector(unsigned(bcd_y_input(i * 4 + 3 downto i * 4)) + "0011");  -- Convert BCD to ASCII
                when others =>
                    temp_y_ascii := "0000";  -- Output '0000' for invalid BCD characters
            end case;
            
            -- Assign the temporary ASCII to the corresponding section in the output
            ascii_x_output(i * 4 + 3 downto i * 4) <= temp_x_ascii;
            ascii_y_output(i * 4 + 3 downto i * 4) <= temp_y_ascii;
        end loop;
    end process;
end architecture behavioral;