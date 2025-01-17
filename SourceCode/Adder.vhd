library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_TEXTIO.ALL; 
use std.textio.all;

Entity Adder is
Generic (N : natural := 64);
Port (A,B: in std_logic_1164(N-1 downto 0);
		S: out std_logic_1164(N-1 downto 0);
		Cin: in std_logic;
		Cout, Ovfl: out std_logic);
End Entity Adder;

architecture ripple of Adder is
begin
	process(A,B, Cin)
		variable sumwithcarry : unsigned(N downto 0);
	begin
	-- we append a 0 to the front to handle the case where the sum could
	-- result into a 65 bit sum when adding two 64 bit numbers
		sumwithcarry := ('0' & unsigned(A)) + unsigned(B) + to_unsigned(Cin, 1);
		
		S <= std_logic_vector(sumwithcarry(N-1 downto 0));
		Cout <= sumwithcarry(N);
		Ovfl <= (A(N-1) xor B(N-1)) and (A(N-1) xor S(N-1));
	end process;
end ripple;
