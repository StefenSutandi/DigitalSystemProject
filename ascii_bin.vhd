library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Entity Declaration
entity ascii_bin is
	generic (
		DATA_WIDTH_ASCII : positive := 32;
		DATA_WIDTH_BCD : positive := 16;
		DATA_WIDTH_BIN : positive := 14
	);
	port(
        x_ascii_in : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
        y_ascii_in : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
        x_bin_out : out std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
        y_bin_out : out std_logic_vector(DATA_WIDTH_BCD-1 downto 0)
    );
end entity ascii_bin;

architecture behavioral of ascii_bin is
	signal x_bcd_temp : std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
	signal y_bcd_temp : std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
-- Components Declaration
component ascii_bcdo is
    port(
        input_ascii_x : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
        input_ascii_y : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
        output_bcd_x : out std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
        output_bcd_y : out std_logic_vector(DATA_WIDTH_BCD-1 downto 0)
    );
end component;
component bcd_bin is
    port(
        x_bcd : in std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
		y_bcd : in std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
        x_bin : out std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
		y_bin : out std_logic_vector(DATA_WIDTH_BIN-1 downto 0)
    );
end component;
begin
	-- ASCII to BCD Conversion for Dividend and Divisor
    ascii_to_bcd_conversion : ascii_bcdo
        port map (
            input_ascii_x => x_ascii_in,
            output_bcd_x => x_bcd_temp,
            input_ascii_y => y_ascii_in,
            output_bcd_y => y_bcd_temp
        );
	-- BCD to Binary Conversion for Dividend and Divisor
    bcd_to_binary_conversion : bcd_bin
        port map (
            x_bcd => x_bcd_temp,
            x_bin => x_bin_out,
            y_bcd => y_bcd_temp,
            y_bin => y_bin_out
        );
end architecture;