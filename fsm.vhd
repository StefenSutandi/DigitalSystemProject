library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fsm is
    port(
		reset		: in std_logic;
		clock		: in std_logic;
		x			: buffer std_logic_vector(48 downto 0);
		y			: in std_logic_vector(48 downto 0);
		inValid 	: in std_logic;
		operation 	: in std_logic_vector(1 downto 0);
		sequential	: in std_logic;
		z 			: buffer std_logic_vector(48 downto 0)
    );
end fsm;

architecture behavioral of fsm is
    type states is (idle, adder, subtractor, multiplier, divider, sequentialMode, display);
    signal cState, nState: states;
    signal zAdder, zSubtractor, zMultiplier, zDivider, zResult, newX: std_logic_vector(48 downto 0);
    constant zero: STD_LOGIC_VECTOR(48 downto 0) := (others => '0');
    begin
        process(reset, clock)
            begin
                if (reset = '1') then
                    cState <= idle;
                elsif (clock'event and clock = '1') then
                    cState <= nState;
                end if;
        end process;
        process(x, y, inValid, operation, sequential, zAdder, zSubtractor, zMultiplier, zDivider, zResult, newX, cState)
            begin
				case cState is
					when idle =>
						if (inValid = '0') then
							nState <= idle;
							z <= zero;
						else						
							if (operation = "00") then
								nState <= adder;
								z <= zero;
							elsif (operation = "01") then
								nState <= subtractor;
								z <= zero;
							elsif (operation = "10") then
								nState <= multiplier;
								z <= zero;
							else
								nState <= divider;
								z <= zero;
							end if;
						end if;
					when adder =>
						z <= zAdder;
						zResult <= z;
						newX <= zResult;
						if (sequential = '0') then
								nState <= display;
						else
								nState <= sequentialMode;
						end if;
					when subtractor =>
						z <= zSubtractor;
						zResult <= z;
						newX <= z;
						if (sequential = '0') then
							nState <= display;
						else
							nState <= sequentialMode;
						end if;
					when multiplier =>
						z <= zMultiplier;
						zResult <= z;
						newX <= z;
						if (sequential = '0') then
							nState <= display;
						else
							nState <= sequentialMode;
						end if;
					when divider =>
						z <= zDivider;
						zResult <= z;
						newX <= z;
						if (sequential = '0') then
							nState <= display;
						else
							nState <= sequentialMode;
						end if;
					when sequentialMode =>
						z <= zResult;
						newX <= z;
						x <= newX;
						if (operation = "00") then
							nState <= adder;
						elsif (operation = "01") then
							nState <= subtractor;
						elsif (operation = "10") then
							nState <= multiplier;
						else
							nState <= divider;
						end if;
					when others =>
						z <= zResult;
						nState <= idle;
				end case;                
        end process;
end behavioral;
