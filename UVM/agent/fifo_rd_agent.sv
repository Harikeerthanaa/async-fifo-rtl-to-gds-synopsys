class fifo_rd_agent extends uvm_agent;
    `uvm_component_utils(fifo_rd_agent)

    fifo_rd_driver                  driver;
    uvm_sequencer #(fifo_seq_item)  sequencer;
    fifo_rd_monitor                 monitor;

    uvm_analysis_port #(fifo_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver    = fifo_rd_driver::type_id::create(
                    "driver", this);
        sequencer = uvm_sequencer #(fifo_seq_item)::
                    type_id::create("sequencer", this);
        monitor   = fifo_rd_monitor::type_id::create(
                    "monitor", this);
        ap        = new("ap", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(
            sequencer.seq_item_export);
        monitor.ap.connect(ap);
    endfunction

endclass
