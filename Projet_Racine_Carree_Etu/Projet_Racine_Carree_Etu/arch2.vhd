library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arch2 is
  generic(N: NATURAL := 64);
  port(
    A: in std_logic_vector(N-1 downto 0);
    start: in std_logic;
    init: in std_logic;
    clk: in std_logic;
    result: out std_logic_vector(N/2 - 1 downto 0);
    done: out std_logic
  );
end arch2;

architecture archi2 of arch2 is
  signal x : unsigned(N-1 downto 0);
  signal v : unsigned(N/2 - 1 downto 0);
  signal z : unsigned(N/2 - 1 downto 0);
  signal RR : unsigned(N/2 - 1 downto 0);
  signal AA: unsigned(N-1 downto 0) := (others => '0');
  type statetype is (s0, s1, s2, s3);
  signal state : statetype := s0;
  signal i : integer range -1 to N/2 := 0; 
begin
  
  process(clk, init)
    variable tempX : unsigned(63 downto 0);
  begin
    if init = '1' then
      x <= (others => '0');
      v <= (others => '0');
      z <= (others => '0');
      RR <= (others => '0');
      done <= '0';
      i <= 0;
      state <= s0;

    elsif rising_edge(clk) then
      case state is
        when s0 =>
          done <= '0';
          if start = '1' then
            AA <= unsigned(A);
            x <= shift_left(to_unsigned(1, N), N-2);
            v <= shift_left(to_unsigned(1, N/2), (N/2) - 2);
            z <= shift_left(to_unsigned(1, N/2), (N/2) - 1);
            i <= N/2 - 2;
            state <= s1;
          end if;

        when s1 =>
          if i >= 0 then
            i <= i - 1;
            if x > resize(AA, 64) then
              tempX := x + resize(v * (v - 2*z), 64);
              x <= tempX;
              z <= z - v;
            else
              tempX := x + resize(v * (v + 2*z), 64);
              x <= tempX;
              z <= z + v;
            end if;
            v <= shift_right(v,1);
          else
            state <= s2;
          end if;

        when s2 =>
          if x > resize(AA, 64) then
            RR <= z-1;
          else
            RR <= z;
          end if;
          done <= '1';
          state <= s0;

        when others =>
          state <= s0;
          done <= '0';
      end case;
    end if;
  end process;

  result <= std_logic_vector(RR);
end archi2;












