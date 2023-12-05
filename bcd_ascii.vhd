library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcd_ascii is
    Port(bcd_input : in STD_LOGIC_VECTOR(15 downto 0);
         ascii_output : out STD_LOGIC_VECTOR(31 downto 0)
	);
end bcd_ascii;

architecture Behavioral of bcd_ascii is
    signal ascii_digit_1 : std_logic_vector(7 downto 0);
    signal ascii_digit_2 : std_logic_vector(7 downto 0);
    signal ascii_digit_3 : std_logic_vector(7 downto 0);
    signal ascii_digit_4 : std_logic_vector(7 downto 0);
begin
    process(bcd_input)
		variable BCD_temp : std_logic_vector(7 downto 0);
    begin
        -- Convert the first BCD digit to ASCII
        case bcd_input(3 downto 0) is
            when "0000" => BCD_temp := "00110000"; -- ASCII code for '0'
            when "0001" => BCD_temp := "00110001"; -- ASCII code for '1'
            when "0010" => BCD_temp := "00110010"; -- ASCII code for '2'
            when "0011" => BCD_temp := "00110011"; -- ASCII code for '3'
            when "0100" => BCD_temp := "00110100"; -- ASCII code for '4'
            when "0101" => BCD_temp := "00110101"; -- ASCII code for '5'
            when "0110" => BCD_temp := "00110110"; -- ASCII code for '6'
            when "0111" => BCD_temp := "00110111"; -- ASCII code for '7'
            when "1000" => BCD_temp := "00111000"; -- ASCII code for '8'
            when "1001" => BCD_temp := "00111001"; -- ASCII code for '9'
            when others => BCD_temp := "00110000"; -- Default to '0' if not a valid BCD digit
        end case;
        ascii_digit_4 <= BCD_temp;

        -- Convert the second BCD digit to ASCII
        case bcd_input(7 downto 4) is
            when "0000" => BCD_temp := "00110000"; -- ASCII code for '0'
            when "0001" => BCD_temp := "00110001"; -- ASCII code for '1'
            when "0010" => BCD_temp := "00110010"; -- ASCII code for '2'
            when "0011" => BCD_temp := "00110011"; -- ASCII code for '3'
            when "0100" => BCD_temp := "00110100"; -- ASCII code for '4'
            when "0101" => BCD_temp := "00110101"; -- ASCII code for '5'
            when "0110" => BCD_temp := "00110110"; -- ASCII code for '6'
            when "0111" => BCD_temp := "00110111"; -- ASCII code for '7'
            when "1000" => BCD_temp := "00111000"; -- ASCII code for '8'
            when "1001" => BCD_temp := "00111001"; -- ASCII code for '9'
            when others => BCD_temp := "00110000"; -- Default to '0' if not a valid BCD digit
        end case;
        ascii_digit_3 <= BCD_temp;
        
        -- Convert the third BCD digit to ASCII
        case bcd_input(11 downto 8) is
            when "0000" => BCD_temp := "00110000"; -- ASCII code for '0'
            when "0001" => BCD_temp := "00110001"; -- ASCII code for '1'
            when "0010" => BCD_temp := "00110010"; -- ASCII code for '2'
            when "0011" => BCD_temp := "00110011"; -- ASCII code for '3'
            when "0100" => BCD_temp := "00110100"; -- ASCII code for '4'
            when "0101" => BCD_temp := "00110101"; -- ASCII code for '5'
            when "0110" => BCD_temp := "00110110"; -- ASCII code for '6'
            when "0111" => BCD_temp := "00110111"; -- ASCII code for '7'
            when "1000" => BCD_temp := "00111000"; -- ASCII code for '8'
            when "1001" => BCD_temp := "00111001"; -- ASCII code for '9'
            when others => BCD_temp := "00110000"; -- Default to '0' if not a valid BCD digit
        end case;
        ascii_digit_2 <= BCD_temp;
        
        -- Convert the fourth BCD digit to ASCII
        case bcd_input(15 downto 12) is
            when "0000" => BCD_temp := "00110000"; -- ASCII code for '0'
            when "0001" => BCD_temp := "00110001"; -- ASCII code for '1'
            when "0010" => BCD_temp := "00110010"; -- ASCII code for '2'
            when "0011" => BCD_temp := "00110011"; -- ASCII code for '3'
            when "0100" => BCD_temp := "00110100"; -- ASCII code for '4'
            when "0101" => BCD_temp := "00110101"; -- ASCII code for '5'
            when "0110" => BCD_temp := "00110110"; -- ASCII code for '6'
            when "0111" => BCD_temp := "00110111"; -- ASCII code for '7'
            when "1000" => BCD_temp := "00111000"; -- ASCII code for '8'
            when "1001" => BCD_temp := "00111001"; -- ASCII code for '9'
            when others => BCD_temp := "00110000"; -- Default to '0' if not a valid BCD digit
        end case;
        ascii_digit_1 <= BCD_temp;
    end process;
    -- Concatenate all tha ASCII digits!
    ascii_output <= (ascii_digit_1) & (ascii_digit_2) & (ascii_digit_3) & (ascii_digit_4);
end Behavioral;
