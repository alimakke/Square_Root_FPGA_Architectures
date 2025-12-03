library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sqrt_calc is
  port(
    x_in   : in  unsigned(63 downto 0);
    z_in   : in  unsigned(31 downto 0);
    v_in   : in  unsigned(31 downto 0);  -- toujours une puissance de 2
    AA_in  : in  unsigned(63 downto 0);
    do_iter: in  std_logic;

    x_out  : out unsigned(63 downto 0);
    z_out  : out unsigned(31 downto 0)
  );
end entity;

architecture rtl of sqrt_calc is

  signal x_next : unsigned(63 downto 0);
  signal z_next : unsigned(31 downto 0);

 
function log2(n : unsigned) return integer is
  variable res : integer := 0;
begin
  for i in n'length-1 downto 0 loop
    if n(i) = '1' then
      res := i;
      exit;
    end if;
  end loop;
  return res;
end function;

begin

  process(x_in, z_in, v_in, AA_in, do_iter)
    variable temp : unsigned(63 downto 0);
    variable k    : integer;
  begin
    if do_iter = '1' then
      k := log2(v_in);

      if x_in > AA_in then

	temp := (v_in - 2*z_in);
	temp := shift_left(temp,k);
        x_next <= x_in + temp;
        z_next <= z_in - v_in;
      else
        -- x + v*(v + 2*z) remplacé par décalages
        temp := (v_in + 2*z_in);
	temp := shift_left(temp,k);
        x_next <= x_in + temp;
        z_next <= z_in + v_in;
      end if;
    else
      x_next <= x_in;
      z_next <= z_in;
    end if;
  end process;

  x_out <= x_next;
  z_out <= z_next;

end architecture;

