#!/bin/bash

# ------------------------------------------------------------
# build_rootfs.sh
# Adrien THIERRY
# 
# Prepare a rootfs
# ------------------------------------------------------------

script_name="build_rootfs.sh"
rootfs_dir="rootfs-xlnx"
ramdisk_name="arm_ramdisk.image.gz"
uramdisk_name="uramdisk.image.gz"

# Make rootfs directory if it doesn't exist
if [ ! -d "$rootfs_dir" ]; then
	mkdir rootfs-xlnx
fi
cd rootfs-xlnx

# If uramdisk file already exists, exit script
if [ -f "$uramdisk_name" ]; then
    echo "Uramdisk has already been created. If you want to recreate it, please remove $uramdisk_name and restart $script_name."
	exit
fi

# Download Xilinx rootfs
if [ ! -f "$ramdisk_name" ]; then
	wget http://www.wiki.xilinx.com/file/view/arm_ramdisk.image.gz/419243558/arm_ramdisk.image.gz
fi

# Wrap the image with a U-boot header
mkimage -A arm -T ramdisk -C gzip -d arm_ramdisk.image.gz uramdisk.image.gz
