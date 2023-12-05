library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Entity Declaration
entity divider is
	generic (
		DATA_WIDTH_ASCII : positive := 32;
		DATA_WIDTH_BCD : positive := 16;
		DATA_WIDTH_BIN : positive := 14
	);
    port (
        dividend_ascii : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
        divisor_ascii : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
        quotient_ascii : out std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
        error_flag: out std_logic
    );	
end entity divider;

-- Architecture Implementation
architecture behavioral of divider is
	signal dividend_bcd : std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
	signal divisor_bcd : std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
	signal quotient_bcd : std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
	signal dividend_bin : std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
	signal divisor_bin : std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
	signal quotient_bin : std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
-- Components Declaration
component ascii_bcd is
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
	-- ASCII to BCD Conversion for Dividend and Divisor
    ascii_to_bcd_conversion_dividend_divisor : ascii_bcdo
        port map (
            input_ascii_x => dividend_ascii,
            output_bcd_x => dividend_bcd,
            input_ascii_y => divisor_ascii,
            output_bcd_y => divisor_bcd
        );
	-- BCD to Binary Conversion for Dividend and Divisor
    bcd_to_binary_conversion_dividend_divisor : bcd_bin
        port map (
            x_bcd => dividend_bcd,
            x_bin => dividend_bin,
            y_bcd => divisor_bcd,
            y_bin => divisor_bin
        );
	-- Main Process
    process (dividend_bin, divisor_bin)
		-- Variables Declaration
        variable A : std_logic_vector(DATA_WIDTH_BIN downto 0);
		variable M : std_logic_vector(DATA_WIDTH_BIN downto 0);
		variable Q : std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
    begin				
		-- Variables Initalization
		Q := dividend_bin;
		M := '0' & divisor_bin;
		A := (others => '0');
		-- Zero Divisor Case
		if M = "00000000000000" then
			Q := (others => '0');
			error_flag <= '1';
		-- Dividend Less than Divisor Case
		elsif Q < M then
			Q := (others => '0');
			error_flag <= '0';			
		else
			-- Division Operation
			for i in DATA_WIDTH_BIN-1 downto 0 loop			
				-- Left Shift A-Q 
				A := A(DATA_WIDTH_BIN-1 downto 0) & Q(DATA_WIDTH_BIN-1);
				Q := Q(DATA_WIDTH_BIN-2 downto 0) & 'X';
				-- Some Conditionals
				if A(DATA_WIDTH_BIN) = '0' then
					A := A - M;
				else
					A := A + M;
				end if;			
				if A(DATA_WIDTH_BIN) = '0' then
					Q(0) := '1';
				else
					Q(0) := '0';
				end if;			
			end loop;
			error_flag <= '0';
		end if;
		-- Output Assignments
		quotient_bin <= Q;
    end process;
	-- Binary to BCD Conversion for Quotient
	bin_to_bcd_conversion_quotient : bin_bcd
		port map (
			hasil_bin => quotient_bin,
			hasil_bcd => quotient_bcd
		);
	 --BCD to ASCII Conversion for Quoutient
	bcd_to_ascii_conversion_quotient : bcd_ascii
		port map (
			bcd_input => quotient_bcd,
			ascii_output => quotient_ascii
		);
end architecture behavioral;
