#!/bin/bash

# ------------------------------------------------------------
# build_kernel.sh
# Adrien THIERRY
# 
# Build Linux kernel from Xilinx git repo
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

# Clone Xilinx Linux kernel repo
git clone https://github.com/Xilinx/linux-xlnx.git

# Use ARM cross compiler
export CROSS_COMPILE=arm-xilinx-linux-gnueabi-

cd linux-xlnx

make ARCH=arm xilinx_zynq_defconfig
make ARCH=arm UIMAGE_LOADADDR=0x8000 uImage
