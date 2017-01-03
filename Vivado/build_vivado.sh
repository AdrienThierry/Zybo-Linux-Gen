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

options_list="
OPTIONS :
-t [path] | --toolchain [path]	(optional) Vivado toolchain location
				default : (HOME dir)/Xilinx/Vivado/(version)/

-p | --project			generate project
-b | --bitstream		generate bitstream
-e | --export			export hardware to SDK
-f | --fsbl			generate FSBL
-d | --devicetree		generate device tree
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
	-d|--devicetree)
	gen_devicetree=true # Generate device tree
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
	if [ ! -d "./Vivado_project/Vivado_project.sdk" ]; then
		mkdir ./Vivado_project/Vivado_project.sdk
	fi
	cp ./Vivado_project/Vivado_project.runs/impl_1/block_design_wrapper.sysdef ./Vivado_project/Vivado_project.sdk/block_design_wrapper.hdf
fi

# Generate FSBL
if [ "$gen_fsbl" = true ] ; then
	hsi -mode batch -source generate_FSBL.tcl
fi

# Generate device tree
if [ "$gen_devicetree" = true ] ; then
	# Clone device tree sources Xilinx git repo
	cd src
	git clone https://github.com/Xilinx/device-tree-xlnx.git
	cd ..

	# Build device tree
	hsi -mode batch -source generate_devicetree.tcl

	# Compile device tree
	cd Vivado_project/Vivado_project.sdk/devicetree
	dtc -I dts -O dtb -o devicetree.dtb system.dts
	cd ../../..
fi
