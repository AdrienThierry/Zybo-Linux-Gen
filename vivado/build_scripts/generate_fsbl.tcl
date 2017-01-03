# Set the reference directory to the script parent directory
set origin_dir [file dirname [info script]]/..

set hwdsgn [open_hw_design $origin_dir/vivado_project/vivado_project.sdk/block_design_wrapper.hdf]

set fsbl_workdir $origin_dir/vivado_project/vivado_project.sdk/fsbl

file mkdir $fsbl_workdir
generate_app -hw $hwdsgn -os standalone -proc ps7_cortexa9_0 -app zynq_fsbl -compile -sw fsbl -dir $fsbl_workdir
