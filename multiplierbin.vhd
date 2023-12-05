library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


-- Dua input dalam Biner
entity multiplierbin is
port(	x, y:	in std_logic_vector(13 downto 0);
	    hasil: 	out std_logic_vector(13 downto 0)
);
end multiplierbin;

architecture behavioral of multiplierbin is

-- multiplier dalam Biner
begin

process(x, y)
	
  variable x_reg: std_logic_vector(14 downto 0);
  variable hasil_reg: std_logic_vector(27 downto 0);
begin	 	
  x_reg := "0" & x;
  hasil_reg := "00000000000000" & y;

  for i in 1 to 14 loop
    if hasil_reg(0)='1' then
	  hasil_reg(27 downto 14) := hasil_reg(27 downto 14) 
	  + x_reg(13 downto 0);
	end if;
	hasil_reg(27 downto 0) := '0' & hasil_reg(27 downto 1);
  end loop;
  
  -- Output
  hasil <= hasil_reg(13 downto 0);

  if hasil_reg > "0000000000000010011100001111" then
    hasil <= "10011100001111";
  else
    hasil <= hasil_reg(13 downto 0);
  end if;

end process;

end behavioral;