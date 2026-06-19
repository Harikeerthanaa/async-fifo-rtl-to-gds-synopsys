configure_lint_setup -goal upf -invokeSeparateBuiltinProcess
analyze -format sverilog /home/user/async_fifo_lint/rtl/async_fifo.sv
elaborate async_fifo
load_upf /home/user/async_fifo_lint/constraints/async_fifo.upf
read_sdc /home/user/async_fifo_lint/constraints/async_fifo.sdc
check_upf
report_violations
exit
