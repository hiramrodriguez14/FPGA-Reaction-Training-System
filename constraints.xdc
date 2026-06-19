## Clock signal (100 MHz oscillator)
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## LEDS and Buzzer
set_property PACKAGE_PIN K17   [get_ports red_on]	
    set_property IOSTANDARD LVCMOS33  [get_ports red_on]
set_property PACKAGE_PIN M18    [get_ports yellow_on]	
    set_property IOSTANDARD LVCMOS33  [get_ports yellow_on]
set_property PACKAGE_PIN N17    [get_ports green_on2]	  
    set_property IOSTANDARD LVCMOS33  [get_ports green_on2]
set_property PACKAGE_PIN P18    [get_ports toBuzzer]	  
    set_property IOSTANDARD LVCMOS33  [get_ports toBuzzer]
set_property PACKAGE_PIN L1    [get_ports start]	  
    set_property IOSTANDARD LVCMOS33  [get_ports start]
set_property PACKAGE_PIN N3    [get_ports stopped]	  
    set_property IOSTANDARD LVCMOS33  [get_ports stopped]
 
## Buttons
set_property PACKAGE_PIN R2 [get_ports reset]					
	set_property IOSTANDARD LVCMOS33 [get_ports reset]
	
set_property PACKAGE_PIN U18 [get_ports button_start]						
	set_property IOSTANDARD LVCMOS33 [get_ports button_start]
	
set_property PACKAGE_PIN T17 [get_ports stop_button]						
	set_property IOSTANDARD LVCMOS33 [get_ports stop_button]
	
## 7 Segment Display Cathodes (Active-Low on Basys 3)
set_property PACKAGE_PIN W7 [get_ports {seg[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
set_property PACKAGE_PIN W6 [get_ports {seg[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U8 [get_ports {seg[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V5 [get_ports {seg[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U7 [get_ports {seg[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN V7 [get_ports point]					
	set_property IOSTANDARD LVCMOS33 [get_ports point]

## 4 Digit Anodes (Active-Low)
set_property PACKAGE_PIN U2 [get_ports {an[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]
	

