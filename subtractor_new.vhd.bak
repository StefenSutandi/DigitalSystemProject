library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity subtractor is
    port (
        x: in integer range 0 to 999_999_999_999; -- Maximum 12 digit input
        y: in integer range 0 to 999_999_999_999;
        Result: out std_logic_vector(47 downto 0);
		);
end entity subtractor;

architecture behavioral of subtractor is
    signal x_bcd, y_bcd: std_logic_vector(47 downto 0);
    constant BCD_group : integer := 4;
begin
    -- ASCII to BCD conversion for X and Y
    x_bcd_conversion: entity kalkulator.ascii_bcd
        port map (
            ascii_input => x,
            bcd_output => x_bcd
        );

    y_bcd_conversion: entity kalkulator.ascii_bcd
        port map (
            ascii_input => y,
            bcd_output => y_bcd
        );
	process(x_bcd, y_bcd)
    variable temp_borrow: integer := 0;
    variable temp_diff: integer;
	variable temp_result : std_logic_vector(7 downto 0);
	begin
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
		Result <= temp_result;
     end process;
 end behavioral;