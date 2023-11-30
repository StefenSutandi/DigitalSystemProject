library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity serial_io is
    port (
        clk : in std_logic; -- Sinyal clock
        reset : in std_logic; -- Sinyal reset
        serial_in : in std_logic; -- Sinyal input serial
        serial_out : out std_logic; -- Sinyal output serial
        output_data : out signed(47 downto 0); -- Hasil operasi (maksimal 12 digit)
        error_flag : out std_logic -- Flag error
    );
end serial_io;

architecture behavioral of serial_io is
    signal x, y : signed(15 downto 0); -- Input bilangan pertama dan kedua
    signal operation : std_logic; -- Jenis operasi (+, -, /, *)
    signal sequential_process : std_logic; -- Pilihan pemrosesan sekuensial
    signal result : signed(15 downto 0); -- Hasil operasi
    signal receive_data : std_logic_vector(15 downto 0); -- Data yang diterima secara serial
    signal transmit_data : std_logic_vector(15 downto 0); -- Data yang akan dikirim secara serial
    signal data_ready : std_logic := '0'; -- Flag untuk menandakan data siap dikirim
    signal transmit_counter : integer range 0 to 9 := 0; -- Counter untuk pengiriman data serial
begin
    -- Proses untuk melakukan operasi kalkulator dan komunikasi serial
    calculator_process : process (clk, reset)
    begin
        if reset = '1' then -- Reset pada kondisi tertentu
            -- Reset semua sinyal
            x <= (others => '0');
            y <= (others => '0');
            operation <= '0';
            sequential_process <= '0';
            result <= (others => '0');
            receive_data <= (others => '0');
            transmit_data <= (others => '0');
            data_ready <= '0';
            transmit_counter <= 0;
            error_flag <= '0';
        elsif rising_edge(clk) then
            -- Baca data yang diterima secara serial
            if serial_in = '1' then
                receive_data <= receive_data(6 downto 0) & serial_in; -- Simpan data yang diterima
                if receive_data(7) = '1' then -- Data diterima lengkap
                    case transmit_counter is
                        when 0 =>
                            x <= signed(receive_data(3 downto 0)); -- Ambil Input X
                            y <= signed(receive_data(7 downto 4)); -- Ambil Input Y
                        when 1 =>
                            case receive_data(3 downto 0) is
                                when "0000" => operation <= '+'; -- Penjumlahan
                                when "0001" => operation <= '-'; -- Pengurangan
                                when "0010" => operation <= '/'; -- Pembagian
                                when "0011" => operation <= '*'; -- Perkalian
                                when others => null; -- Do nothing
                            end case;
                            sequential_process <= receive_data(4); -- Ambil pilihan pemrosesan sekuensial
                        when others =>
                            null; -- Do nothing
                    end case;
                    transmit_counter <= transmit_counter + 1; -- Increment counter
                    receive_data <= (others => '0'); -- Reset data yang diterima
                end if;
            end if;
            
            -- Lakukan operasi kalkulator
            if data_ready = '1' then
                case operation is
                    when '+' =>
                        result <= x + y; -- Penjumlahan
                    when '-' =>
                        result <= x - y; -- Pengurangan
                    when '/' =>
                        if y /= 0 then
                            result <= x / y; -- Pembagian
                        else
                            error_flag <= '1'; -- Error jika pembagian dengan nol
                        end if;
                    when '*' =>
                        result <= x * y; -- Perkalian
                    when others =>
                        null; -- Do nothing
                end case;
                
                data_ready <= '0'; -- Reset flag data siap dikirim setelah pengolahan selesai
            end if;
        end if;
    end process;

    -- Proses untuk mengirim hasil operasi secara serial
    serial_transmit : process (clk)
    begin
        if rising_edge(clk) then
            if transmit_counter = 2 and data_ready = '0' then
                -- Kondisi saat data siap dikirim
                transmit_data <= std_logic_vector(result); -- Kirim hasil operasi
                data_ready <= '1'; -- Set flag data siap dikirim
            end if;
            
            if transmit_counter < 10 then
                -- Kirim data secara serial
                serial_out <= transmit_data(transmit_counter);
                transmit_counter <= transmit_counter + 1; -- Increment counter
            else
                serial_out <= '0'; -- Set sinyal output serial menjadi 0 setelah pengiriman selesai
            end if;
        end if;
    end process;
    
    -- Output hasil operasi
    output_data <= result;
end behavioral;