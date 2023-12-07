library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity adder is
  port (
    Clk, reset_count, Load : in  std_logic;
    X, Y              : in  std_logic_vector(13 downto 0);
    Ready             : out std_logic;
    Sum               : out std_logic_vector(13 downto 0);
    error_flag		  : out std_logic
  );
end entity;

architecture behavioral of adder is
  type states is (Idle, S_Cout0, S_Cout1);
  signal state, state_next : states;

  signal Xshift, Xshift_next   : std_logic_vector(13 downto 0);
  signal Yshift, Yshift_next   : std_logic_vector(13 downto 0);
  signal SumShift, SumShift_next : std_logic_vector(13 downto 0);

  signal count, next_count : integer range 0 to 14;
  signal Carry         : std_logic;
begin
  sequential: process (clk, reset_count) is
  begin
    if clk'event and clk = '1' then
      if reset_count = '1' then
        state <= Idle;
        XShift <= (others => '0');
        YShift <= (others => '0');
        SumShift <= (others => '0');
        count <= 0;
      else
        state <= state_next;
        XShift <= XShift_next;
        YShift <= YShift_next;
        SumShift <= SumShift_next;
        count <= next_count;
      end if;
    end if;
  end process;

  combinational: process (state, Load, X, Y, Xshift, Yshift, SumShift, count, next_count) is
    variable Carry: std_logic;
  begin
    XShift_next <= XShift;
    YShift_next <= YShift;
    SumShift_next <= SumShift;
    next_count <= count;
    ready <= '0';

    case state is
      when Idle =>
        ready <= '1';
        if Load = '1' then
          XShift_next <= X;
          YShift_next <= Y;
          SumShift_next <= (others => '0');
          next_count <= 14;
          state_next <= S_Cout0;
        else
          state_next <= Idle;
        end if;
      when S_Cout0 =>
        Carry := XShift(0) xor YShift(0);

        XShift_next <= '0' & XShift(13 downto 1);
        YShift_next <= '0' & YShift(13 downto 1);
        SumShift_next <= Carry & SumShift(13 downto 1);
        next_count <= count - 1;

        if next_count = 0 then
          state_next <= Idle;
        elsif (XShift(0) = '1' and YShift(0) = '1') then
          state_next <= S_Cout1;
        else
          state_next <= S_Cout0;
        end if;
      when S_Cout1 =>
        Carry := not (XShift(0) xor YShift(0));

        XShift_next <= '0' & XShift(13 downto 1);
        YShift_next <= '0' & YShift(13 downto 1);
        SumShift_next <= Carry & SumShift(13 downto 1);
        next_count <= count - 1;

        if next_count = 0 then
          state_next <= Idle;
        elsif (XShift(0) = '0' and YShift(0) = '0') then
          state_next <= S_Cout0;
        else
          state_next <= S_Cout1;
        end if;
    end case;
  end process;

  sum <= SumShift;
  process (SumShift)
  begin
    if SumShift > "10011100001111" then
      error_flag <= '1';
    else
      error_flag <= '0';
    end if;
  end process;
  
end architecture;