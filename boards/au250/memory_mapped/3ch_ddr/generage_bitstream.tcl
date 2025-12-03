launch_runs synth_1 -jobs 32
wait_on_runs synth_1
launch_runs impl_1 child_0_impl_1 -to_step write_bitstream -jobs 32
wait_on_runs impl_1
wait_on_runs child_0_impl_1
