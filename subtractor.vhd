library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity subtractor is
    port (
        x: in std_logic_vector(47 downto 0);
        y: in std_logic_vector(47 downto 0);
        Result: out std_logic_vector(47 downto 0);
        error_flag: out std_logic
    );
end entity subtractor;

architecture behavioral of subtractor is
    signal x_bcd, y_bcd: std_logic_vector(47 downto 0);
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
    -- Konversi ASCII to BCD untuk X dan Y
    bcd_conversion: ascii_bcd
        port map (
            ascii_x_input => x,
            bcd_x_output => x_bcd,
            ascii_y_input => y,
            bcd_y_output => y_bcd
        ); 

    -- Subtractor dalam BCD
    process(x_bcd, y_bcd)
    variable temp_borrow: integer := 0;
    variable temp_diff: integer;
	variable temp_result : std_logic_vector(47 downto 0);
    begin
	temp_carry <= std_logic_vector(to_unsigned(0, temp_carry'length)); -- Initialize temp_carry

        -- Loop 4 BCD dari LSB ke MSB
        for i in 0 to 11 loop --DIMULAI DARI DIGIT TERENDAH
        temp_diff := to_integer(unsigned(x_bcd(i * BCD_group + BCD_group - 1 downto i * BCD_group))) - to_integer(unsigned(y_bcd(i * BCD_group + BCD_group - 1 downto i * BCD_group))) - temp_borrow;
            if (temp_diff >= 0) then --KETIKA DIGIT X > Y
                temp_diff := to_integer(unsigned(x_bcd(i * BCD_group + BCD_group - 1 downto i * BCD_group))) - to_integer(unsigned(y_bcd(i * BCD_group + BCD_group - 1 downto i * BCD_group))) - temp_borrow;
                temp_result (i * BCD_group + BCD_group - 1 downto i * BCD_group) := std_logic_vector(to_unsigned(temp_diff, BCD_group));
                temp_borrow := 0;
            else --KETIKA DIGIT X < Y, X AKAN DITAMBAH 10 DENGAN MEMINJAM DARI DIGIT SETELAHNYA
				temp_diff := (to_integer(unsigned(x_bcd(i * BCD_group + BCD_group - 1 downto i * BCD_group))) + 10 ) - to_integer(unsigned(y_bcd(i * BCD_group + BCD_group - 1 downto i * BCD_group)))- temp_borrow;
                temp_result(i * BCD_group + BCD_group - 1 downto i * BCD_group) := std_logic_vector(to_unsigned(temp_diff, BCD_group));
                temp_borrow := 1; --DIGIT SETELAHNYA AKAN DIKURANGI 1

            end if;
        end loop;

        -- Hasil ke Result 
        Result <= temp_result;

        -- Error case if the size is greater than 48 bits
        if sum_bcd'length > 48 then
            error_flag <= '1';
        else
            error_flag <= '0';
        end if;
    end process;

    -- BCD to ASCII conversion for BCD sum
	sum_ascii_conversion: bcd_ascii
		port map (
			bcd_input => sum_bcd,
			ascii_output => sum_ascii
		);
end architecture behavioral;
