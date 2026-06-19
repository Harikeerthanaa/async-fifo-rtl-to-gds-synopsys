class fifo_rd_driver extends uvm_driver #(fifo_seq_item);
    `uvm_component_utils(fifo_rd_driver)
    virtual async_fifo_if #(.DATA_WIDTH(8)) vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual async_fifo_if)::get(
            this, "", "vif", vif))
            `uvm_fatal("RD_DRV", "Could not get vif")
    endfunction

    task run_phase(uvm_phase phase);
        fifo_seq_item item;
        int timeout;
        vif.rd_en <= 0;
        repeat(20) @(posedge vif.rd_clk);
        `uvm_info("RD_DRV","Read Reset done",UVM_LOW)

        forever begin
            seq_item_port.get_next_item(item);

            if(item.rd_en) begin
                // Wait for FIFO not empty
                timeout = 0;
                while(vif.rd_empty && timeout < 200)
                begin
                    @(posedge vif.rd_clk);
                    timeout++;
                end

                if(!vif.rd_empty) begin
                    // Assert rd_en for 1 cycle only
                    @(posedge vif.rd_clk);
                    vif.rd_en <= 1;

                    // Next cycle rd_data is valid
                    @(posedge vif.rd_clk);
                    #1;
                    `uvm_info("RD_DRV",
                        $sformatf("rd_data=%0h",
                        vif.rd_data), UVM_LOW)

                    // Deassert immediately
                    vif.rd_en <= 0;

                    // Wait 3 cycles before next read
                    // Allows rd_ptr to propagate
                    repeat(3) @(posedge vif.rd_clk);
                end
            end else begin
                @(posedge vif.rd_clk);
                vif.rd_en <= 0;
            end
            seq_item_port.item_done();
        end
    endtask
endclass
