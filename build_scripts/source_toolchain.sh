#!/bin/bash

# ------------------------------------------------------------
# source_toolchain.sh
# Adrien THIERRY
# 
# Source Xilinx tools. Used internally by other scripts.
# params
# 	1 (optional) : path to Vivado folder. If this 
#	param is not set, use "$HOME/Xilinx/Vivado/$version/"
# ------------------------------------------------------------

# Parse arguments
if [ $# -eq 0 ] ; then
	version=$(find "$HOME/Xilinx/Vivado/." -maxdepth 1 -type d -name '[^.]?*' -printf %f -quit)
	vivado_path="$HOME/Xilinx/Vivado/$version/" # Default path
else
	vivado_path="$1"
fi

# Source Xilinx tools
i=$((${#vivado_path}-1))
last_character="${vivado_path:$i:1}" # Get last character of vivado path to check if user put a "/".

if [ "$last_character" != "/" ] ; then
	vivado_path+="/" # Add "/" if user forgot it
fi

vivado_path+="settings64.sh"

source "$vivado_path"
