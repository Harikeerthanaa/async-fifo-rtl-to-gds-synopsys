set_app_var enable_cdc true
configure_lint_setup -goal cdc -invokeSeparateBuiltinProcess
analyze -format sverilog /home/user/async_fifo_lint/rtl/async_fifo.sv
elaborate async_fifo
read_sdc /home/user/async_fifo_lint/constraints/async_fifo.sdc
check_cdc
report_violations
exit
