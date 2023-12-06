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
        clock, reset : in std_logic;
        input_x : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
        input_y : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
        operation_choice: in std_logic_vector(1 downto 0);
        output_data: out std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
        display_error: out std_logic
    );
end entity kalkulator;

architecture kalkulator_arc of kalkulator is

    signal x_bcd, y_bcd: std_logic_vector(DATA_WIDTH_BCD-1 downto 0);
    signal x_bin, y_bin: std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
    signal result_add, result_sub, result_mul, result_div: std_logic_vector(13 downto 0);
    signal output_ascii: std_logic_vector(31 downto 0);
    signal temp_output : std_logic_vector(13 downto 0);



  component mux is
        port( 
            selector : in std_logic_vector(1 downto 0);
            adder, subtractor, multiplier, divider : in std_logic_vector (13 downto 0); 
            output_selector : out std_logic_vector(13 downto 0) 
        );
    end component;


    component ascii_bin is
        port(
            x_ascii_in : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
            y_ascii_in : in std_logic_vector(DATA_WIDTH_ASCII-1 downto 0);
            x_bin_out : out std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
            y_bin_out : out std_logic_vector(DATA_WIDTH_BIN-1 downto 0)
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
            hasil : out std_logic_vector(DATA_WIDTH_BIN-1 downto 0)
        );
    end component;

    component divider is
        port (
            dividend : in std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
            divisor : in std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
            quotient : out std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
            error_flag: out std_logic
        );	
    end component;

    component bin_ascii is
        port(
            x_bin_in : in std_logic_vector(DATA_WIDTH_BIN-1 downto 0);
            x_ascii_out : out std_logic_vector(DATA_WIDTH_ASCII-1 downto 0)
        );
    end component;

  
    
begin
    -- REPRESENTASI PORT MAP

  
    X_MUX : mux
        port map (
            selector => operation_choice,
            adder => result_add,
            subtractor => result_sub,
            multiplier => result_mul,
            divider => result_div,
            output_selector => temp_output
        );    

    X_AS_BIN : ascii_bin    
        port map (
            x_ascii_in => input_x,
            y_ascii_in => input_y,
            x_bin_out => x_bin,
            y_bin_out => y_bin
        );

    X_ADD : adder
        port map (
            Clk => clock,
            reset_count => reset,
            Load => '1', 
            X => x_bin,
            Y => y_bin,
            Ready => open,
            Sum => result_add
        );

    X_SUB : subtractor 
        port map(
            clk => clock,
            x => x_bin,
            y => y_bin,
            Result => result_sub
        );

    X_MULTI : multiplierbin 
        port map(
            x => x_bin,
            y => y_bin,
            hasil => result_mul
        );

    X_DIV : divider 
        port map(
            dividend => x_bin,
            divisor => y_bin,
            quotient => result_div,
            error_flag => display_error
        );

    X_BIN_AS : bin_ascii 
        port map(
            x_bin_in => temp_output, 
            x_ascii_out => output_ascii
        );


    output_data <= output_ascii;

end architecture kalkulator_arc;
