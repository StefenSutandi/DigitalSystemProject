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
        dividend : in std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
        divisor : in std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
        quotient : out std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
        error_flag: out std_logic
    );	
end entity divider;

-- Architecture Implementation
architecture behavioral of divider is
begin
	-- Main Process
    process (dividend, divisor)
		-- Variables Declaration
        variable A : std_logic_vector(DATA_WIDTH_BIN downto 0);
		variable M : std_logic_vector(DATA_WIDTH_BIN downto 0);
		variable Q : std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
    begin				
		-- Variables Initalization
		Q := dividend;
		M := '0' & divisor;
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
		quotient <= Q;
    end process;
end architecture behavioral;
