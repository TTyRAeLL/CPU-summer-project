set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports {clk}]
create_clock -period 9.900 -name CLK -waveform {0.000 4.950} [get_ports clk]
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS33} [get_ports {reset}]

set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {cathodes[0]}
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {cathodes[1]}
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {cathodes[2]}
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {cathodes[3]}
set_property -dict {PACKAGE_PIN A1 IOSTANDARD LVCMOS33} [get_ports {cathodes[4]}
set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS33} [get_ports {cathodes[5]}
set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports {cathodes[6]}
set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS33} [get_ports {cathodes[7]}
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {ans[3]}
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports {ans[2]}
set_property -dict {PACKAGE_PIN C1 IOSTANDARD LVCMOS33} [get_ports {ans[1]}
set_property -dict {PACKAGE_PIN H1 IOSTANDARD LVCMOS33} [get_ports {ans[0]}


