----------------------------------------------------------------------------------
-- Company: 			Engs 31 16X
-- Engineer: 			Andy Werchniak and Eric Fett
-- 
-- Create Date:    	    08/16/2016
-- Design Name: 	
-- Module Name:    	    ALU - Behavioral 
-- Project Name: 		
-- Target Devices: 	    Digilent Basys 3 board (Artix 7)
-- Tool versions: 	    Vivado 2016.1
-- Description: 		Arithmetic Logic Unit for calculator
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

entity ALU is
port	(	a		:	in	std_logic_vector(14 downto 0);
			b		:	in	std_logic_vector(14 downto 0);
			op_sel	:	in	std_logic;
			result	:	out	std_logic_vector(14 downto 0);
			oflow	:	out	std_logic   );
end ALU;

architecture behavior of ALU is

-- signal declarations
signal	aInt 	:	signed(14 downto 0);
signal	bInt	:	signed(14 downto 0);
signal	rInt	:	signed(14 downto 0);

begin

aInt <= signed(a);
bInt <= signed(b);

calculate: process(aInt,bInt,op_sel)
begin
oflow <= '0';

if op_sel = '0' then
	if aInt + bInt > x"270F" then  --hex 9999
	   oflow <= '1';
	end if;
	rInt <= aInt + bInt;
else
	--set overflow flag
	if to_integer(aInt-bInt) < -9999 then
	   oflow <= '1';
	end if;
	rInt <= aInt - bInt;
end if;
end process calculate;

result <= std_logic_vector(rInt);

end behavior;