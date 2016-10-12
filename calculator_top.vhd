----------------------------------------------------------------------------------
-- Company: 			Engs 31 16X
-- Engineer: 			Andy Werchniak and Eric Fett
-- 
-- Create Date:    	 	08/16/2016
-- Design Name: 		
-- Module Name:    		calculator_top
-- Project Name: 		Calculator
-- Target Devices: 		Digilent Basys3 (Artix 7)
-- Tool versions: 		Vivado 2016.1
-- Description: 		Final project
--				
-- Dependencies: 		mux7seg, multiplexed 7 segment display
--						shiftregs, 4 register shift register
--                      BCD2BIN, 16-14 bit bcd-binary converter
--                      ALU, arithmetic logic unit
--                      comblogic, combinatorial logic for keyboard input
--						NegGate, signed-unsigned converter
--						bin2bcd, 14-16 bit binary-bcd LUT converter
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;			-- needed for arithmetic
use ieee.math_real.all;				-- needed for automatic register sizing

entity calculator is
port	( mclk			    :	in std_logic;						    --FPGA board master clock(100MHz)
		  Row 		        : 	in  STD_LOGIC_VECTOR (3 downto 0);
	      Col 		        : 	out  STD_LOGIC_VECTOR (3 downto 0);
		  overflow          :   out std_logic;
		  negative          :   out std_logic;
		  
		  --multiplexed 7 segment display
		  seg				:	out std_logic_vector(0 to 6);
		  dp				:	out std_logic;
		  an				:	out std_logic_vector(3 downto 0);    
		  
		  --for testbench simulation
--		  keyboard_in       :   in std_logic_vector(3 downto 0) );
end calculator;

architecture behavior of calculator is

--COMPONENT DECLARATIONS
--Decoder
component Decoder is
Port (
	clk 		            : 	in  STD_LOGIC;
	Row                     : 	in  STD_LOGIC_VECTOR (3 downto 0);
	Col 		            : 	out  STD_LOGIC_VECTOR (3 downto 0);
	DecodeOut 	            : 	out  STD_LOGIC_VECTOR (3 downto 0)   );
end component;

--mux 7seg display
component mux7seg is
port	(	clk 			:	in std_logic;
			y0,y1,y2,y3		:	in std_logic_vector(3 downto 0);
			dp_set			:	in std_logic_vector(3 downto 0);
			seg             :   out std_logic_vector(0 to 6);
			dp				:	out std_logic;
			an				:	out std_logic_vector(3 downto 0)	);
end component;

--shiftregs
component shiftregs is
port    (   clk             :   in  std_logic;
            data_in         :   in  std_logic_vector(3 downto 0);
            clr             :   in  std_logic;
            par_ld          :   in  std_logic;
            ld_disp         :   in  std_logic;
            par_data        :   in  std_logic_vector(15 downto 0);
            BCD_OUT         :   out std_logic_vector(15 downto 0)    );
end component;

--BCD2BIN
component BCD2BIN is
port	(	bcd_in			:	in std_logic_vector(15 downto 0);
			bin_out			:	out std_logic_vector(14 downto 0) );
end component;

--ALU
component ALU is
port	(	a				:	in	std_logic_vector(14 downto 0);
			b				:	in	std_logic_vector(14 downto 0);
			op_sel			:	in	std_logic;
			result			:	out	std_logic_vector(14 downto 0);
			oflow			:	out	std_logic	);
end component;

--BIN-BCD LUT
component bin2bcd is
port (      clka            :   IN STD_LOGIC;
            ena             :   IN STD_LOGIC;
            addra           :   IN STD_LOGIC_VECTOR(13 DOWNTO 0);
            douta           :   OUT STD_LOGIC_VECTOR(15 DOWNTO 0) );
end component;

--comblogic
component comblogic is
port    (   data_in         :   in  std_logic_vector(3 downto 0);
            pm              :   out std_logic;
            eq              :   out std_logic;
            AC              :   out std_logic;
            num             :   out std_logic;
            op              :   out std_logic   );
end component;

--negative signal
component NegGate is
port(       result_in       :   in std_logic_vector(14 downto 0);
            result_out      :   out std_logic_vector(14 downto 0);
            neg             :   out std_logic );
end component;

-- SIGNAL DECLARATIONS

--internal registers
signal reg1, reg2   : std_logic_vector(14 downto 0) := "000000000000000";
signal opreg        : std_logic;
signal key_out      : std_logic_vector(3 downto 0);

--other signals
signal key_in		: std_logic_vector(3 downto 0);	--hex input from keypad decoder
signal new_key      : std_logic;
signal op_sel       : std_logic;
signal shift2convert: std_logic_vector(15 downto 0);
signal lutout       : std_logic_vector(14 downto 0);
signal aluout       : std_logic_vector(14 downto 0);
signal lut2pipe     : std_logic_vector(15 downto 0);
signal neg_out      : std_logic_vector(14 downto 0);
signal neg_flag     : std_logic;

--FSM Signals and Types
type state_type is (wait1, shift_reg1, clear, ld_new, wait2, shift_reg2, pm_reg2, calculate, LUT, ld_sum, ld_new2, eq_reg2, calculate2, LUT2, ld_sum2, wait3);
signal curr_state, next_state: state_type;
signal clr, clr_regs,clr_reg2, par_ld, ld_disp, new_val, ld_1, ld_2, en_lut, op_en : std_logic;
signal pm, eq, AC, num : std_logic;

begin

