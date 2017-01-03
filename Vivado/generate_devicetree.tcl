set workdir "./Vivado_project/Vivado_project.sdk/devicetree"

open_hw_design ./Vivado_project/Vivado_project.sdk/block_design_wrapper.hdf
set_repo_path src/device-tree-xlnx

file mkdir $workdir

create_sw_design device-tree -os device_tree -proc ps7_cortexa9_0
generate_target -dir $workdir
