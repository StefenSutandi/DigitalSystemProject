library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.numeric_std.all;

entity adder is
    port (
        x: in integer range 0 to 999_999_999_999; -- Maximum 12-digit input
        y: in integer range 0 to 999_999_999_999;
        sum_bcd: out std_logic_vector(47 downto 0);
        carry_out: out std_logic
    );
end entity adder;

architecture behavioral of adder is
    signal x_bcd, y_bcd: std_logic_vector(47 downto 0);
    signal sum_bcd: std_logic_vector(47 downto 0);
    signal carry: std_logic := '0';
    signal temp_carry: std_logic;
    constant overflow_BCD : std_logic_vector(3 downto 0) := "0110";
begin
    -- ASCII to BCD conversion for X and Y
    x_bcd_conversion: entity work.ascii_bcd
        port map (
            ascii_input => x,
            bcd_output => x_bcd
        );

    y_bcd_conversion: entity work.ascii_bcd
        port map (
            ascii_input => y,
            bcd_output => y_bcd
        );

    -- Adder in BCD field with carry propagation
    process(x_bcd, y_bcd)
        variable temp_sum: integer;
        variable temp_result: std_logic_vector(47 downto 0);
    begin
        temp_sum := to_integer(unsigned(x_bcd)) + to_integer(unsigned(y_bcd)) + to_integer(carry);
        
        if temp_sum < 10 then
            temp_result <= std_logic_vector(to_unsigned(temp_sum, 48)); -- Adjust the size for 12 digits
            temp_carry <= '0';
        else
            temp_result <= std_logic_vector(to_unsigned(temp_sum - 10, 48));  -- Adjust the size for 12 digits
            temp_carry <= '1';
        end if;

        -- Add carry from the previous stage
        temp_sum := to_integer(unsigned(temp_result(43 downto 0))) + to_integer(unsigned(overflow_BCD));
        
        if temp_sum < 10 then
            sum_bcd <= temp_result(47 downto 4) & std_logic_vector(to_unsigned(temp_sum, 4));
            carry <= temp_carry;
        else
            sum_bcd <= temp_result(47 downto 4) & std_logic_vector(to_unsigned(temp_sum - 10, 4));  -- Adjust the size for 12 digits
            carry <= '1';
        end if;
    end process;

    carry_out <= carry;
    sum_bcd_output <= sum_bcd;
end architecture behavioral;
