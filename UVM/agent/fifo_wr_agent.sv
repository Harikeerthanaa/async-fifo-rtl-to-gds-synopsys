// ============================================================
// Agent — Groups Driver + Sequencer + Monitor together
// Think of it as ONE TEAM handling write or read side
// ============================================================
class fifo_wr_agent extends uvm_agent;
    `uvm_component_utils(fifo_wr_agent)

    // Components
    fifo_wr_driver                  driver;
    uvm_sequencer #(fifo_seq_item)  sequencer;
    fifo_wr_monitor                 monitor;

    // Analysis port to pass monitor data out
    uvm_analysis_port #(fifo_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver    = fifo_wr_driver::type_id::create("driver", this);
        sequencer = uvm_sequencer #(fifo_seq_item)::type_id::create(
                    "sequencer", this);
        monitor   = fifo_wr_monitor::type_id::create("monitor", this);
        ap        = new("ap", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        // Connect driver to sequencer
        driver.seq_item_port.connect(sequencer.seq_item_export);
        // Connect monitor analysis port
        monitor.ap.connect(ap);
    endfunction

endclass
