----------------------------------------------------------------------------------
-- Company: 			Engs 31 16X
-- Engineer: 			Andy Werchniak and Eric Fett
-- 
-- Create Date:    	    08/16/2016
-- Design Name: 	
-- Module Name:    	    comblogic - Behavioral 
-- Project Name: 		
-- Target Devices: 	    Digilent Basys 3 board (Artix 7)
-- Tool versions: 	    Vivado 2016.1
-- Description: 		Decodes keypad input and sends flags to FSM
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

entity comblogic is
port    (   data_in     :   in  std_logic_vector(3 downto 0);
            pm          :   out std_logic;
            eq          :   out std_logic;
            AC          :   out std_logic;
            num         :   out std_logic;
            op          :   out std_logic   );
end comblogic;

architecture behavior of comblogic is
begin

clog: process(data_in)
begin
--defaults
pm <='0';
eq <='0';
AC <='0';
num <='0';


if data_in < x"A" then
    num <= '1';
elsif data_in = x"A" then
    pm <= '1';
    op <='0';
elsif data_in = x"B" then
    pm <= '1';
    op <= '1';
elsif data_in = x"C" then
    AC <= '1';
elsif data_in = x"D" then
    eq <= '1';
    
--notably nothing happens for E or F!
end if;

end process clog;

end behavior;
