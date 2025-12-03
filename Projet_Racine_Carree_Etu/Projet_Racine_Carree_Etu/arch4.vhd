library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arch4 is
  generic (
    N : natural := 64
  );
  port (
    clk    : in  std_logic;                                 -- horloge
    A      : in  std_logic_vector(N-1 downto 0);            -- entrée
    result : out std_logic_vector(N/2 - 1 downto 0)         -- sortie
  );
end arch4;

architecture archi4 of arch4 is
  signal A_reg     : std_logic_vector(N-1 downto 0);
  signal result_int: std_logic_vector(N/2 - 1 downto 0);
  signal result_reg: std_logic_vector(N/2 - 1 downto 0);
begin


  process(clk)
  begin
    if rising_edge(clk) then
      A_reg <= A;  
    end if;
  end process;


  process(A_reg)
    variable AA     : unsigned(N-1 downto 0);
    variable v      : unsigned(N-1 downto 0);
    variable z      : unsigned(N-1 downto 0);
    variable tempX  : unsigned(N-1 downto 0);
    variable tempY  : unsigned(N-1 downto 0);
    variable i      : integer;
  begin
    AA := unsigned(A_reg);
    z  := (others => '0');
    v  := shift_left(to_unsigned(1, N), N - 2);

    for i in 0 to N/2 - 1 loop
      tempX := z + v;
      if AA >= tempX then
        AA := AA - tempX;
        tempY := tempX + v;
      else
        tempY := tempX - v;
      end if;
      v := shift_right(v, 2);
      z := shift_right(tempY, 1);
    end loop;

    result_int <= std_logic_vector(resize(z, N/2));
  end process;


  process(clk)
  begin
    if rising_edge(clk) then
      result_reg <= result_int;  
    end if;
  end process;


  result <= result_reg;

end architecture archi4;
