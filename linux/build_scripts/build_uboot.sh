#!/bin/bash

# ------------------------------------------------------------
# build_uboot.sh
# Adrien THIERRY
# 
# Build U-Boot from Xilinx git repo
# ------------------------------------------------------------

# Global variables
scripts_dir=$(pwd)

# Set the reference directory to the script parent directory
origin_dir=$(pwd)/..

options_list="
OPTIONS :
-t [path] | --toolchain [path]	(optional) Vivado toolchain location
				default : (HOME dir)/Xilinx/Vivado/(version)/
"

# Parse arguments
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
	-t|--toolchain)
	vivado_path=$2
	shift
	;;
	*)
	echo "$options_list" # unknown option
	exit
	;;
esac
shift # past argument or value
done
# END parse arguments

cd $origin_dir

# Source Xilinx tools
source ../build_scripts/source_toolchain.sh $vivado_path

# Clone Xilinx u-boot repo
git clone https://github.com/Xilinx/u-boot-xlnx.git

# Use ARM cross compiler
export CROSS_COMPILE=arm-xilinx-linux-gnueabi-

cd u-boot-xlnx

make zynq_zybo_config
make
