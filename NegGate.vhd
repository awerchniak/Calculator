----------------------------------------------------------------------------------
-- Company: 			Engs 31 16X
-- Engineer: 			Andy Werchniak and Eric Fett
-- 
-- Create Date:    	    08/16/2016
-- Design Name: 	
-- Module Name:    	    NegGate - Behavioral 
-- Project Name: 		
-- Target Devices: 	    Digilent Basys 3 board (Artix 7)
-- Tool versions: 	    Vivado 2016.1
-- Description: 		Changes signal to positive number, outputs negative flag
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

entity NegGate is
    port(   result_in   :   in std_logic_vector(14 downto 0);
            result_out  :   out std_logic_vector(14 downto 0);
            neg         :   out std_logic );
end NegGate;

architecture behavior of NegGate is

signal in_val   :   integer;
signal out_val  :   integer;

begin
in_val <= to_integer(signed(result_in));

neg_update: process(in_val)
begin
if in_val < 0 then
    out_val <= 0 - in_val;
    neg <= '1';
else
    out_val <= in_val;
    neg <= '0';
end if;
end process neg_update;

result_out <= std_logic_vector(to_unsigned(out_val, 15));

end behavior;