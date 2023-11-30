library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.all;

entity kalkulator is -- Set as top-level-entity
    port (
        input_x, input_y: in std_logic_vector(47 downto 0);
        operation_choice: in std_logic_vector(1 downto 0);
        sequential_mode: in std_logic_vector(1 downto 0);
        output_data: out std_logic_vector(47 downto 0);
        display_error: out std_logic
    );
end kalkulator;

architecture kalkulator_arc of kalkulator is

component serial_io is
    port (
        clk : in std_logic; -- Sinyal clock
        reset : in std_logic; -- Sinyal reset
        serial_in : in std_logic; -- Sinyal input serial
        serial_out : out std_logic; -- Sinyal output serial
        output_data : out signed(15 downto 0); -- Hasil operasi (maksimal 12 digit)
        error_flag : out std_logic -- Flag error
    );
end component;

component fsm is
    port(
        rst, clk, proceed: in std_logic;
        comparison: in std_logic_vector( 1 downto 0 );
        enable, xsel, ysel, xld, yld: out std_logic
        );
end component;
        
component regis is
    port(
        rst, clk, load: in std_logic;
		input: in std_logic_vector( 3 downto 0 );
		output: out std_logic_vector( 3 downto 0 )
        );
end component;

component mux is
    port(
        selector : in std_logic_vector(1 downto 0);
        adder, subtractor, multiplier, divider : in signed(3 downto 0); 
        output_selector : out signed(3 downto 0) 
        );
end component;

component comparator_input is
    port (
        ascii_x_input: in std_logic_vector(15 downto 0); -- Input x (ASCII)
        ascii_y_input: in std_logic_vector(15 downto 0); -- Input y (ASCII)
        error_flag: out std_logic;  -- Output error flag
        bcd_x_output: out std_logic_vector(15 downto 0); -- Output BCD for x
        bcd_y_output: out std_logic_vector(15 downto 0)  -- Output BCD for y
    );
end component;

component ascii_bcd is
    port (
        ascii_x_input: in std_logic_vector(15 downto 0); -- Input ASCII (48-bit)
        ascii_y_input: in std_logic_vector(15 downto 0); -- Input ASCII (48-bit)
        bcd_x_output: out std_logic_vector(15 downto 0); -- Output BCD (12-digit x 4-bit each)
        bcd_y_output: out std_logic_vector(15 downto 0) -- Output BCD (12-digit x 4-bit each)
    );
end component;

component adder is
    port (
        x: in integer range 0 to 999_999_999_999; -- Maximum 12 digit input
        y: in integer range 0 to 999_999_999_999;
        sum_bcd: out std_logic_vector(15 downto 0);
        carry_out: out std_logic;
        error_flag: out std_logic
    );
end component;

component subtractor is
    port (
        x: in integer range 0 to 999_999_999_999; -- Maximum 12 digit input
        y: in integer range 0 to 999_999_999_999;
        difference_bcd: out std_logic_vector(47 downto 0);
        borrow_out: out std_logic;
        error_flag: out std_logic
    );
end component;

component multiplier is
    port (
        x: in integer range 0 to 999_999_999_999; 
        y: in integer range 0 to 999_999_999_999;
        error_flag: out std_logic;  -- Output error flag
        output_result: out std_logic_vector(48 downto 0) -- Output result (48-bit + 1 sign bit)
    );
end component;

component divider is
    port (
        x: in integer range 0 to 999_999_999_999; 
        y: in integer range 0 to 999_999_999_999;
        error_flag: out std_logic;  -- Output error flag
        output_result: out std_logic_vector(48 downto 0) -- Output result (48-bit + 1 sign bit)
    );
end component;

component bcd_ascii is
    port (
        bcd_x_input: in std_logic_vector(15 downto 0); -- Input BCD (12-digit x 4-bit each)
        bcd_y_input: in std_logic_vector(15 downto 0); -- Input BCD (12-digit x 4-bit each)
        ascii_x_output: out std_logic_vector(15 downto 0); -- Output ASCII (48-bit)
        ascii_y_output: out std_logic_vector(15 downto 0) -- Output ASCII (48-bit)
    );
end component;

component comparator_output is
    port (
        bcd_input: in std_logic_vector(15 downto 0); -- Input BCD from mux (48 + 1 bits for sign)
        ascii_output: out std_logic_vector(8 downto 0); -- Output ASCII (+1 for sign bit)
        error_flag: out std_logic  -- Output error flag
    );
end component;

begin
	--REPRESENTASI PORT MAP
	X_SER 		: serial_io port map(x_bcd, y_bcd, sum_bcd, carry, temp_carry);
	X_FSM 		: fsm port map(cState, nState, states, zAdder, zSubtractor, zMultiplier, zDivider, zResult, newX);
	X_REGIS		: regis port map(input,output);
	X_MUX		: mux port map(temp_output);
	X_COM_IN	: comparator_input port map(x_bcd,y_bcd);
	X_AS_BCD	: ascii_bcd port map(ascii_x_input, ascii_y_input, bcd_x_input, bcd_y_input);
	X_ADD		: adder port map(x_bcd, y_bcd, sum_bcd, carry, temp_carry);
	X_SUB		: subtractor port map(x_bcd, y_bcd, difference_bcd, borrow);
	X_MULTI		: multiplier port map(x_bcd, y_bcd, x_multi, y_multi, sum_bcd, temp_multi, carry, temp_carry);
	X_DIV		: divider port map(x_bcd, y_bcd, result_bcd);
	X_BCD_AS	: bcd_ascii port map(bcd_x_input, bcd_y_input, ascii_x_output, ascii_y_output);
	X_COM_OUT	: comparator_out port map(bcd_value);

	result <= temp_output;
	
end architecture kalkulator_arc;