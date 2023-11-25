library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity HelloWorld is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           display : out STD_LOGIC_VECTOR(6 downto 0));
end HelloWorld;

architecture Behavioral of HelloWorld is
    signal counter : integer range 0 to 25000000 := 0;
    signal message : std_logic_vector(6 downto 0) := "0000000"; -- "Hello, World!" in 7-segment display format

begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            display <= "1111111"; -- Turn off the display during reset
        elsif rising_edge(clk) then
            if counter = 0 then
                display <= message;
            else
                display <= "1111111"; -- Turn off the display when not showing the message
            end if;
            
            if counter = 5000000 then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
end Behavioral;
