library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL;
-- use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity ascii_to_bin is
    Port ( ASCII_in : in  STD_LOGIC_VECTOR (95 downto 0);
           Binary_out : out  STD_LOGIC_VECTOR (71 downto 0));
end ascii_to_bin;

architecture Behavioral of ascii_to_bin is
begin
    process(ASCII_in)
    variable temp : STD_LOGIC_VECTOR (7 downto 0);
    variable bin : STD_LOGIC_VECTOR (71 downto 0);
	--	variable temp_bin : unsigned(35 downto 0);
    begin
        bin := (others => '0');
        for i in 0 to 11 loop
            temp := ASCII_in((i*8)+7 downto i*8);
            bin := std_logic_vector(unsigned(bin) + (to_unsigned(to_integer(unsigned(temp))-48, 36) * to_unsigned(10**(11-i), 36)));
			--	temp_bin := to_unsigned(to_integer(unsigned(temp))-48, 36) * to_unsigned(10**(11-i), 36);
			--	if temp_bin'high > bin'high then
			--		-- Handle overflow here, for example:
			--		bin := (others => '1');  -- Set to maximum value
			--	else
			--		bin := std_logic_vector(temp_bin + unsigned(bin));
			--	end if;
        end loop;
        Binary_out <= bin;
    end process;
end Behavioral;
