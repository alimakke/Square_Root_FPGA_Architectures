library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sqrt_top is
  generic(N: natural := 64);
  port(
    clk   : in std_logic;
    init  : in std_logic;
    start : in std_logic;
    A     : in std_logic_vector(N-1 downto 0);
    result: out std_logic_vector(N/2-1 downto 0);
    done  : out std_logic
  );
end sqrt_top;

architecture rtl of sqrt_top is
  signal ld_inputs, do_iter, shift_v, capture_RR : std_logic;
  signal i_zero, comp_x_A                        : std_logic;
  signal RR_internal                             : unsigned(N/2-1 downto 0);
begin

  DP: entity work.sqrt_datapath
    generic map(N=>N)
    port map(
      clk => clk,
      init => init,
      A => A,
      ld_inputs => ld_inputs,
      do_iter => do_iter,
      shift_v => shift_v,
      capture_RR => capture_RR,
      i_zero => i_zero,
      comp_x_A => comp_x_A,
      RR_out => RR_internal
    );

  CU: entity work.sqrt_control
    generic map(N=>N)
    port map(
      clk => clk,
      init => init,
      start => start,
      i_zero => i_zero,
      comp_x_A => comp_x_A,
      ld_inputs => ld_inputs,
      do_iter => do_iter,
      shift_v => shift_v,
      capture_RR => capture_RR,
      done => done
    );

  result <= std_logic_vector(RR_internal);
end rtl;
