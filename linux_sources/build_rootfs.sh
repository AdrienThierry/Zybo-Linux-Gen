#!/bin/bash

# ------------------------------------------------------------
# build_rootfs.sh
# Adrien THIERRY
# 
# Prepare a rootfs
# ------------------------------------------------------------

# Make rootfs directory
mkdir rootfs-xlnx
cd rootfs-xlnx

# Download Xilinx rootfs
wget http://www.wiki.xilinx.com/file/view/arm_ramdisk.image.gz/419243558/arm_ramdisk.image.gz

# Wrap the image with a U-boot header
mkimage -A arm -T ramdisk -C gzip -d arm_ramdisk.image.gz uramdisk.image.gz
