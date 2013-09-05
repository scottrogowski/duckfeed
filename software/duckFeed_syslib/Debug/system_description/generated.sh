#!/bin/sh
#
# generated.sh - shell script fragment - not very useful on its own
#
# Machine generated for a CPU named "cpu" as defined in:
# /home/user5/spring11/smr2167/Milestone1/software/duckFeed_syslib/../../nios_system.ptf
#
# Generated: 2011-05-13 03:28:46.232

# DO NOT MODIFY THIS FILE
#
#   Changing this file will have subtle consequences
#   which will almost certainly lead to a nonfunctioning
#   system. If you do modify this file, be aware that your
#   changes will be overwritten and lost when this file
#   is generated again.
#
# DO NOT MODIFY THIS FILE

# This variable indicates where the PTF file for this design is located
ptf=/home/user5/spring11/smr2167/Milestone1/software/duckFeed_syslib/../../nios_system.ptf

# This variable indicates whether there is a CPU debug core
nios2_debug_core=yes

# This variable indicates how to connect to the CPU debug core
nios2_instance=0

# This variable indicates the CPU module name
nios2_cpu_name=cpu

# Include operating system specific parameters, if they are supplied.

if test -f /opt/e4840/altera7.2/nios2eds/components/altera_hal/build/os.sh ; then
   . /opt/e4840/altera7.2/nios2eds/components/altera_hal/build/os.sh
fi
