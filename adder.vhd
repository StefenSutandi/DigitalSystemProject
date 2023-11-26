library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

entity adder is
    port (
        x: in std_logic_vector(47 downto 0)
        y: in std_logic_vector(47 downto 0)
        carry_out: out std_logic;
        sum_bcd: out std_logic_vector(47 downto 0);
        error_flag: out std_logic
    );
end entity adder;

architecture behavioral of adder is
    signal x_bcd, y_bcd: std_logic_vector(47 downto 0);
    signal sum_bcd1: std_logic_vector(47 downto 0);
    signal carry: std_logic := '0';  -- Use signal for carry
    signal temp_carry: std_logic;  -- Signal for temp_carry
    constant BCD_group : integer := 4;

component ascii_bcd is
    port(
        ascii_x_input: in std_logic_vector(7 downto 0); -- Input x (ASCII)
        ascii_y_input: in std_logic_vector(7 downto 0); -- Input y (ASCII)
        bcd_x_output: out std_logic_vector(3 downto 0); -- Output BCD for x
        bcd_y_output: out std_logic_vector(3 downto 0)  -- Output BCD for y
    );
end component;   

begin
    -- ASCII to BCD conversion for X and Y
    bcd_conversion: ascii_bcd
        port map (
            ascii_x_input => x,
            bcd_x_output => x_bcd,
            ascii_y_input => y,
            bcd_y_output => y_bcd
        ); 

    -- Adder in BCD field
    process(x_bcd, y_bcd)
        variable temp_sum: integer;
        variable temp_result: std_logic_vector(47 downto 0);
    begin
        temp_carry <= '0';  -- Initialize temp_carry

        -- Iterate for each group of 4 BCD bits from LSB to MSB
        for i in 11 downto 0 loop
            temp_sum := to_integer(unsigned(x_bcd(i * BCD_group + BCD_group - 1 downto i * BCD_group))) +
                        to_integer(unsigned(y_bcd(i * BCD_group + BCD_group - 1 downto i * BCD_group))) +
                        to_integer(temp_carry);

            if temp_sum < 10 then
                temp_result(i * BCD_group + BCD_group - 1 downto i * BCD_group) <= std_logic_vector(to_unsigned(temp_sum, BCD_group));
                temp_carry <= '0';
            else
                temp_result(i * BCD_group + BCD_group - 1 downto i * BCD_group) <= std_logic_vector(to_unsigned(temp_sum + 6, BCD_group));
                temp_carry <= '1';
            end if;
        end loop;

        -- Assign the final result to the sum_bcd signal
        sum_bcd <= temp_result;

        -- Error case if the size is greater than 48 bits
        if sum_bcd'length > 48 then
            error_flag <= '1';
        else
            error_flag <= '0';
        end if;
    end process;

    -- BCD to ASCII conversion for BCD sum
    sum_ascii_conversion: entity kalkulator.bcd_ascii
        port map (
            bcd_sum_input => sum_bcd,
            ascii_output => sum_ascii
        );

    -- Set the carry_out signal
    carry_out <= temp_carry;
end architecture behavioral;
