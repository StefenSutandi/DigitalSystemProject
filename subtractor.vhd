library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity subtractor is
    port (
        x: in integer range 0 to 999_999_999_999; -- Maximum 12 digit input
        y: in integer range 0 to 999_999_999_999;
        difference_bcd: out std_logic_vector(47 downto 0);
        borrow_out: out std_logic;
        error_flag: out std_logic
    );
end entity subtractor;

architecture behavioral of subtractor is
    signal x_bcd, y_bcd: std_logic_vector(47 downto 0);
    signal difference_bcd: std_logic_vector(47 downto 0);
    signal borrow: std_logic := '0';
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

    -- Subtractor in BCD field
    process(x_bcd, y_bcd)
        variable temp_difference: integer;
        variable temp_result: std_logic_vector(47 downto 0);
        variable borrow: std_logic;
    begin
        temp_difference := to_integer(unsigned(x_bcd)) - to_integer(unsigned(y_bcd)) - (borrow and 1);
        
        -- Iterate for each group of 4 BCD bits from LSB to MSB
        for i in 11 downto 0 loop
            temp_difference := to_integer(unsigned(x_bcd(i * BCD_group + BCD_group - 1 downto i * BCD_group))) -
                                to_integer(unsigned(y_bcd(i * BCD_group + BCD_group - 1 downto i * BCD_group))) -
                                (borrow and 1);

            if temp_difference >= 0 then
                temp_result(i * BCD_group + BCD_group - 1 downto i * BCD_group) <= std_logic_vector(to_unsigned(temp_difference, BCD_group));
                borrow := '0';
            else
                temp_result(i * BCD_group + BCD_group - 1 downto i * BCD_group) <= std_logic_vector(to_unsigned(temp_difference + 10, BCD_group));
                borrow := '1';
            end if;
        end loop;

        difference_bcd <= temp_result;

        -- Error case if the size is greater than 48 bits
        if difference_bcd'length > 48 then
            error_flag <= '1';
        else
            error_flag <= '0';
        end if;

        borrow_out <= borrow;
    end process;
end architecture behavioral;