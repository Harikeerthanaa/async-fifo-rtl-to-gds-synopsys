class fifo_wr_driver extends uvm_driver #(fifo_seq_item);
    `uvm_component_utils(fifo_wr_driver)
    virtual async_fifo_if #(.DATA_WIDTH(8)) vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual async_fifo_if)::get(
            this, "", "vif", vif))
            `uvm_fatal("DRV", "Could not get vif")
    endfunction

    task run_phase(uvm_phase phase);
        fifo_seq_item item;

        vif.wr_rst_n <= 0;
        vif.rd_rst_n <= 0;
        vif.wr_en    <= 0;
        vif.wr_data  <= 0;

        repeat(5) @(posedge vif.wr_clk);
        vif.wr_rst_n <= 1;
        repeat(5) @(posedge vif.rd_clk);
        vif.rd_rst_n <= 1;
        `uvm_info("DRV","Reset done",UVM_LOW)

        forever begin
            seq_item_port.get_next_item(item);

            @(posedge vif.wr_clk);

            if(!vif.wr_full && item.wr_en) begin
                // Assert wr_en for exactly 1 cycle
                vif.wr_en   <= 1;
                vif.wr_data <= item.wr_data;
                `uvm_info("DRV",
                    $sformatf("Writing: %0h",
                    item.wr_data), UVM_LOW)
                // Wait 1 cycle - write happens
                @(posedge vif.wr_clk);
                // Deassert immediately after
                vif.wr_en  <= 0;
                vif.wr_data <= 0;
            end else begin
                vif.wr_en <= 0;
                if(vif.wr_full)
                `uvm_info("DRV",
                    "FIFO FULL - skipping",UVM_LOW)
            end

            seq_item_port.item_done();
        end
    endtask
endclass
