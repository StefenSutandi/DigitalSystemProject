library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.numeric_std.all;

entity divider is
    Port (
        x: in integer range 0 to 999_999_999_999; 
        y: in integer range 0 to 999_999_999_999;
        error_flag: out std_logic;  -- Output error flag
        output_result: out std_logic_vector(48 downto 0) -- Output result (48-bit + 1 sign bit)
    );
end divider;

architecture Behavioral of divider is
    signal x_bcd, y_bcd, result_bcd: std_logic_vector(48 downto 0); -- BCD conversion for x, y, and result
begin
    process(input_x, input_y, operation, sequential_process)
    begin
        -- Convert input_x and input_y to BCD
        -- tambahin disini

        -- Example error handling logic (modifikasi lagi)
        if (input_x'length > 48 or input_y'length > 48) then
            error_flag <= '1';  -- Set error flag for input exceeding 48 bits
            output_result <= (others => '0');  -- Reset output result
        elsif operation /= "00" then
            error_flag <= '1';  -- Set error flag for invalid operation selection
            output_result <= (others => '0');  -- Reset output result
        else
            error_flag <= '0';  -- Clear error flag for valid conditions

            -- contoh
            if sequential_process = '1' then
                -- Sequential division process
                -- Divide input_x by input_y and store the result in result_bcd
                -- Example: result_bcd <= x_bcd / y_bcd;
            else
                -- Non-sequential division process
                -- Divide input_x by input_y and store the result in result_bcd
                -- Example: result_bcd <= x_bcd / y_bcd;
            end if;

            -- Convert result_bcd to output_result (ASCII)
            -- buat juga disini
        end if;
    end process;
end Behavioral;
