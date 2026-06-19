class fifo_wr_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_wr_monitor)
    uvm_analysis_port #(fifo_seq_item) ap;
    virtual async_fifo_if #(.DATA_WIDTH(8)) vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if(!uvm_config_db #(virtual async_fifo_if)::get(
            this, "", "vif", vif))
            `uvm_fatal("WR_MON", "Could not get vif")
    endfunction

    task run_phase(uvm_phase phase);
        fifo_seq_item item;
        forever begin
            @(posedge vif.wr_clk);
            #1;
            if(vif.wr_en && !vif.wr_full) begin
                item = fifo_seq_item::type_id::
                       create("item");
                item.wr_data = vif.wr_data;
                item.wr_en   = 1;
                item.rd_en   = 0;
                ap.write(item);
            end
        end
    endtask
endclass

class fifo_rd_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_rd_monitor)
    uvm_analysis_port #(fifo_seq_item) ap;
    virtual async_fifo_if #(.DATA_WIDTH(8)) vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if(!uvm_config_db #(virtual async_fifo_if)::get(
            this, "", "vif", vif))
            `uvm_fatal("RD_MON", "Could not get vif")
    endfunction

    task run_phase(uvm_phase phase);
        fifo_seq_item item;
        forever begin
            @(posedge vif.rd_clk);
            #1;
            if(vif.rd_en && !vif.rd_empty) begin
                @(posedge vif.rd_clk);
                #1;
                item = fifo_seq_item::type_id::
                       create("item");
                item.rd_en   = 1;
                item.wr_en   = 0;
                item.rd_data = vif.rd_data;
                `uvm_info("RD_MON",
                    $sformatf("Captured: %0h",
                    item.rd_data), UVM_LOW)
                ap.write(item);
            end
        end
    endtask
endclass
