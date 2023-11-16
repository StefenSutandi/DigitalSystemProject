library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity mux is 
    port( selektor_operasi: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
          penjumlahan, pengurangan, perkalian, pembagian : IN SIGNED (3 DOWNTO 0); -- HASIL OPERASI MATEMATIKA
          output_selektor : OUT SIGNED (3 DOWNTO 0) -- OPERASI MATEMATIKA YANG DIPILIH
        );
end mux;

architecture arc_mux of mux is
begin
    process(selektor_operasi, penjumlahan, pengurangan, perkalian, pembagian)
    begin
        if (selektor_operasi = "00") then
            output_selektor <= penjumlahan ; -- OPERASI MATEMATIKA YANG DIPILIH ADALAH PENJUMLAHAN 
        elsif (selektor_operasi = "01") then
            output_selektor <= pengurangan ; -- OPERASI MATEMATIKA YANG DIPILIH ADALAH PENGURANGAN 
        elsif (selektor_operasi = "10") then
            output_selektor <= perkalian ; -- OPERASI MATEMATIKA YANG DIPILIH ADALAH PERKALIAN
        else  --(selektor_operasi = "11")
            output_selektor <= pembagian ; -- OPERASI MATEMATIKA YANG DIPILIH ADALAH PEEMBAGIAN
        end if ;
    end process ;
end arc_mux ;  