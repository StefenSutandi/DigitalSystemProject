library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.numeric_std.all;

entity multiplier is
    port (
        x: in integer range 0 to 999_999_999_999; -- Maximum 12 digit input
        y: in integer range 0 to 999_999_999_999;
        multi_bcd: out std_logic_vector(47 downto 0);
        error_flag: out std_logic
    );
end entity multiplier;

architecture behavioral of multiplier is
    signal x_bcd, y_bcd: std_logic_vector(47 downto 0);
    signal x_multi: std_logic_vector(47 downto 0);
    signal y_multi: std_logic_vector(47 downto 0);
    signal sum_bcd: std_logic_vector(47 downto 0);
    signal temp_multi: std_logic_vector(47 downto 0);
    signal carry: std_logic := '0';
    signal temp_carry: std_logic;
    constant BCD_group : integer := 4;
begin
    -- ASCII to BCD conversion for X and Y
    x_bcd_conversion: entity kalkulator.ascii_bcd
        port map (
            ascii_x_input => x,
            bcd_x_output => x_bcd
        );

    y_bcd_conversion: entity kalkulator.ascii_bcd
        port map (
            ascii_y_input => y,
            bcd_y_output => y_bcd
        );
    
-- Multiplier in BCD field
process(x_bcd, y_bcd)
    variable temp_sum: integer;
    variable temp_result: std_logic_vector(47 downto 0);
    variable temp_carry: std_logic;
    variable temp_multi: std_logic_vector(47 downto 0);
    variable x_multi: std_logic_vector(47 downto 0);
    variable y_multi: std_logic_vector(47 downto 0);

begin
    for k in 0 downto 11 loop 
        for j in 0 downto to_integer(unsigned(y_bcd(k * BCD_group + BCD_group - 1 downto k * BCD_group))) loop
            x_multi(47 downto 0) <= temp_multi (47 downto 0);
            y_multi(47 downto 0) <= x_bcd -- ini nanti digeser perdigit dari perkalian satuan ke puluhan dan seterusnya

           -- adder
            for i in 11 downto 0 loop
                temp_sum := to_integer(unsigned(x_multi(i * BCD_group + BCD_group - 1 downto i * BCD_group))) +
                            to_integer(unsigned(y_multi(i * BCD_group + BCD_group - 1 downto i * BCD_group))) +
                            to_integer(temp_carry);
        
                    if temp_sum < 10 then
                        temp_result(i * BCD_group + BCD_group - 1 downto i * BCD_group) <= std_logic_vector(to_unsigned(temp_sum, BCD_group));
                        temp_carry := '0';
                    else
                        temp_result(i * BCD_group + BCD_group - 1 downto i * BCD_group) <= std_logic_vector(to_unsigned(temp_sum + 6, BCD_group));
                        temp_carry := '1';
                    end if;
                end loop;
            -- adder
            x_multi <= temp_sum













    -- Error case if the size is greater than 48 bits
    if sum_bcd'length > 48 then
        error_flag <= '1';
      else
        error_flag <= '0';
      end if;
      sum_bcd_output <= sum_bcd;
      error_flag     <= error_flag;
  
      -- BCD to ASCII conversion for BCD sum
      sum_ascii_conversion : entity kalkulator.bcd_ascii
        port
        map (
        bcd_sum_input => sum_bcd,
        ascii_output  => sum_ascii
        );
  
    end process;
  end architecture behavioral;
    
    


-- input x input y
-- multiplier digit = leftshift 4 bit kali 0(LSB X ADDER LSB X Sebanyak Y)
-- temp_out = temp_out adder adder multiplier digit
-- 128 x  158 y
