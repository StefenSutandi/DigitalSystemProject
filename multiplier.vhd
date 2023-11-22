library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.numeric_std.all;

entity multiplier is
    port (
<<<<<<< HEAD
        x: in integer range 0 to 999_999_999_999; -- Maximum 12 digit input
        y: in integer range 0 to 999_999_999_999;
        multiplier_bcd: out std_logic_vector(47 downto 0);
        error_flag: out std_logic
    );
end entity multiplier;

architecture behavioral of multiplier is
    signal x_bcd, y_bcd: std_logic_vector(47 downto 0);
    signal multiplier_bcd: std_logic_vector(47 downto 0);


process(x_bcd, y_bcd)
    variable temp_out: std_logic_vector(47 downto 0);

begin
    for j in 0 downto 11 loop 
        for i in 0 downto to_integer(unsigned(y_bcd(3 + (j * 4) downto (j * 4)))) loop
            digit_multiply: entity kalkulator.adder
                port map(
                    
                ) 

    
    


-- input x input y
-- multiplier digit = leftshift 4 bit kali 0(LSB X ADDER LSB X Sebanyak Y)
-- temp_out = temp_out adder adder multiplier digit
-- 128 x  158 y
=======
        x: in integer range 0 to 999_999_999_999; 
        y: in integer range 0 to 999_999_999_999;
        error_flag: out std_logic;  -- Output error flag
        output_result: out std_logic_vector(48 downto 0) -- Output result (48-bit + 1 sign bit)
    );
end multiplier;
>>>>>>> 48234f64b75f4e5675989e9150b877d2c26c5168
