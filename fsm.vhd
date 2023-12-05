library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fsm is
generic (
		DATA_WIDTH_ASCII : positive := 32;
		DATA_WIDTH_BCD : positive := 16;
		DATA_WIDTH_BIN : positive := 14
	);
    port(
		reset : in std_logic;
		clock : in std_logic;		
		y : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);		
		operation : in std_logic_vector(1 downto 0);
		sequential_mode1 : in std_logic_vector(13 down to 0);
		error_flag : buffer std_logic;
		x : buffer std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
		z : buffer std_logic_vector(DATA_WIDTH_ASCII-1 downto 0)
    );
end fsm;

architecture behavioral of fsm is
    type states is (idle, mux1, adder1, subtractor1, multiplier1, divider1, sequential_state, display);
    signal cState, nState: states;
    signal z_adder, z_subtractor, z_multiplier, z_divider, z_result, new_x : std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
    constant zero: std_logic_vector(DATA_WIDTH_ASCII-1 downto 0) := (others => '0');
    begin
        process(reset, clock)
            begin
                if reset = '1' then
                    cState <= idle;
                elsif (clock'event and clock = '1') then
                    cState <= nState;
                end if;
        end process;
        process(x, y, error_flag, operation, sequential_mode, z_adder, z_subtractor, z_multiplier, z_divider, z_result, new_x, cState)
            begin
				case cState is
					when idle =>
						if error_flag = '1' then
							nState <= idle;
						else
							nState <= mux1;
						end if;
						z <= zero;
					when mux1 =>
						if error_flag = '1' then
							nState <= idle;
						else
							if operation = "00" then
								nState <= adder1;
							elsif operation = "01" then
								nState <= subtractor1;
							elsif operation = "10" then
								nState <= multiplier1;
							else
								nState <= divider1;
							end if;
						end if;
						z <= zero;
					when adder1 =>
						if error_flag = '1' then
							nState <= idle;
						else
							if sequential_mode = '0' then
									nState <= display;
							else
									nState <= sequential_state;
							end if;
						end if;
						z <= z_adder;
						z_result <= z;
						new_x <= z_result;
					when subtractor1 =>
						if error_flag = '1' then
							nState <= idle;
						else
							if sequential_mode = '0' then
								nState <= display;
							else
								nState <= sequential_state;
							end if;
						end if;
						z <= z_subtractor;
						z_result <= z;
						new_x <= z;
					when multiplier1 =>
						if error_flag = '1' then
							nState <= idle;
						else
							if sequential_mode = '0' then
								nState <= display;
							else
								nState <= sequential_state;
							end if;
						end if;
						z <= z_multiplier;
						z_result <= z;
						new_x <= z;
					when divider1 =>
						if error_flag = '1' then
							nState <= idle;
						else
							if sequential_mode = '0' then
								nState <= display;
							else
								nState <= sequential_state;
							end if;
						end if;
						z <= z_divider;
						z_result <= z;
						new_x <= z;
					when sequential_state =>
						if error_flag = '1' then
							nState <= idle;
						else
							if operation = "00" then
								nState <= adder1;
							elsif operation = "01" then
								nState <= subtractor1;
							elsif operation = "10" then
								nState <= multiplier1;
							else
								nState <= divider1;
							end if;
						end if;
						z <= z_result;
						new_x <= z;
						x <= new_x;
					when others =>
						z <= z_result;
						nState <= idle;
				end case;                
        end process;
end behavioral;
