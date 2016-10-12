----------------------------------------------------------------------------------
-- Company:     Engs 31, 16X
-- Engineers:    Andy Werchniak and Eric Fett
-- 
-- Create Date: 08/20/2016
-- Design Name: 
-- Module Name: testbench
-- Project Name: Calculator
-- Target Devices: Basys3 FPGA
-- Tool Versions: 
-- Description: Testbench for Calculator project
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;			-- needed for arithmetic
use ieee.math_real.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is
component calculator is
port	( mclk			    :	in std_logic;						    --FPGA board master clock(100MHz)
--		  Row 		        : 	in  STD_LOGIC_VECTOR (3 downto 0);
--	      Col 		        : 	out  STD_LOGIC_VECTOR (3 downto 0);
		  overflow          :   out std_logic;
		  negative          :   out std_logic;
		  
		  --multiplexed 7 segment display
          seg               :    out std_logic_vector(0 to 6);
          dp                :    out std_logic;
          an                :    out std_logic_vector(3 downto 0);
                    
          --testbench debugging
		  keyboard_in       :  in std_logic_vector(3 downto 0) := (others => '0') );
end component;

    signal mclk: std_logic;
    signal overflow, negative: std_logic;
    signal key: std_logic_vector(3 downto 0) := (others => '0');
   -- Clock period definitions
    constant mclk_period : time := 10 ns;		   -- 100 MHz serial clock
	
begin

uut: calculator port map
         ( mclk => mclk,
--           Row => open,
--           Col => open,
           overflow => overflow,
           negative => negative,
           seg => open,
           dp => open,
           an => open,
           keyboard_in => key);
 
-- Clock process definitions
clk_process: process
begin
    mclk <= '0';
    wait for mclk_period/2;
    mclk <= '1';
    wait for mclk_period/2;
end process;
           
-- Stimulus process
stim_process:  process
begin
    wait for 10*mclk_period;
    --963 - 3 = 
    key <= x"9";
    wait for 10*mclk_period;
    key <= x"6";
    wait for 10*mclk_period;
    key <= x"3";
    wait for 10*mclk_period;
    key <= x"B";
    wait for 10*mclk_period;
    key <= x"3";
    wait for 10*mclk_period;
    key <= x"D";
    
    --clear
    wait for 10*mclk_period;
    key <= x"C";
    
    --0-9999-1=
    wait for 10*mclk_period;
    key <= x"0";
    wait for 10*mclk_period;
    key <= x"B";
    wait for 10*mclk_period;
    key <= x"9";
    wait for 10*mclk_period;
    key <= x"F";
    wait for 10*mclk_period;
    key <= x"9";
    wait for 10*mclk_period;
    key <= x"F";
    wait for 10*mclk_period;
    key <= x"9";
    wait for 10*mclk_period;
    key <= x"F";
    wait for 10*mclk_period;
    key <= x"9";
    wait for 10*mclk_period;
    key <= x"B";            --should get negative flag here
    wait for 10*mclk_period;
    key <= x"1";
    wait for 10*mclk_period;
    key <= x"D";            --should get overflow flag here

    --clear
    wait for 10*mclk_period;
    key <= x"C";
    
    --0+9999+1=
    wait for 10*mclk_period;
    key <= x"0";
    wait for 10*mclk_period;
    key <= x"A";
    wait for 10*mclk_period;
    key <= x"9";
    wait for 10*mclk_period;
    key <= x"F";
    wait for 10*mclk_period;
    key <= x"9";
    wait for 10*mclk_period;
    key <= x"F";
    wait for 10*mclk_period;
    key <= x"9";
    wait for 10*mclk_period;
    key <= x"F";
    wait for 10*mclk_period;
    key <= x"9";
    wait for 10*mclk_period;
    key <= x"A";
    wait for 10*mclk_period;
    key <= x"1";
    wait for 10*mclk_period;
    key <= x"D";            --should get overflow flag here
    
    
end process stim_process;  
    
end Behavioral;