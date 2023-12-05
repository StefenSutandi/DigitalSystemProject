library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator_output is
	generic (
		DATA_WIDTH_ASCII : positive := 32;
		DATA_WIDTH_BCD : positive := 16;
		DATA_WIDTH_BIN : positive := 14
	);
    port (
        x : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0); -- Input BCD from mux (48 + 1 bits for sign)
--      ascii_output: out std_logic_vector(15 downto 0); -- Output ASCII (+1 for sign bit)
        error_flag: out std_logic  -- Output error flag
    );
end entity comparator_output;

architecture behavioral of comparator_output is
--  signal bcd_value: unsigned(15 downto 0); -- BCD value (48 bits)

begin
    process(X)
    begin
/*      -- Check for invalid BCD input length (more than 48 + 1 bits)
        if bcd_input'length > 49 then
            ascii_output <= "000000000"; -- Output '0' for invalid BCD characters (+1 for sign bit)
            error_flag <= 'ERROR';  -- Set error flag for BCD input length greater than 48 + 1 bits
        else
            -- Extract BCD value if input length is valid
            bcd_value <= bcd_input(15 downto 0); -- Extracting the BCD value (ignoring sign bit)

            -- Convert BCD to ASCII and include the sign bit
            if (bcd_input(48) = '1') then
                ascii_output <= "000000000"; -- Output '0' for negative BCD values (+1 for sign bit)
                error_flag <= 'ERROR';  -- Set error flag for negative BCD values
            else
                -- Perform the conversion for valid positive BCD values
                if (to_integer(bcd_value) > 999_999_999) then
                    -- Check for value greater than 999_999_999
                    ascii_output <= "000000000"; -- Output '0' for invalid BCD characters (+1 for sign bit)
                    error_flag <= 'ERROR';  -- Set error flag if input is greater than 999_999_999
                else
                    ascii_output <= std_logic_vector(to_unsigned(to_integer(bcd_value) + 48, 8)) & '0';
                    -- Convert BCD to ASCII and include the sign bit
                    error_flag <= '0';  -- Clear error flag for valid BCD characters
                end if;
            end if;
        end if;
*/
		if x'length > DATA_WIDTH_ASCII then
			error_flag <= '1';
		else
			error_flag <= '0';
		end if;
    end process;
end behavioral;