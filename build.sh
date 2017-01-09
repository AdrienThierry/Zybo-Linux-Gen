#!/bin/bash

# ------------------------------------------------------------
# build.sh
# Adrien THIERRY
# 
# Main script. Calls the other scripts.
# ------------------------------------------------------------

# Global variables
script_dir=$(pwd)

options_list="
OPTIONS :
-t [path] | --toolchain [path]	(optional) Vivado toolchain location
				default : (HOME dir)/Xilinx/Vivado/(version)/

-p | --project			generate Vivado project
-b | --bitstream		generate bitstream
-e | --export			export hardware to SDK
-f | --fsbl			generate FSBL
-d | --devicetree		generate device tree
-r | --rootfs			build rootfs
-k | --kernel			build Linux kernel
-u | --uboot			build uboot
-i | --image			build boot image
"
# END global variables

# Functions
launch_build_vivado () { 
	if [ "$vivado_path" != "" ] ; then
		options_build_vivado+="-t $vivado_path"
	fi

	cd vivado/build_scripts
	bash ./build_vivado.sh $options_build_vivado
	cd $script_dir 
}

launch_build_rootfs () {
	cd linux/build_scripts
	bash ./build_rootfs.sh
	cd $script_dir
}

launch_build_kernel () {
	if [ "$vivado_path" != "" ] ; then
		options_build_kernel="-t $vivado_path"
	else
		options_build_kernel=""
	fi
	
	cd linux/build_scripts
	bash ./build_kernel.sh $options_build_kernel
	cd $script_dir
}

launch_build_uboot () {
	if [ "$vivado_path" != "" ] ; then
		options_build_uboot="-t $vivado_path"
	else
		options_build_uboot=""
	fi
	
	cd linux/build_scripts
	bash ./build_uboot.sh $options_build_uboot
	cd $script_dir
}

launch_build_boot_img () {
	if [ "$vivado_path" != "" ] ; then
		options_build_boot_img="-t $vivado_path"
	else
		options_build_boot_img=""
	fi
	
	cd build_scripts
	bash ./build_boot_img.sh $options_build_boot_img
	cd $script_dir
}
# END functions

# Parse arguments
if [ $# -eq 0 ] ; then
	gen_all=true # If no arguments, generate everything
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
	-r|--rootfs)
	build_rootfs=true # Build rootfs
	;;
	-k|--kernel)
	build_kernel=true # Build kernel
	;;
	-u|--uboot)
	build_uboot=true # Build uboot
	;;
	-i|--image)
	build_image=true # Build boot image
	;;
	*)
	echo "$options_list" # unknown option
	;;
esac
shift # past argument or value
done
# END parse arguments

# --------------------------------------------------
# VIVADO
# --------------------------------------------------
options_build_vivado=""

if [ "$gen_project" = true ] ; then
	options_build_vivado+="-p "
fi

if [ "$gen_bitstream" = true ] ; then
	options_build_vivado+="-b "
fi

if [ "$export" = true ] ; then
	options_build_vivado+="-e "
fi

if [ "$gen_fsbl" = true ] ; then
	options_build_vivado+="-f "
fi

if [ "$gen_devicetree" = true ] ; then
	options_build_vivado+="-d "
fi

if [ "$options_build_vivado" != "" ] ; then
	launch_build_vivado
fi

# --------------------------------------------------
# ROOTFS
# --------------------------------------------------
if [ "$build_rootfs" = true ] ; then
	launch_build_rootfs
fi

# --------------------------------------------------
# KERNEL
# --------------------------------------------------
if [ "$build_kernel" = true ] ; then
	launch_build_kernel
fi

# --------------------------------------------------
# UBOOT
# --------------------------------------------------
if [ "$build_uboot" = true ] ; then
	launch_build_uboot
fi

# --------------------------------------------------
# IMAGE
# --------------------------------------------------
if [ "$build_image" = true ] ; then
	launch_build_boot_img
fi

# --------------------------------------------------
# ALL
# --------------------------------------------------
if [ "$gen_all" = true ] ; then
	options_build_vivado="-p -b -e -f -d"
	launch_build_vivado
	launch_build_rootfs
	launch_build_kernel
	launch_build_uboot
	launch_build_boot_img
fi

# --------------------------------------------------
# Copy generated files to sd_card folder
# --------------------------------------------------
rootfs_path="linux/rootfs-xlnx/uramdisk.image.gz"
kernel_path="linux/linux-xlnx/arch/arm/boot/uImage"
devicetree_path="vivado/vivado_project/vivado_project.sdk/devicetree/devicetree.dtb"

cp $rootfs_path sd_card/
cp $kernel_path sd_card/
cp $devicetree_path sd_card/
