library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


-- dua 40-bit input and one 8-bit outputs
-- Dua input 40-bit (12 digit) dan output 40 bit (12 digit)
entity multiplierbin is
port(	x, y:	in std_logic_vector(39 downto 0);
	    hasil: 	out std_logic_vector(39 downto 0)
);
end multiplierbin;

architecture behavioral of multiplierbin is

begin
process(x, y)
	
  variable x_reg: std_logic_vector(40 downto 0);
  variable hasil_reg: std_logic_vector(81 downto 0);
begin	 
	
  x_reg := "0" & x;
  hasil_reg := "000000000000000000000000000000000000000000" & y;

  for i in 1 to 41 loop
    if hasil_reg(0)='1' then
	  hasil_reg(81 downto 41) := hasil_reg(81 downto 41) 
	  + x_reg(40 downto 0);
	end if;
	hasil_reg(81 downto 0) := '0' & hasil_reg(81 downto 1);
  end loop;
  
  -- Output
  hasil <= hasil_reg(39 downto 0);

end process;

end behavioral;