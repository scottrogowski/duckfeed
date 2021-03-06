# TCL File Generated by Component Editor 7.2 on:
# Wed Mar 02 12:26:56 EST 2011
# DO NOT MODIFY

set_source_file "de2_led_flasher.vhd"
set_module "de2_led_flasher"
set_module_description ""
set_module_property "className" "de2_led_flasher"
set_module_property "group" ""
set_module_property "libraries" [ list "ieee.std_logic_1164.all" "ieee.numeric_std.all" "std.standard.all" ]
set_module_property "synthesisFiles" "de2_led_flasher.vhd"

# Module parameters

# Interface clock
add_interface "clock" "clock" "sink" "asynchronous"
# Ports in interface clock
add_port_to_interface "clock" "clk" "clk"
add_port_to_interface "clock" "reset_n" "reset_n"

# Interface export_0
add_interface "export_0" "conduit" "start" "clock"
# Ports in interface export_0
add_port_to_interface "export_0" "leds" "export"

# Interface avalon_slave_0
add_interface "avalon_slave_0" "avalon" "slave" "clock"
set_interface_property "avalon_slave_0" "isNonVolatileStorage" "false"
set_interface_property "avalon_slave_0" "burstOnBurstBoundariesOnly" "false"
set_interface_property "avalon_slave_0" "readLatency" "0"
set_interface_property "avalon_slave_0" "holdTime" "0"
set_interface_property "avalon_slave_0" "printableDevice" "false"
set_interface_property "avalon_slave_0" "readWaitTime" "1"
set_interface_property "avalon_slave_0" "setupTime" "0"
set_interface_property "avalon_slave_0" "addressAlignment" "DYNAMIC"
set_interface_property "avalon_slave_0" "writeWaitTime" "0"
set_interface_property "avalon_slave_0" "timingUnits" "Cycles"
set_interface_property "avalon_slave_0" "minimumUninterruptedRunLength" "1"
set_interface_property "avalon_slave_0" "isMemoryDevice" "false"
set_interface_property "avalon_slave_0" "linewrapBursts" "false"
set_interface_property "avalon_slave_0" "maximumPendingReadTransactions" "0"
# Ports in interface avalon_slave_0
add_port_to_interface "avalon_slave_0" "read" "read"
add_port_to_interface "avalon_slave_0" "write" "write"
add_port_to_interface "avalon_slave_0" "chipselect" "chipselect"
add_port_to_interface "avalon_slave_0" "address" "address"
add_port_to_interface "avalon_slave_0" "readdata" "readdata"
add_port_to_interface "avalon_slave_0" "writedata" "writedata"
