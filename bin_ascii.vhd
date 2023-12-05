library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Entity Declaration
entity bin_ascii is
	generic (
		DATA_WIDTH_ASCII : positive := 32;
		DATA_WIDTH_BCD : positive := 16;
		DATA_WIDTH_BIN : positive := 14
	);
	port(
        x_bin_in : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
        x_ascii_out : out std_logic_vector(DATA_WIDTH_BCD-1 downto 0)
    );
    
end entity bin_ascii;

architecture behavioral of bin_ascii is
	signal x_bcd_temp : std_logic_vector(DATA_WIDTH_BCD-1 downto 0);

	
-- Components Declaration
component bin_bcd is
    port(
        hasil_bin : in std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
        hasil_bcd : out std_logic_vector(DATA_WIDTH_BCD-1 downto 0)
    );
end component;
component bcd_ascii is
    port(
        bcd_input : in std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
        ascii_output : out std_logic_vector(DATA_WIDTH_ASCII-1 downto 0)
    );
end component;

begin
	-- Bin to BCD Conversion for Dividend and Divisor
    bin_to_bcd_conversion : bin_bcd
        port map (
        hasil_bin => x_bin_in, 
        hasil_bcd => x_bcd_temp 
        );
	-- BCD to ASCII Conversion for Dividend and Divisor
    bcd_to_binary_conversion : bcd_ascii
        port map (
		bcd_input => x_bcd_temp, 
        ascii_output => x_ascii_out
        );
end architecture;
