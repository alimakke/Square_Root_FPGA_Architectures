library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sqrt_datapath is
  generic(N : natural := 64);
  port(
    clk        : in  std_logic;
    init       : in  std_logic;
    A          : in  std_logic_vector(N-1 downto 0);

    -- commandes de la CU
    ld_inputs  : in  std_logic;
    do_iter    : in  std_logic;
    shift_v    : in  std_logic;
    capture_RR : in  std_logic;

    -- statut vers CU
    i_zero     : out std_logic;
    comp_x_A   : out std_logic;

    -- sortie finale
    RR_out     : out unsigned(N/2-1 downto 0)
  );
end sqrt_datapath;

architecture rtl of sqrt_datapath is
  -- signaux internes
  signal x_sig, x_next  : unsigned(N-1 downto 0) := (others=>'0');
  signal z_sig, z_next  : unsigned(N/2-1 downto 0) := (others=>'0');
  signal v              : unsigned(N/2-1 downto 0) := (others=>'0');
  signal AA             : unsigned(N-1 downto 0) := (others=>'0');
  signal RR             : unsigned(N/2-1 downto 0) := (others=>'0');
  signal i              : integer range -1 to N/2 := 0;

begin

  -- comparaisons combinatoires
 -- comp_x_A <= '1' when x_sig > AA else '0';
  i_zero   <= '1' when i = 0 else '0';
  RR_out   <= RR;

  -- instanciation du bloc sqrt_calc
  calc_inst: entity work.sqrt_calc
    port map(
      x_in    => x_sig,
      z_in    => z_sig,
      v_in    => v,
      AA_in   => AA,
      do_iter => do_iter,
      x_out   => x_next,
      z_out   => z_next
    );

  -- process principal du datapath
  process(clk, init)
  begin
    if init = '1' then
      x_sig <= (others=>'0');
      z_sig <= (others=>'0');
      v     <= (others=>'0');
      AA    <= (others=>'0');
      RR    <= (others=>'0');
      i     <=  N/2 - 2;
    elsif rising_edge(clk) then
      if ld_inputs = '1' then
        AA    <= unsigned(A);
        x_sig <= shift_left(to_unsigned(1,N), N-2);
        v     <= shift_left(to_unsigned(1,N/2), (N/2)-2);
        z_sig <= shift_left(to_unsigned(1,N/2), (N/2)-1);
        i     <= N/2 - 2;
      --  RR    <= (others=>'0');
      elsif do_iter = '1' then
        -- mise à jour depuis sqrt_calc
        x_sig <= x_next;
        z_sig <= z_next;

        -- shift v et decrement i
        if shift_v = '1' then
          v <= shift_right(v,1);
        end if;
        if i > -1 then
          i <= i - 1;
        end if;
	end if;
      if capture_RR = '1' then
        if x_sig > AA then
          RR <= z_sig - 1;
        else
          RR <= z_sig;
        end if;
      end if;
    end if;
  end process;

end rtl;

