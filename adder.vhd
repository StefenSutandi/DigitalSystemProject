library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.numeric_std.all;

entity adder is
    port (
        x: in integer range 0 to 999_999_999_999; -- Maximum 12 digit input
        y: in integer range 0 to 999_999_999_999;
        sum_bcd: out std_logic_vector(47 downto 0);
        carry_out: out std_logic
        error_flag: out std_logic
    );
end entity adder;

architecture behavioral of adder is
    signal x_bcd, y_bcd: std_logic_vector(47 downto 0);
    signal sum_bcd: std_logic_vector(47 downto 0);
    signal carry: std_logic := '0';
    signal temp_carry: std_logic;
    constant BCD_group : integer := 4;
begin
    -- ASCII to BCD conversion for X and Y
    x_bcd_conversion: entity kalkulator.ascii_bcd
        port map (
            ascii_input => x,
            bcd_output => x_bcd
        );

    y_bcd_conversion: entity kalkulator.ascii_bcd
        port map (
            ascii_input => y,
            bcd_output => y_bcd
        );

    -- Adder in BCD field
    process(x_bcd, y_bcd)
        variable temp_sum: integer;
        variable temp_result: std_logic_vector(47 downto 0);
        variable temp_carry: std_logic
    begin
        temp_sum := to_integer(unsigned(x_bcd)) + to_integer(unsigned(y_bcd)) + to_integer(carry);
        
        -- Iterate for each group of 4 BCD bits from LSB to MSB
        for i in 11 downto 0 loop
        temp_sum := to_integer(unsigned(x_bcd(i * BCD_group + BCD_group - 1 downto i * BCD_group))) +
                    to_integer(unsigned(y_bcd(i * BCD_group + BCD_group - 1 downto i * BCD_group))) +
                    to_integer(temp_carry);

            if temp_sum < 10 then
                temp_result(i * BCD_group + BCD_group - 1 downto i * BCD_group) <= std_logic_vector(to_unsigned(temp_sum, BCD_group));
                temp_carry := '0';
            else
                temp_result(i * BCD_group + BCD_group - 1 downto i * BCD_group) <= std_logic_vector(to_unsigned(temp_sum + 6, BCD_group));
                temp_carry := '1';
            end if;
        end loop;

         -- Error case if the size is greater than 48 bits
            if sum_bcd'length > 48 then
                error_flag <= '1';
            else
                error_flag <= '0';
            end if;
    sum_bcd_output <= sum_bcd;
    error_flag <= error_flag;
    end process;
end architecture behavioral;
