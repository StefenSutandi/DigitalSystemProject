library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.all;

entity kalkulator is
    generic (
        DATA_WIDTH_ASCII : positive := 32;
        DATA_WIDTH_BCD : positive := 16;
        DATA_WIDTH_BIN : positive := 14
    );
    port (
        input_x : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
        input_y : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
        operation_choice: in std_logic_vector(1 downto 0);
        sequential_mode: in std_logic_vector(13 downto 0);
        output_data: out std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
        display_error: out std_logic
    );
end entity kalkulator;

architecture kalkulator_arc of kalkulator is

    type states is (idle, mux1, adder1, subtractor1, multiplier1, divider1, sequential_state, display);
    signal reset, clock : std_logic;
    signal sequential_mode1 : std_logic_vector(13 downto 0);
    signal temp_output : signed(3 downto 0); 
    signal adder_mux, subtractor_mux, multiplier_mux, divider_mux: signed(DATA_WIDTH_BIN-1 downto 0);
    signal x_bcd, y_bcd: std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
    signal x_bin, y_bin: std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
    signal result: std_logic_vector(13 downto 0);
    signal output_ascii: std_logic_vector(7 downto 0);

    component fsm is
        port (
            reset : in std_logic;
            clock : in std_logic;      
            y : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);     
            operation : in std_logic_vector(1 downto 0);
            sequential_mode1 : in std_logic_vector(13 downto 0);
            error_flag : buffer std_logic;
            cState, nState: in states;
            x : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
            z : buffer std_logic_vector(DATA_WIDTH_ASCII-1 downto 0)
        );
    end component;

    component mux is
        port (
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

    component ascii_bcdo is
        port (
            input_ascii_x : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
            input_ascii_y : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
            output_bcd_x : out std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
            output_bcd_y : out std_logic_vector(DATA_WIDTH_BCD-1 downto 0)
        );
    end component;

    component bcd_bin is
        port (
            x_bcd : in std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
            y_bcd : in std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
            x_bin : out std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
            y_bin : out std_logic_vector(DATA_WIDTH_BIN-1 downto 0)
        );
    end component;

    component adder is
        port (
            Clk, reset_count, Load : in  std_logic;
            X, Y              : in  std_logic_vector(13 downto 0);
            Ready             : out std_logic;
            Sum               : out std_logic_vector(13 downto 0)
        );
    end component;

    component subtractor is
        port (
            clk: in std_logic;
            x, y: in std_logic_vector(13 downto 0);
            Result: out std_logic_vector(13 downto 0)
        );
    end component;

    component multiplierbin is
        port (
            x :    in std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
            y :    in std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
            hasil : out std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
            error_flag : out std_logic
        );
    end component;

    component divider is
        port (
            dividend_ascii : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
            divisor_ascii : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
            quotient_ascii : out std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
            error_flag : out std_logic
        );
    end component;

    component bin_bcd is
        port (
            hasil_bin : in std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
            hasil_bcd : out std_logic_vector(DATA_WIDTH_BCD-1 downto 0)
        );
    end component;

    component bcd_ascii is
        port (
            bcd_input : in STD_LOGIC_VECTOR(DATA_WIDTH_BCD-1 downto 0);
            ascii_output : out STD_LOGIC_VECTOR(DATA_WIDTH_ASCII-1 downto 0)
        );
    end component;

    component comparator_output is
        port (
            bcd_input: in std_logic_vector(15 downto 0); -- Input BCD from mux (48 + 1 bits for sign)
            ascii_output: out std_logic_vector(8 downto 0); -- Output ASCII (+1 for sign bit)
            error_flag: out std_logic  -- Output error flag
        );
    end component;

    signal cState, nState: states;
    signal zAdder, zSubtractor, zMultiplier, zDivider, zResult, newX: std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);

begin
    -- REPRESENTASI PORT MAP
    X_FSM : fsm
        port map (
            reset => reset,
            clock => clock,
            y => input_y,
            operation => operation_choice,
            sequential_mode1 => sequential_mode1,
            error_flag => display_error,
            cState => cState,
            nState => nState,
            x => input_x,
            z => output_data
        );
  
    X_MUX : mux
        port map (
            selector => operation_choice,
            adder => adder_mux,
            subtractor => subtractor_mux,
            multiplier => multiplier_mux,
            divider => divider_mux,
            output_selector => temp_output
        );    

    X_COM_IN : comparator_input port map(x_bcd, y_bcd);

    X_AS_BCD : ascii_bcdo    
        port map (
            input_ascii_x => input_x,
            input_ascii_y => input_y,
            output_bcd_x => x_bcd,
            output_bcd_y => y_bcd
        );

    X_ADD : adder
        port map (
            Clk => clock,
            reset_count => reset,
            Load => '1', 
            X => x_bin,
            Y => y_bin,
            Ready => open,
            Sum => result
        );

    X_SUB : subtractor 
        port map(
            clk => clock,
            x => x_bin,
            y => y_bin,
            Result => result
        );

    X_MULTI : multiplierbin 
        port map(
            x => x_bin,
            y => y_bin,
            hasil => result,
            error_flag => open
        );

    X_DIV : divider 
        port map(
            dividend_ascii => x_bin,
            divisor_ascii => y_bin,
            quotient_ascii => result,
            error_flag => display_error
        );

    X_BCD_AS : bcd_ascii 
        port map(
            bcd_input => x_bcd, 
            ascii_output => output_ascii
        );

    X_COM_OUT : comparator_output 
        port map(
            bcd_input => x_bcd, 
            ascii_output => output_ascii,
            error_flag => display_error
        );

        result <= std_logic_vector(temp_output);

end architecture kalkulator_arc;
