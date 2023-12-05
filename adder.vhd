library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity adder is
  port (
    Clk, reset_count, Load : in  std_logic;
    A, B              : in  std_logic_vector(13 downto 0);
    Ready             : out std_logic;
    Sum               : out std_logic_vector(13 downto 0)
  );
end entity;

architecture behavioral of adder is
  type states is (Idle, S_XOR, S_XNOR);
  signal state, state_next : states;

  signal Ashift, Ashift_next   : std_logic_vector(13 downto 0);
  signal Bshift, Bshift_next   : std_logic_vector(13 downto 0);
  signal SumShift, SumShift_next : std_logic_vector(13 downto 0);

  signal count, next_count : integer range 0 to 14;
  signal Carry         : std_logic;
begin
  sequential: process (clk, reset_count) is
  begin
    if clk'event and clk = '1' then
      if reset_count = '1' then
        state <= Idle;
        Ashift <= (others => '0');
        Bshift <= (others => '0');
        SumShift <= (others => '0');
        count <= 0;
      else
        state <= state_next;
        Ashift <= Ashift_next;
        Bshift <= Bshift_next;
        SumShift <= SumShift_next;
        count <= next_count;
      end if;
    end if;
  end process;

  combinational: process (state, Ashift, Bshift, SumShift, count, next_count, Load, A, B) is
    variable Carry: std_logic;
  begin
    Ashift_next <= Ashift;
    Bshift_next <= Bshift;
    SumShift_next <= SumShift;
    next_count <= count;
    ready <= '0';

    case state is
      when Idle =>
        ready <= '1';
        if Load = '1' then
          Ashift_next <= A;
          Bshift_next <= B;
          SumShift_next <= (others => '0');
          next_count <= 14;
          state_next <= S_XOR;
        else
          state_next <= Idle;
        end if;
      when S_XOR =>
        Carry := Ashift(0) xor Bshift(0);

        Ashift_next <= Ashift(13) & Ashift(13 downto 1);
        Bshift_next <= Bshift(13) & Bshift(13 downto 1);
        SumShift_next <= Carry & SumShift(13 downto 1);
        next_count <= count - 1;

        if next_count = 0 then
          state_next <= Idle;
        elsif (Ashift(0) = '1' and Bshift(0) = '1') then
          state_next <= S_XNOR;
        else
          state_next <= S_XOR;
        end if;
      when S_XNOR =>
        Carry := not (Ashift(0) xor Bshift(0));

        Ashift_next <= Ashift(13) & Ashift(13 downto 1);
        Bshift_next <= Bshift(13) & Bshift(13 downto 1);
        SumShift_next <= Carry & SumShift(13 downto 1);
        next_count <= count - 1;

        if next_count = 0 then
          state_next <= Idle;
        elsif (Ashift(0) = '0' and Bshift(0) = '0') then
          state_next <= S_XOR;
        else
          state_next <= S_XNOR;
        end if;
    end case;
  end process;

  sum <= SumShift;

end architecture;
