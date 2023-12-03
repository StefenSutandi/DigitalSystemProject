library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bin_bcd is
    port (
        hasil_bin: in std_logic_vector(13 downto 0);
        hasil_bcd: out std_logic_vector(15 downto 0)
    );
end bin_bcd;

architecture behavioral of bin_bcd is
begin
    process(hasil_bin)
        variable hasil_temp: integer;
        variable hasil_satu, hasil_dua, hasil_tiga, hasil_empat: integer range 0 to 9;
    begin
        -- hasil
        hasil_temp := to_integer(unsigned(hasil_bin));

        hasil_empat := hasil_temp mod 10;
        hasil_temp := hasil_temp / 10;

        hasil_tiga := hasil_temp mod 10;
        hasil_temp := hasil_temp / 10;

        hasil_dua := hasil_temp mod 10;
        hasil_temp := hasil_temp / 10;

        hasil_satu := hasil_temp mod 10;

        hasil_bcd <= std_logic_vector(to_unsigned(hasil_satu, 4) & to_unsigned(hasil_dua, 4) & to_unsigned(hasil_tiga, 4) & to_unsigned(hasil_empat, 4));
       
    end process;
end behavioral;
