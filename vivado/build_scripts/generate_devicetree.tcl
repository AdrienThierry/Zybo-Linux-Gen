# Set the reference directory to the script parent directory
set origin_dir [file dirname [info script]]/..

set workdir $origin_dir/vivado_project/vivado_project.sdk/devicetree

open_hw_design $origin_dir/vivado_project/vivado_project.sdk/block_design_wrapper.hdf
set_repo_path $origin_dir/src/device-tree-xlnx

file mkdir $workdir

create_sw_design device-tree -os device_tree -proc ps7_cortexa9_0
generate_target -dir $workdir
