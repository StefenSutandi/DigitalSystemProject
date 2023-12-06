library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux is 
    port( 
        selector : in std_logic_vector(1 downto 0);
        adder, subtractor, multiplier, divider : in std_logic_vector (13 downto 0); 
        output_selector : out std_logic_vector(13 downto 0) 
    );
end mux;

architecture arc_mux of mux is
    signal temp_output : std_logic_vector(13 downto 0);  -- Variabel internal untuk hasil sementara
begin
    process(selector)
    begin
        case selector is
            when "00" =>
                temp_output <= adder;
            when "01" =>
                temp_output <= subtractor;
            when "10" =>
                temp_output <= multiplier;
            when others =>
                temp_output <= divider;
        end case;

        output_selector <= temp_output;  -- Mengatur output berdasarkan hasil sementara
    end process;
end arc_mux;