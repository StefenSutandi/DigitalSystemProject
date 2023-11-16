library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.numeric_std.all;

entity adder is
    port (
        x: in std_logic_vector(7 downto 0);
        y: in std_logic_vector(7 downto 0);
        sum: out std_logic_vector(3 downto 0);
        carry_out: out std_logic
    );
end entity adder;

architecture behavioral of adder is
    signal x_bcd, y_bcd: std_logic_vector(3 downto 0);
    signal sum_bcd: std_logic_vector(3 downto 0);
    signal carry: std_logic := '0';
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

    -- Adder in BCD field
    process(x_bcd, y_bcd)
        variable temp_sum: integer;
    begin
        temp_sum := to_integer(unsigned(x_bcd)) + to_integer(unsigned(y_bcd)) + to_integer(carry);
        
        if temp_sum < 10 then
            sum_bcd <= std_logic_vector(to_unsigned(temp_sum, 4));
            carry <= '0';
        else
            sum_bcd <= std_logic_vector(to_unsigned(temp_sum - 10 + 6, 4));  -- Add 0110 for overflow BCD to give it 1 digit to next BCD
            carry <= '1';
        end if;
    end process;

    sum_bcd_output <= sum_bcd;
end architecture behavioral;
