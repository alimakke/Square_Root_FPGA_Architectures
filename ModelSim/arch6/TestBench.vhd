library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity tb_sqrt_top is
end tb_sqrt_top;

architecture sim of tb_sqrt_top is
  constant N : natural := 64;

  signal clk    : std_logic := '0';
  signal init   : std_logic := '0';
  signal start  : std_logic := '0';
  signal A      : std_logic_vector(N-1 downto 0) := (others=>'0');
  signal result : std_logic_vector(N/2-1 downto 0);
  signal done   : std_logic;

  constant clk_period : time := 10 ns;

begin

  -- Clock generation
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  -- DUT instantiation
  DUT: entity work.sqrt_top(rtl)
    generic map(N=>N)
    port map(
      clk => clk,
      init => init,
      start => start,
      A => A,
      result => result,
      done => done
    );

  -- Test process
  stim_proc: process
    variable int_A  : integer;
    variable sqrt_A : integer;
  begin
    -- Reset
    init <= '1';
    wait for clk_period;
    init <= '0';
    wait for clk_period;

    -- Test values
    for int_A in 0 to 100 loop   -- plage de test simple
      A <= std_logic_vector(to_unsigned(int_A, N));
      start <= '1';
      wait for clk_period;
      start <= '0';

      -- wait until done
      wait until done='1';

      -- Correction: utiliser to_integer(unsigned(...))
      sqrt_A := to_integer(unsigned(result));


      wait for 5*clk_period;
    end loop;

    report "Simulation finished";
    wait;
  end process;

end sim;

