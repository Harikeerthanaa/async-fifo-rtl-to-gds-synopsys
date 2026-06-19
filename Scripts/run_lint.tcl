configure_lint_setup -goal lint_rtl -invokeSeparateBuiltinProcess
analyze -format sverilog /home/user/async_fifo_lint/rtl/async_fifo.sv
elaborate async_fifo
check_lint
report_violations
exit
