library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bin_bcd is
    port (
        x_bin, y_bin: in std_logic_vector(13 downto 0);
        x_bcd, y_bcd: out std_logic_vector(15 downto 0)
    );
end bin_bcd;

architecture behavioral of bin_bcd is
begin
    process(x_bin, y_bin)
        variable x_temp, y_temp: integer;
        variable x_satu, x_dua, x_tiga, x_empat, y_satu, y_dua, y_tiga, y_empat: integer range 0 to 9;
    begin
        -- x
        x_temp := to_integer(unsigned(x_bin));

        x_empat := x_temp mod 10;
        x_temp := x_temp / 10;

        x_tiga := x_temp mod 10;
        x_temp := x_temp / 10;

        x_dua := x_temp mod 10;
        x_temp := x_temp / 10;

        x_satu := x_temp mod 10;

        x_bcd <= std_logic_vector(to_unsigned(x_satu, 4) & to_unsigned(x_dua, 4) & to_unsigned(x_tiga, 4) & to_unsigned(x_empat, 4));
        
        ----------------------------------------------------------------
        -- y
        y_temp := to_integer(unsigned(y_bin));

        y_empat := y_temp mod 10;
        y_temp := y_temp / 10;
        
        y_tiga := y_temp mod 10;
        y_temp := y_temp / 10;

        y_dua := y_temp mod 10;
        y_temp := y_temp / 10;

        y_satu := y_temp mod 10;

        y_bcd <= std_logic_vector(to_unsigned(y_satu, 4) & to_unsigned(y_dua, 4) & to_unsigned(y_tiga, 4) & to_unsigned(y_empat, 4));
    end process;
end behavioral;
