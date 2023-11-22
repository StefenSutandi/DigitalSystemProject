library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divider is
	port(
		clock		: in std_logic;
		dividend	: in std_logic_vector(48 downto 0);
		divisor		: in std_logic_vector(48 downto 0);
		quotient	: out std_logic_vector(48 downto 0);
		valid		: out std_logic
	);
end divider;

architecture behavioral of divider is
	signal quotientUnsigned: unsigned(47 downto 0);
	constant zero: std_logic_vector(48 downto 0) := (others => '0');
begin
	process(clock)
	begin
		if rising_edge(clock) then
			if divisor = zero then
				quotientUnsigned <= (others => '0');
				valid <= '0';
			else
				quotientUnsigned <= unsigned(dividend(47 downto 0)) / unsigned(divisor(47 downto 0));
				valid <= '1';
			end if;
		end if;
	end process;
	process(dividend(48), divisor(48))
	begin
		if dividend(48) = divisor(48) then
			quotient <= '0' & std_logic_vector(quotientUnsigned);
		else
			quotient <= '1' & std_logic_vector(quotientUnsigned);
		end if;
	end process;
end behavioral;
