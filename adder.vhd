library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder is
    port (
        x: in std_logic_vector(15 downto 0);
        y: in std_logic_vector(15 downto 0);
        carry_out: out std_logic;
        sum_bcd: out std_logic_vector(15 downto 0);
        error_flag: out std_logic
    );
end entity adder;

architecture behavioral of adder is
    signal x_bcd, y_bcd: std_logic_vector(15 downto 0);
    signal sum_bcd1: std_logic_vector(15 downto 0);
    signal carry: std_logic := '0';  
    signal temp_carry: std_logic_vector(3 downto 0) := (others => '0');  -- Signal utk carry sementara
    constant BCD_group : integer := 4;

component ascii_bcd is
    port(
        ascii_x_input: in std_logic_vector(7 downto 0); -- Input x (ASCII)
        ascii_y_input: in std_logic_vector(7 downto 0); -- Input y (ASCII)
        bcd_x_output: out std_logic_vector(3 downto 0); -- Output BCD  x
        bcd_y_output: out std_logic_vector(3 downto 0)  -- Output BCD  y
    );
end component;   

component bcd_ascii is
    port (
        bcd_x_input: in std_logic_vector(7 downto 0); -- Input BCD (12-digit x 4-bit)
        bcd_y_input: in std_logic_vector(7 downto 0); -- Input BCD (12-digit x 4-bit)
        ascii_x_output: out std_logic_vector(3 downto 0); -- Output ASCII (48-bit)
        ascii_y_output: out std_logic_vector(3 downto 0) -- Output ASCII (48-bit)
    );
end component;

begin
    -- Konversi ASCII ke BCD untuk X dan Y
    bcd_conversion: ascii_bcd
        port map (
            ascii_x_input => x,
            bcd_x_output => x_bcd,
            ascii_y_input => y,
            bcd_y_output => y_bcd
        ); 

    -- Adder dalam BCD
    process(x_bcd, y_bcd)
        variable temp_sum: integer;
        variable temp_result: std_logic_vector(15 downto 0);
    begin
	temp_carry <= std_logic_vector(to_unsigned(0, temp_carry'length)); -- Initialize temp_carry

        -- Loop per 4 BCD bit dari LSB ke MSB
        for i in 3 downto 0 loop
		temp_sum := to_integer(unsigned(x_bcd(i * BCD_group + BCD_group - 1 downto i * BCD_group))) +
					to_integer(unsigned(y_bcd(i * BCD_group + BCD_group - 1 downto i * BCD_group))) +
					to_integer(unsigned(temp_carry));

            if temp_sum < 10 then
                temp_result(i * BCD_group + BCD_group - 1 downto i * BCD_group) := std_logic_vector(to_unsigned(temp_sum, BCD_group));
                temp_carry <= std_logic_vector(to_unsigned(0, temp_carry'length));

            else
                temp_result(i * BCD_group + BCD_group - 1 downto i * BCD_group) := std_logic_vector(to_unsigned(temp_sum + 6, BCD_group));
                temp_carry <= std_logic_vector(to_unsigned(1, temp_carry'length));

            end if;
        end loop;

        -- Hasil masuk ke signal sum_bcd
        sum_bcd <= temp_result;

        -- Error case untuk hasil lebih besar dari 16 bit
        if sum_bcd'length > 16 then
            error_flag <= '1';
        else
            error_flag <= '0';
        end if;
    end process;

    -- Konversi BCD ke ASCII untuk sum_bcd
	sum_ascii_conversion: bcd_ascii
		port map (
			bcd_input => sum_bcd,
			ascii_output => sum_ascii
		);
end architecture behavioral;
