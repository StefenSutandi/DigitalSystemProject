library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity kalkulator is
    port(
        clk: in std_logic;
        reset: in std_logic;
        input_valid: in std_logic;
        input_data: in std_logic_vector(47 downto 0);
        operation_choice: in std_logic_vector(1 downto 0);
        sequential_mode: in std_logic;
        output_valid: out std_logic;
        output_data: out std_logic_vector(47 downto 0);
        error_flag: out std_logic;
        display_error: out std_logic
        );
end kalkulator;

architecture kalkulator_arc of kalkulator is

component serial is
    port(
        clk: in std_logic;
        reset: in std_logic;
        data_in: in std_logic;
        data_out: out std_logic
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

component comparator is
    port (
        ascii_x_input: in std_logic_vector(7 downto 0); -- Input x (ASCII)
        ascii_y_input: in std_logic_vector(7 downto 0); -- Input y (ASCII)
        error_flag: out std_logic;  -- Output error flag
        bcd_x_output: out std_logic_vector(3 downto 0); -- Output BCD for x
        bcd_y_output: out std_logic_vector(3 downto 0)  -- Output BCD for y
    );
end component;

component ascii_bcd is
    port(
        ascii_x_input: in std_logic_vector(7 downto 0); -- Input x (ASCII)
        ascii_y_input: in std_logic_vector(7 downto 0); -- Input y (ASCII)
        bcd_x_output: out std_logic_vector(3 downto 0); -- Output BCD for x
        bcd_y_output: out std_logic_vector(3 downto 0)  -- Output BCD for y
    );
end component;

component adder is
    port(
        x, y: in std_logic_vector(3 downto 0);
        output: out std_logic_vector(3 downto 0)
    );
end component;

component subtractor is
    port(
        x, y: in std_logic_vector(3 downto 0);
        output: out std_logic_vector(3 downto 0)
    );
end component;

component multiplier is
    port(
        x, y: in std_logic_vector(3 downto 0);
        output: out std_logic_vector(3 downto 0)
    );
end component;

component divider is
    port(
        x, y: in std_logic_vector(3 downto 0);
        output: out std_logic_vector(3 downto 0)
    );
end component;

component bcd_ascii is
    port(
        bcd_input: in std_logic_vector(3 downto 0);
        ascii_output: out std_logic_vector(7 downto 0)
    );
end component;

end kalkulator_arc