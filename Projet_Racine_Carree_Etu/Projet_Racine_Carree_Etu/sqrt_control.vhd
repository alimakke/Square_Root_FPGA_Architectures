library ieee;
use ieee.std_logic_1164.all;

entity sqrt_control is
  generic(N : natural := 64);
  port(
    clk     : in  std_logic;
    init    : in  std_logic;
    start   : in  std_logic;
    i_zero  : in  std_logic;
    comp_x_A: in  std_logic;

    -- sorties vers datapath
    ld_inputs  : out std_logic;
    do_iter    : out std_logic;
    shift_v    : out std_logic;
    capture_RR : out std_logic;

    done    : out std_logic
  );
end sqrt_control;

architecture fsm of sqrt_control is
  type state_type is (idle, init_dp, iter, finish);
  signal state : state_type := idle;
begin
  process(clk, init)
  begin
    if init='1' then
      state <= idle;
      ld_inputs <= '0';
      do_iter <= '0';
      shift_v <= '0';
      capture_RR <= '0';
      done <= '0';
    elsif rising_edge(clk) then
      ld_inputs <= '0';
      do_iter <= '0';
      shift_v <= '0';
      capture_RR <= '0';
      done <= '0';

      case state is
        when idle =>
          if start='1' then
            ld_inputs <= '1';
            state <= iter;
	else 
	   ld_inputs <= '0';
          end if;
        when iter =>
          do_iter <= '1';
          shift_v <= '1';
          if i_zero='1' then
            capture_RR <= '1';
            state <= finish;
          else
            state <= iter;  -- rester dans iter tant que i > 0
          end if;
        when finish =>
          done <= '1';
          state <= idle;
        when others =>
          state <= idle;
      end case;
    end if;
  end process;
end fsm;

