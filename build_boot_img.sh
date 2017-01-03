#!/bin/bash

# ------------------------------------------------------------
# build_boot_img.sh
# Adrien THIERRY
# 
# Build BOOT.bin
# ------------------------------------------------------------

# Global variables
options_list="
OPTIONS :
-t [path] | --toolchain [path]	(optional) Vivado toolchain location
				default : (HOME dir)/Xilinx/Vivado/(version)/
"

uboot_location="linux_sources/u-boot-xlnx"

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

# Source Xilinx tools
source source_toolchain.sh $vivado_path

# Add elf extension to u-boot binary
if [ -f $uboot_location"/u-boot" ]; then
    mv  $uboot_location"/u-boot" $uboot_location"/u-boot.elf"
fi

# Create BOOT.bif
echo "image: {" >> BOOT.bif

string_fsbl="[bootloader]""$(pwd)""/Vivado/Vivado_project/Vivado_project.sdk/FSBL/executable.elf"
string_bitstream="$(pwd)""/Vivado/Vivado_project/Vivado_project.sdk/block_design_wrapper.bit"
string_uboot="$(pwd)""/linux_sources/u-boot-xlnx/u-boot.elf"

echo "$string_fsbl" >> BOOT.bif
echo "$string_bitstream" >> BOOT.bif
echo "$string_uboot" >> BOOT.bif

echo "}" >> BOOT.bif

# Create BOOT.img
bootgen -image BOOT.bif -o i BOOT.bin

# Clean files
rm BOOT.bif

