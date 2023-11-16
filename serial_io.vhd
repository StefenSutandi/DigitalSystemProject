library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity serial_io is
    port(
        clk: in std_logic;
        reset: in std_logic;
        data_in: in std_logic;
        data_out: out std_logic
    );
end serial_io;

architecture Behavioral of serial_io is
    signal tx_reg: std_logic: = "1"
    signal bit_count: integer range 0 to 7 := 0;

begin
    process(clk, reset)
    begin
        if reset = '1' then
            tx_reg <= '1';         -- Reset the output to high (idle state)
            bit_count <= 0;        -- Reset bit count
        elsif rising_edge(clk) then
            if bit_count = 0 then
                tx_reg <= '0';    -- Start bit, set output low
            elsif bit_count < 8 then
                tx_reg <= data_in;  -- Transmit data bits LSB first
            elsif bit_count = 8 then
                tx_reg <= '1';    -- Stop bit, set output high
            end if;
    
            bit_count <= bit_count + 1;  -- Increment bit count
        end if;
    end process;
    
    data_out <= tx_reg;   -- Assign the output signal
end Behavioral;    