--PROCESSES GO HERE
--get the keyboard to work
keyboard: process(mclk)
begin
if rising_edge(mclk) then
    if key_out /= key_in then
        new_key <= '1';
        key_out <= key_in;
    else
        new_key <= '0';
    end if;
end if;
end process keyboard;

--update reg1 and reg2
regupdate: process(mclk)
begin
if rising_edge(mclk) then
    --if clr_regs = '1' should be first
    if clr_regs = '1' then
        reg1 <= "000000000000000";
        reg2 <= "000000000000000";
    elsif clr_reg2 = '1' then
        reg2 <= "000000000000000";
    else
        if ld_1 = '1' then
            if new_val = '1' then
                reg1 <= lutout;
            else
                reg1 <= aluout;
            end if;
        end if;

        if ld_2 = '1' then
            reg2 <= lutout;
        end if;
    end if;
end if;
end process regupdate;

--keep operation in register
operation_reg: process(mclk)
begin
if rising_edge(mclk) then
    if clr_regs = '1' then 
        opreg<= '0';
    elsif op_en = '1' then
        opreg <= op_sel;
    end if;
end if;
end process operation_reg;

--fsm state logic
state_logic: process(curr_state,new_key,num,pm,AC,eq)
begin
--defaults
clr<='0'; 
par_ld<='0'; 
ld_disp<='0';
new_val<='0';
ld_1<='0'; 
ld_2<='0';
en_lut<='0';
op_en<='0';
clr_regs<='0';
clr_reg2 <= '0';
next_state <= curr_state;

case curr_state is
    when wait1 =>
        if new_key = '1' then
            if num = '1' then
                next_state <= shift_reg1;
            elsif pm = '1' then
                next_state <= ld_new;
            elsif AC = '1' then
                next_state <= clear;
            end if;
        end if;
    when shift_reg1 =>
        ld_disp <='1';
        next_state <= wait1;
    when ld_new =>
        clr <='1';
        new_val <= '1';
        op_en <= '1';
        if neg_flag = '0' then
            ld_1 <= '1';
        end if;
        next_state<=wait2;
    when clear =>
        clr <= '1';
        clr_regs<= '1';
        next_state <= wait1;
    when wait2 =>
        if new_key = '1' then
            if num = '1' then
                next_state <= shift_reg2;
            elsif pm = '1'then
                next_state <= pm_reg2;
            elsif eq = '1' then
                next_state <= eq_reg2;
            elsif AC = '1' then
                next_state <= clear;
            end if;
        end if;
    when shift_reg2 =>
        ld_disp <='1';
        next_state<= wait2;
    when pm_reg2 =>
        clr<='1';
        ld_2 <= '1';
        next_state <= calculate;
    when calculate =>
        ld_1<='1';
        next_state <= LUT;
    when LUT =>
        en_lut <= '1';
        clr_reg2<='1';
        next_state <= ld_sum;
    when ld_sum =>
        ld_disp <= '1';
        par_ld <='1';
        op_en <= '1';
        next_state <= ld_new2;
    when ld_new2 =>
        new_val <= '1';
        if num = '1' and new_key = '1' then
             clr <= '1';
             next_state <= shift_reg2;
        elsif AC = '1' then
             next_state <= clear;
        end if;
    when eq_reg2 =>
        ld_2 <= '1';
        clr <= '1';
        next_state <= calculate2;
    when calculate2 =>
        ld_1 <= '1';
        next_state <= LUT2;
    when LUT2 =>
        en_lut <= '1';
        clr_reg2<='1';
        next_state <= ld_sum2;
    when ld_sum2 =>
        ld_disp <='1';
        par_ld <= '1';
        next_state <= wait3;
    when wait3 =>
        if new_key = '1' then
            if pm = '1' then
                next_state <= ld_new;
            elsif AC = '1' then
                next_state <= clear;
            end if;
        end if;
end case;
end process state_logic;

--update fsm state
state_update: process(mclk)
begin
if rising_edge(mclk) then
	curr_state<=next_state;
end if;
end process state_update;

--PORT MAPS FOR COMPONENTS
decode: Decoder port map(
	       clk=>mclk,
	       Row=>Row,
	       Col=>Col,
	       DecodeOut=>key_in );

display: mux7seg port map( 
            clk => mclk,				
           	y3 => shift2convert(15 downto 12), 		        
           	y2 => shift2convert(11 downto 8),
           	y1 => shift2convert(7 downto 4), 		
           	y0 => shift2convert(3 downto 0),		
           	dp_set => "0000",          
          	seg => seg,
          	dp => dp,
           	an => an );	

shifts: shiftregs port map(
            clk=> mclk,
            data_in=>key_out,
            clr=>clr,
            par_ld=>par_ld,
            ld_disp=>ld_disp,
            par_data=>lut2pipe,
            BCD_OUT=> shift2convert     );

convert1: BCD2BIN port map(
            bcd_in=>shift2convert,
			bin_out=>lutout          );

mathops:  ALU port map(
            a=>reg1,
			b=>reg2,
			op_sel=> opreg,
			result=> aluout,
			oflow=>overflow         );

convert2: bin2bcd port map(
            clka=>mclk,
            addra=>neg_out(13 downto 0),
            ena=>en_lut,
            douta=>lut2pipe       );

combo: comblogic port map(
            data_in=>key_out,
            pm=>pm,
            eq=>eq,
            AC=>AC,
            num=>num,
            op=>op_sel   );

negs: NegGate port map(
            result_in => reg1,
            result_out => neg_out,
            neg=> neg_flag  );

negative <= neg_flag;
--key_in <= keyboard_in;

end behavior;