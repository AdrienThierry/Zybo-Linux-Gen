set nb_jobs 1

# Get number of jobs from arguments
if {[llength $argv] > 0} {
	set nb_jobs [lindex $argv 0]
}

# Generate bitstream
open_project ./Vivado_project/Vivado_project.xpr
launch_runs impl_1 -to_step write_bitstream -jobs $nb_jobs
wait_on_run impl_1
