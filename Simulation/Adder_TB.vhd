library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL; 
use std.textio.all;

entity Adder_TB is
end Adder_TB;

architecture behavior of Adder_TB is

    -- Component declaration for the Adder
    component Adder
        generic (N : natural := 64);
        port (
            A     : in std_logic_vector(N-1 downto 0);
            B     : in std_logic_vector(N-1 downto 0);
            S     : out std_logic_vector(N-1 downto 0);
            Cin   : in std_logic;
            Cout  : out std_logic;
            Ovfl  : out std_logic
        );
    end component;

    -- Signal declarations
    signal sigA     : std_logic_vector(63 downto 0) := (others => '0');
    signal sigB     : std_logic_vector(63 downto 0) := (others => '0');
    signal sigCin   : std_logic := '0';
    signal sigS     : std_logic_vector(63 downto 0);
    signal sigCout  : std_logic;
    signal sigOvfl  : std_logic;

    -- File and variables for reading test vectors
    file TestFile : text open read_mode is "test_vectors.txt";
    variable LineData : line;
    variable A_val, B_val, S_val : std_logic_vector(63 downto 0);
    variable Cin_bin, Cout_bin, Ovfl_bin : bit;

    -- Clock period definition
    constant clock_period : time := 10 ns;

begin

    -- Unit Under Test (UUT)
    uut: Adder
        generic map (N => 64)
        port map (
            A     => sigA,
            B     => sigB,
            Cin   => sigCin,
            S     => sigS,
            Cout  => sigCout,
            Ovfl  => sigOvfl
        );

    
    stim_proc: process
    begin
        while not endfile(TestFile) loop
            readline(TestFile, LineData);
			
            -- Read the inputs A, B, Cin using hread for hex values and read for bit values
			-- this is broken for some reason and idk why
            hread(LineData, A_val);      -- A in hex
            hread(LineData, B_val);      -- B in hex 
            read(LineData, Cin_bin);     -- Cin as bit
            hread(LineData, S_val); 	 -- S in hex
            read(LineData, Cout_bin);	 -- Cout as bit
            read(LineData, Ovfl_bin);    -- Ovfl as bit
            
            sigA <= A_val;
            sigB <= B_val;
            sigCin <= std_logic(Cin_bin); 
            
            wait for clock_period;
            
            -- Compare outputs with expected values 
            assert (sigS = S_val)
                report "Mismatch in sum (S)" severity error;
                
            assert (sigCout = std_logic(Cout_bin))  
                report "Mismatch in carry out (Cout)" severity error;
                
            assert (sigOvfl = std_logic(Ovfl_bin))
                report "Mismatch in overflow (Ovfl)" severity error;

        end loop;

        
        file_close(TestFile);
        report "Simulation completed successfully.";
        wait;
    end process;

end behavior;
