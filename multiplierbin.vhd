library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


-- Dua input dalam BCD
entity multiplierbin is
port(	xin, yin:	in std_logic_vector(15 downto 0);
	    hasil_out: 	out std_logic_vector(15 downto 0)
);
end multiplierbin;

architecture behavioral of multiplierbin is
    signal x, y: std_logic_vector(13 downto 0);
    signal hasil: std_logic_vector(13 downto 0);

component bcd_bin is
  port (
        x_bcd, y_bcd: in std_logic_vector(15 downto 0);
        x_bin, y_bin: out std_logic_vector(13 downto 0)
    );
end component;

component bin_bcd is
  port (
    hasil_bin: in std_logic_vector(13 downto 0);
    hasil_bcd: out std_logic_vector(15 downto 0)
);
end component; 

begin
  bin_conversion: bcd_bin
    port map(
      x_bcd => xin,
      y_bcd => yin,
      x_bin => x,
      y_bin => y
    );

-- multiplier dalam Biner
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

end process;

bcd_conversion: bin_bcd
      port map(
        hasil_bin => hasil,
        hasil_bcd => hasil_out
      );

end behavioral;