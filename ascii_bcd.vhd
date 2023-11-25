-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;

-- entity ascii_bcd is
--     port (
--         ascii_x_input: in std_logic_vector(7 downto 0); -- Input x (ASCII)
--         ascii_y_input: in std_logic_vector(7 downto 0); -- Input y (ASCII)
--         bcd_x_output: out std_logic_vector(3 downto 0); -- Output BCD for x
--         bcd_y_output: out std_logic_vector(3 downto 0)  -- Output BCD for y
--     );
-- end entity ascii_bcd;

-- architecture behavioral of ascii_bcd is
--     begin
--         process(ascii_x_input, ascii_y_input)
--         begin
--             -- ASCII to BCD Conversion for x
--             variable x_digit: unsigned(3 downto 0);
--             x_digit := unsigned(ascii_x_input);
--             case x_digit is
--                 when "0011" to "1001" =>  -- ASCII values for '0' to '9'
--                     bcd_x_output <= std_logic_vector(x_digit - "0011");  -- Convert ASCII to BCD
--                 when others =>
--                     bcd_x_output <= "0000";  -- Output '0000' for invalid ASCII characters
--             end case;
        
--             -- ASCII to BCD Conversion for y
--             variable y_digit: unsigned(3 downto 0);
--             y_digit := unsigned(ascii_y_input);
--             case y_digit is
--                 when "0011" to "1001" =>  -- ASCII values for '0' to '9'
--                     bcd_y_output <= std_logic_vector(y_digit - "0011");  -- Convert ASCII to BCD
--                 when others =>
--                     bcd_y_output <= "0000";  -- Output '0000' for invalid ASCII characters
--             end case;
--         end process;
-- end architecture behavioral;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ascii_bcd is
    port (
        ascii_x_input: in std_logic_vector(47 downto 0); -- Input ASCII (48-bit)
        ascii_y_input: in std_logic_vector(47 downto 0); -- Input ASCII (48-bit)
        bcd_x_output: out std_logic_vector(47 downto 0); -- Output BCD (12-digit x 4-bit each)
        bcd_y_output: out std_logic_vector(47 downto 0) -- Output BCD (12-digit x 4-bit each)
    );
end entity ascii_bcd;

architecture behavioral of ascii_bcd is
begin
    process(ascii_x_input, ascii_y_input)
        variable temp_x_bcd: std_logic_vector(3 downto 0); -- Temporary variable x for 4-bit BCD
        variable temp_y_bcd: std_logic_vector(3 downto 0); -- Temporary variable y for 4-bit BCD
    begin
        for i in 0 to 11 loop -- Loop through 12 sets of 4-bit BCD in 48 bits
            temp_x_bcd := "0000"; -- Initialize temporary BCD variable x value
            temp_y_bcd := "0000"; -- Initialize temporary BCD variable y value

            -- Convert ASCII to BCD for each digit (4 bits)
            case ascii_x_input(i * 4 + 3 downto i * 4) and ascii_y_input(i * 4 + 3 downto i * 4) is
                when "0000" to "1001" =>  -- ASCII values for '0' to '9'
                    temp_x_bcd := std_logic_vector(unsigned(ascii_input(i * 4 + 3 downto i * 4)) - "0011");  -- Convert ASCII to BCD
                    temp_y_bcd := std_logic_vector(unsigned(ascii_input(i * 4 + 3 downto i * 4)) - "0011");  -- Convert ASCII to BCD
                when others =>
                    temp_x_bcd := "0000";  -- Output '0000' for invalid ASCII characters
                    temp_y_bcd := "0000";  -- Output '0000' for invalid ASCII characters
            end case;
            
            -- Assign the temporary BCD to the corresponding section in the output
            bcd_x_output(i * 4 + 3 downto i * 4) <= temp_x_bcd;
            bcd_y_output(i * 4 + 3 downto i * 4) <= temp_y_bcd;
        end loop;
    end process;
end architecture behavioral;