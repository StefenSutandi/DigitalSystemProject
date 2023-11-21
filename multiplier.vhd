library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.numeric_std.all;

entity multiplier is
    Port (
        x: in integer range 0 to 999_999_999_999; 
        y: in integer range 0 to 999_999_999_999;
        error_flag: out std_logic;  -- Output error flag
        output_result: out std_logic_vector(48 downto 0) -- Output result (48-bit + 1 sign bit)
    );
end multiplier;