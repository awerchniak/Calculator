----------------------------------------------------------------------------------
-- Company: 			Engs 31 16X
-- Engineer: 			Andy Werchniak and Eric Fett
-- 
-- Create Date:    	    08/16/2016
-- Design Name: 	
-- Module Name:    	    shiftregs - Behavioral 
-- Project Name: 		
-- Target Devices: 	    Digilent Basys 3 board (Artix 7)
-- Tool versions: 	    Vivado 2016.1
-- Description: 		Shift registers for calculator component
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

entity shiftregs is
port    (   clk         :   in  std_logic;
            data_in     :   in  std_logic_vector(3 downto 0);
            clr         :   in  std_logic;
            par_ld      :   in  std_logic;
            ld_disp     :   in  std_logic;
            par_data    :   in  std_logic_vector(15 downto 0);
            BCD_OUT     :   out std_logic_vector(15 downto 0)    );
end shiftregs;

architecture behavior of shiftregs is

--register signal declarations
signal oneReg, tenReg, hundReg, thouReg :   std_logic_vector(3 downto 0) := "0000";

begin

update: process(clk)
begin
if rising_edge(clk) then
     if clr = '1' then
            thouReg <= x"0";
            hundReg <= x"0";
            tenReg <= x"0";
            oneReg <= x"0";
     elsif ld_disp = '1' then
            if par_ld = '1' then
                thouReg <= par_data(15 downto 12);
                hundReg <= par_data(11 downto 8);
                tenReg <= par_data(7 downto 4);
                oneReg <= par_data(3 downto 0);
            else
                thouReg <= hundReg;
                hundReg <= tenReg;
                tenReg <= oneReg;
                oneReg <= data_in;
            end if;
    end if;
end if;
end process update;

BCD_OUT <= thouReg & hundReg & tenReg & oneReg;

end behavior;