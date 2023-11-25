library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regis is
    port(
        rst, clk, load: in std_logic;
        input: in std_logic_vector(3 downto 0);
        output: out std_logic_vector(3 downto 0)
    );
end entity regis;

architecture regis_arc of regis is
begin
    process (rst, clk)
    begin
        if rst = '1' then
            output <= "0000";
        elsif rising_edge(clk) then
            if load = '1' then
                output <= input;
            end if;
        end if;
    end process;
end architecture regis_arc;