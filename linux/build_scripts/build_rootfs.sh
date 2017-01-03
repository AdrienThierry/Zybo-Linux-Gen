#!/bin/bash

# ------------------------------------------------------------
# build_rootfs.sh
# Adrien THIERRY
# 
# Prepare a rootfs
# ------------------------------------------------------------

scripts_dir=$(pwd)

# Set the reference directory to the script parent directory
origin_dir=$(pwd)/..

script_name="build_rootfs.sh"
rootfs_dir=$origin_dir/rootfs-xlnx
ramdisk_file=$rootfs_dir/arm_ramdisk.image.gz
uramdisk_name="uramdisk.image.gz"
uramdisk_file=$rootfs_dir/$uramdisk_name

# Make rootfs directory if it doesn't exist
if [ ! -d "$rootfs_dir" ]; then
	mkdir $rootfs_dir
fi

cd $rootfs_dir

# If uramdisk file already exists, exit script
if [ -f "$uramdisk_file" ]; then
    echo "uramdisk has already been created. If you want to recreate it, please remove $uramdisk_name and restart $script_name"
	exit
fi

# Download Xilinx rootfs
if [ ! -f "$ramdisk_file" ]; then
	wget http://www.wiki.xilinx.com/file/view/arm_ramdisk.image.gz/419243558/arm_ramdisk.image.gz
fi

# Wrap the image with a U-boot header
mkimage -A arm -T ramdisk -C gzip -d $ramdisk_file $uramdisk_file
