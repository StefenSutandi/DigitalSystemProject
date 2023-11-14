library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 

entity adder is 
    port( 
        X, Y: in std_logic_vector(3 downto 0); -- input maks 12 digit
        Result : out std_logic_vector(3 downto 0) -- output hasil penjumlahan
    ); 
end adder; 

architecture adder of adder is 
begin 
    process(X, Y) 
    begin -- algoritma utama operasi penjumlahan 
        Result <= X + Y; 
    end process; 
end adder; 