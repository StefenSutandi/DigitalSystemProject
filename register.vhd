library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity register is
	port( rst, clk, load: in std_logic;
		input: in std_logic_vector( 3 downto 0 );
		output: out std_logic_vector( 3 downto 0 )
	);
end register;

architecture register_arc of register is
begin
	process( rst, clk, load, input )
	begin
	if( rst = '1' ) then
		output <= "0000";
	elsif( clk'event and clk = '1') then
		if( load = '1' ) then
			output <= input;
		end if;
		end if;
	end process;
end register_arc;