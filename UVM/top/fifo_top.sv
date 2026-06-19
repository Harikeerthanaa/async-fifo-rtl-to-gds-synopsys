`define UVM_NO_DPI
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "fifo_seq_item.sv"
`include "fifo_sequence.sv"
`include "fifo_corner_seq.sv"
`include "fifo_wr_driver.sv"
`include "fifo_rd_driver.sv"
`include "fifo_monitor.sv"
`include "fifo_scoreboard.sv"
`include "fifo_agent.sv"
`include "fifo_rd_agent.sv"
`include "fifo_coverage.sv"
`include "fifo_env.sv"
`include "fifo_test.sv"
`include "fifo_corner_test.sv"

module tb_top;

    parameter WR_CLK_PERIOD = 10;
    parameter RD_CLK_PERIOD = 15;

    logic wr_clk, rd_clk;

    initial wr_clk = 0;
    always #(WR_CLK_PERIOD/2) wr_clk = ~wr_clk;

    initial rd_clk = 0;
    always #(RD_CLK_PERIOD/2) rd_clk = ~rd_clk;

    async_fifo_if #(.DATA_WIDTH(8)) fifo_if(
        .wr_clk(wr_clk),
        .rd_clk(rd_clk)
    );

    initial begin
        fifo_if.wr_rst_n = 0;
        fifo_if.rd_rst_n = 0;
        fifo_if.wr_en    = 0;
        fifo_if.rd_en    = 0;
        fifo_if.wr_data  = 0;
    end

    async_fifo #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(4),
        .FIFO_DEPTH(16)
    ) dut (
        .wr_clk   (wr_clk),
        .wr_rst_n (fifo_if.wr_rst_n),
        .wr_en    (fifo_if.wr_en),
        .wr_data  (fifo_if.wr_data),
        .wr_full  (fifo_if.wr_full),
        .rd_clk   (rd_clk),
        .rd_rst_n (fifo_if.rd_rst_n),
        .rd_en    (fifo_if.rd_en),
        .rd_data  (fifo_if.rd_data),
        .rd_empty (fifo_if.rd_empty)
    );

    initial begin
        uvm_config_db #(virtual async_fifo_if)::set(
            null, "uvm_test_top.*", "vif", fifo_if);
        run_test("fifo_base_test");
    end

    initial begin
        #100000;
        `uvm_fatal("TB", "Timeout!")
        $finish;
    end


// Direct memory debug
initial begin
    #800;
    $display("DBG: mem[0]=%0h mem[1]=%0h mem[15]=%0h",
        dut.mem[0], dut.mem[1], dut.mem[15]);
    $display("DBG: wr_ptr=%0h rd_ptr=%0h rd_empty=%0b",
        dut.wr_ptr_bin, dut.rd_ptr_bin,
        fifo_if.rd_empty);
end

endmodule
