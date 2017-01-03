#!/bin/bash

# ------------------------------------------------------------
# build_boot_img.sh
# Adrien THIERRY
# 
# Build BOOT.bin
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

uboot_location=$origin_dir/linux/u-boot-xlnx
SD_card_dir=$origin_dir/sd_card

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
echo "image: {" > $origin_dir/BOOT.bif

string_fsbl="[bootloader]""$origin_dir""/vivado/vivado_project/vivado_project.sdk/fsbl/executable.elf"
string_bitstream="$origin_dir""/vivado/vivado_project/vivado_project.sdk/block_design_wrapper.bit"
string_uboot="$origin_dir""/linux/u-boot-xlnx/u-boot.elf"

echo "$string_fsbl" >> $origin_dir/BOOT.bif
echo "$string_bitstream" >> $origin_dir/BOOT.bif
echo "$string_uboot" >> $origin_dir/BOOT.bif

echo "}" >> $origin_dir/BOOT.bif

# Create SD_card directory if it doesn't exist
if [ ! -d $SD_card_dir ]; then
	mkdir $SD_card_dir
fi

# Create BOOT.img
bootgen -image $origin_dir/BOOT.bif -o i $SD_card_dir/BOOT.bin

# Clean files
rm $origin_dir/BOOT.bif

