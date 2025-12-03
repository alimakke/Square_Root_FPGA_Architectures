library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sqrt_seq is
generic(N:NATURAL:=64);
port(A: in std_logic_vector(N-1 downto 0);
	start: in std_logic;
	init: in std_logic;
	clk : IN std_logic;
	result: out std_logic_vector(N/2 -1 downto 0);
	done: out std_logic
);
end sqrt_seq;



architecture arch1 of sqrt_seq is         --newton
signal x : unsigned (N-1 downto 0);
signal x_prev : unsigned (N-1 downto 0);
type statetype is (s0,s1,s2,s3);
signal state : statetype := s0;
signal RR : unsigned (N/2 -1 downto 0);

	begin
	process(clk,init)
		begin
		if init='1' then
			x <= (others => '0');
			x_prev <= (others => '0');
			RR <= (others => '0');
			state <= s0;
			done <= '0';
			
			elsif rising_edge(clk) then
			case state is
				when s0 =>
				done <= '0';
				if start = '1' then
					x <= unsigned(A);
					state <= s1;
					end if;
				
				when s1 =>
					x_prev <= x;
					done <= '0';
				x <= shift_right((x+(unsigned(A)/x)),1);
	
					if abs(to_integer(x)-to_integer(x_prev))<= 1 then
					state <= s2;
					end if;
					
				
				when s2 =>
					done <= '1';
				  state <= s0;
				  
					RR <= x(N/2-1 downto 0);
					
				
				when others =>
					state <= s0;
					done <= '0';
				
				end case;
			end if; 
	end process;
	
result <= std_logic_vector(RR);

end arch1;
