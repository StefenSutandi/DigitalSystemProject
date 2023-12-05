library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity subtractor is
    port (
		clk: in std_logic;
        x, y: in std_logic_vector(13 downto 0);
        Result: out std_logic_vector(13 downto 0)
		);
end entity subtractor;

architecture behavioral of subtractor is
signal temp_result : std_logic_vector (13 downto 0);
begin
	process(x, y, clk) --(x dikurangi y)
    variable borrow : std_logic := '0';
	begin
	if(clk'event)and(clk = '1') then
	if (x < y) then --ketika input y lebih besar dari x, maka akan dihasilkan output 0.
		Result <= "00000000000000";
	else
		for i in 0 to 13 loop --Pengurangan dilakukan per bit. 
			temp_result(i) <= (x(i) xor y(i)) xor borrow ; --borrow pada bilangan sebelumnya dilakukan operasi xor dengan (x xor y)bit setelahnya.
			borrow := (not(x(i)) and y(i)) or (not(x(i) xor y(i)) and borrow); --Ketika x = '0' dan y = '1', maka borrow = '1'.
		end loop;	 														  
		Result <= temp_result;
	end if;
	end if;
    end process;
end behavioral;