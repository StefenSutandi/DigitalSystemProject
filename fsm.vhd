library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fsm is
generic (
		DATA_WIDTH_ASCII : positive := 32;
		DATA_WIDTH_BCD : positive := 16;
		DATA_WIDTH_BIN : positive := 14
	)
    port(
		reset : in std_logic;
		clock : in std_logic;		
		y : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);		
		operation : in std_logic_vector(1 downto 0);
		sequential_mode : in std_logic;
		error_flag : buffer std_logic;
		x : buffer std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
		z : buffer std_logic_vector(DATA_WIDTH_ASCII-1 downto 0)
    );
end fsm;

architecture behavioral of fsm is
    type states is (idle, mux, adder, subtractor, multiplier, divider, sequential_state, display);
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
							nState <= mux;
						end if;
						z <= zero;
					when mux =>
						if error_flag = '1' then
							nState <= idle;
						else
							if operation = "00" then
								nState <= adder;
							elsif operation = "01" then
								nState <= subtractor;
							elsif operation = "10" then
								nState <= multiplier;
							else
								nState <= divider;
							end if;
						end if;
						z <= zero;
					when adder =>
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
					when subtractor =>
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
					when multiplier =>
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
					when divider =>
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
								nState <= adder;
							elsif operation = "01" then
								nState <= subtractor;
							elsif operation = "10" then
								nState <= multiplier;
							else
								nState <= divider;
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
