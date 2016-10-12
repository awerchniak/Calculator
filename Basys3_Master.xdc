## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports mclk]							
	set_property IOSTANDARD LVCMOS33 [get_ports mclk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports mclk]

## LEDs
set_property PACKAGE_PIN U16 [get_ports {overflow}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {overflow}]
set_property PACKAGE_PIN L1 [get_ports {negative}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {negative}]
	
	
#7 segment display
    set_property PACKAGE_PIN W7 [get_ports {seg[0]}] 
        set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
    set_property PACKAGE_PIN W6 [get_ports {seg[1]}] 
        set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
    set_property PACKAGE_PIN U8 [get_ports {seg[2]}] 
        set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
    set_property PACKAGE_PIN V8 [get_ports {seg[3]}] 
        set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
    set_property PACKAGE_PIN U5 [get_ports {seg[4]}] 
        set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
    set_property PACKAGE_PIN V5 [get_ports {seg[5]}] 
        set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
    set_property PACKAGE_PIN U7 [get_ports {seg[6]}] 
        set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
    
    set_property PACKAGE_PIN V7 [get_ports dp] 
        set_property IOSTANDARD LVCMOS33 [get_ports dp]
    
    set_property PACKAGE_PIN U2 [get_ports {an[0]}] 
        set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
    set_property PACKAGE_PIN U4 [get_ports {an[1]}] 
        set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
    set_property PACKAGE_PIN V4 [get_ports {an[2]}] 
        set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
    set_property PACKAGE_PIN W4 [get_ports {an[3]}] 
        set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

##Pmod Header JC
#Sch name = JC1
set_property PACKAGE_PIN K17 [get_ports {Col[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Col[0]}]
#Sch name = JC2
set_property PACKAGE_PIN M18 [get_ports {Col[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Col[1]}]
#Sch name = JC3
set_property PACKAGE_PIN N17 [get_ports {Col[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Col[2]}]
#Sch name = JC4
set_property PACKAGE_PIN P18 [get_ports {Col[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Col[3]}]
#Sch name = JC7
set_property PACKAGE_PIN L17 [get_ports {Row[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Row[0]}]
#Sch name = JC8
set_property PACKAGE_PIN M19 [get_ports {Row[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Row[1]}]
#Sch name = JC9
set_property PACKAGE_PIN P17 [get_ports {Row[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Row[2]}]
#Sch name = JC10
set_property PACKAGE_PIN R18 [get_ports {Row[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Row[3]}]

## These additional constraints are recommended by Digilent
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]

set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
