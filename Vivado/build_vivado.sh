#!/bin/bash

# ------------------------------------------------------------
# build_vivado.sh
# Adrien THIERRY
# 
# Builds the different parts of the Vivado project
# - hardware project and bitstream
# - software project : FSBL, device tree
# ------------------------------------------------------------

# Global variables

# Get number of physical cores (number of processors * number of physical cores per processor) to determine number of jobs
nb_cores=$(lscpu | awk '/^Core\(s\) per socket:/ {cores=$NF}; /^Socket\(s\):/ {sockets=$NF}; END{print cores*sockets}')

version=$(find "$HOME/Xilinx/Vivado/." -maxdepth 1 -type d -name '[^.]?*' -printf %f -quit)

options_list="
OPTIONS :
-t [path] | --toolchain [path]	(optional) Vivado toolchain location
				default : (HOME dir)/Xilinx/Vivado/(version)/

-p | --project			generate project
-b | --bitstream		generate bitstream
-e | --export			export hardware to SDK
-f | --fsbl			generate FSBL
"
# END global variables

# Parse arguments
if [ $# -eq 0 ] ; then
	echo "$options_list"
fi

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
	-t|--toolchain)
	vivado_path=$2
	shift
	;;
	-p|--project)
	gen_project=true # Generate project
	;;
	-b|--bitstream)
	gen_bitstream=true # Generate bitstream
	;;
	-e|--export)
	export=true # Export hardware to SDK
	;;
	-f|--fsbl)
	gen_fsbl=true # Generate FSBL
	;;
	*)
	echo "$options_list" # unknown option
	;;
esac
shift # past argument or value
done
# END parse arguments

# Source Xilinx tools
source ../source_toolchain.sh $vivado_path

# Generate project
if [ "$gen_project" = true ] ; then
	vivado -mode batch -source generate_project.tcl
fi

# Generate bitstream
if [ "$gen_bitstream" = true ] ; then
	vivado -mode batch -source generate_bitstream.tcl -tclargs $nb_cores
fi

# Export hardware to SDK
if [ "$export" = true ] ; then
	vivado -mode batch -source export_hardware.tcl
fi

# Generate FSBL
if [ "$gen_fsbl" = true ] ; then
	hsi -mode batch -source generate_FSBL.tcl
fi