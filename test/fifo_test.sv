class fifo_base_test extends uvm_test;
  `uvm_component_utils(fifo_base_test)
  fifo_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    fifo_write_seq wr_seq;
    fifo_read_seq  rd_seq;
    phase.raise_objection(this);

    // Write 16 items
    `uvm_info("TEST","Writing 16 items...",UVM_NONE)
    wr_seq = fifo_write_seq::type_id::create("wr_seq");
    wr_seq.start(env.wr_agent.sequencer);

    // Wait LONG time for:
    // 1. wr_ptr_gray through 2FF sync = 2 rd_clk = 30ns
    // 2. pipeline reg = 1 more rd_clk = 15ns
    // 3. rd_empty flag update = 1 rd_clk = 15ns
    // rd_clk=15ns so 10 cycles = 150ns
    // Use 500ns to be very safe
    #500;
    `uvm_info("TEST","Reading 16 items...",UVM_NONE)
    rd_seq = fifo_read_seq::type_id::create("rd_seq");
    rd_seq.start(env.rd_agent.sequencer);

    #500;
    phase.drop_objection(this);
  endtask
endclass

// This will never execute - just for reference
// Check: after #500 delay, rd_empty should be 0
