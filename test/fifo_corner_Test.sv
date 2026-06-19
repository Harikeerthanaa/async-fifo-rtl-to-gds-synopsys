class fifo_corner_test extends fifo_base_test;
  `uvm_component_utils(fifo_corner_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    fifo_write_seq wr_seq;
    fifo_read_seq  rd_seq;
    fifo_corner_seq corner_seq;

    phase.raise_objection(this);

    // Step 1: Write 16 items first
    `uvm_info("TEST", "Writing 16 items...", UVM_NONE)
    wr_seq = fifo_write_seq::type_id::create("wr_seq");
    wr_seq.start(env.wr_agent.sequencer);

    // Step 2: Wait for CDC propagation
    #500;

    // Step 3: Read 16 items
    `uvm_info("TEST", "Reading 16 items...", UVM_NONE)
    rd_seq = fifo_read_seq::type_id::create("rd_seq");
    rd_seq.start(env.rd_agent.sequencer);

    // Step 4: Wait and run corner cases
    #200;
    corner_seq = fifo_corner_seq::type_id::create(
                 "corner_seq");
    corner_seq.start(env.wr_agent.sequencer);

    #500;
    phase.drop_objection(this);
  endtask

endclass
