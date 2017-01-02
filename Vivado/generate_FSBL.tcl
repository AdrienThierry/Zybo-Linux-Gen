set hwdsgn [open_hw_design ./Vivado_project/Vivado_project.sdk/block_design_wrapper.hdf]

set FSBL_workdir "./Vivado_project/Vivado_project.sdk/FSBL"

file mkdir $FSBL_workdir
generate_app -hw $hwdsgn -os standalone -proc ps7_cortexa9_0 -app zynq_fsbl -compile -sw fsbl -dir $FSBL_workdir
