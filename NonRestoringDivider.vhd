library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

-- Entity declaration
entity NonRestoringDivider is
    generic (
        DATA_WIDTH: positive := 4
    );
    port (
        dividend: in std_logic_vector(DATA_WIDTH-1 downto 0);
        divisor: in std_logic_vector(DATA_WIDTH-1 downto 0);
        quotient: out std_logic_vector(DATA_WIDTH-1 downto 0);
        valid: out std_logic
    );
end entity NonRestoringDivider;

-- Architecture implementation
architecture Behavioral of NonRestoringDivider is
begin
    process (dividend, divisor)
        variable A, M: std_logic_vector(DATA_WIDTH downto 0);
		variable Q: std_logic_vector(DATA_WIDTH-1 downto 0);
    begin
		if divisor = (others => '0') then
			quotient <= (others => 'X');
			valid <= '0';
		else
			if rising_edge(dividend) then
				
				-- Initialize variables
				Q := dividend;
				M := '0' & divisor;
				A := (others => '0');

				-- Perform division
				for i in DATA_WIDTH-1 downto 0 loop
				
					-- Left Shift A-Q 
					A(4 downto 1) <= A(3 downto 0);
					A(0) <= Q(3);
					Q(3 downto 1) <= Q(2 downto 0);
					Q(0) <= 'X'; -- or any other value you want to assign to the least significant bit of Q
				
				if A(DATA_WIDTH) = '0' then
					A := A - M;
				else
					A := A + M;
				end if;
				
				if A(DATA_WIDTH) = '0' then
					Q(0) <= '1';
				else
					Q(0) <= '0';
				end if;
				
				end loop;
				
				-- Assign outputs
				quotient <= Q;
				valid <= '1';
				
			end if;
		end if;				
    end process;
end architecture Behavioral;
