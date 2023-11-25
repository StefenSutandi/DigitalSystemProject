library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bcd_bin is
    port (
        x_bcd, y_bcd: in std_logic_vector(15 downto 0);
        x_bin, y_bin: out std_logic_vector(13 downto 0)
    );
end bcd_bin;

architecture behavioral of bcd_bin is
begin
    process(x_bcd,y_bcd)
        variable x_satu, x_dua, x_tiga, x_empat, y_satu, y_dua, y_tiga, y_empat: integer;
        variable x_temp, y_temp: integer;
        variable x_tembin, y_tembin: std_logic_vector(13 downto 0);
    begin	 
        x_satu := to_integer(unsigned(x_bcd(15 downto 12)));
        x_dua  := to_integer(unsigned(x_bcd(11 downto 8)));
        x_tiga := to_integer(unsigned(x_bcd(7 downto 4)));
        x_empat := to_integer(unsigned(x_bcd(3 downto 0)));

        x_temp := x_satu * 1000 + x_dua * 100 + x_tiga * 10 + x_empat;

        x_tembin := std_logic_vector(to_unsigned(x_temp, x_tembin'length));

        x_bin <= x_tembin(13 downto 0);
------------------------------------------------------------------------------
        y_satu := to_integer(unsigned(y_bcd(15 downto 12)));
        y_dua  := to_integer(unsigned(y_bcd(11 downto 8)));
        y_tiga := to_integer(unsigned(y_bcd(7 downto 4)));
        y_empat := to_integer(unsigned(y_bcd(3 downto 0)));

        y_temp := y_satu * 1000 + y_dua * 100 + y_tiga * 10 + y_empat;

        y_tembin := std_logic_vector(to_unsigned(y_temp, y_tembin'length));

        y_bin <= y_tembin(13 downto 0);
    end process;
end behavioral;
