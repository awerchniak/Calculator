----------------------------------------------------------------------------------
-- Company: 			Engs 31 16X
-- Engineer: 			Andy Werchniak and Eric Fett
-- 
-- Create Date:    	    08/16/2016
-- Design Name: 	
-- Module Name:    	    BCD2BIN - Behavioral 
-- Project Name: 		
-- Target Devices: 	    Digilent Basys 3 board (Artix 7)
-- Tool versions: 	    Vivado 2016.1
-- Description: 		Combinatorial logic to convert binary coded decimal to binary
-- Dependencies: 
--
-- Revision: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use ieee.math_real.all;

entity BCD2BIN is
port	(	bcd_in	:	in	std_logic_vector(15 downto 0);
			bin_out	:	out	std_logic_vector(14 downto 0)	);
end BCD2BIN;

architecture behavior of BCD2BIN is

--signal declarations
signal thousands : integer := 0;
signal hundreds : integer := 0;
signal tens : integer := 0;
signal ones : integer :=0;
signal final : integer :=0;

begin
thousands <= 1000 * to_integer(unsigned(bcd_in(15 downto 12)));
hundreds <= 100 * to_integer(unsigned(bcd_in(11 downto 8)));
tens <= 10 * to_integer(unsigned(bcd_in(7 downto 4)));
ones <= 1 * to_integer(unsigned(bcd_in(3 downto 0)));
final <= thousands + hundreds + tens + ones;

bin_out <=  std_logic_vector(to_unsigned(final, 15));
end behavior;