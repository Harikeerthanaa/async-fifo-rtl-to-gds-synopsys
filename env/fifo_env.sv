class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)
    fifo_wr_agent   wr_agent;
    fifo_rd_agent   rd_agent;
    fifo_scoreboard scoreboard;
    fifo_coverage   coverage;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wr_agent   = fifo_wr_agent::type_id::create("wr_agent", this);
        rd_agent   = fifo_rd_agent::type_id::create("rd_agent", this);
        scoreboard = fifo_scoreboard::type_id::create("scoreboard", this);
        coverage   = fifo_coverage::type_id::create("coverage", this);
    endfunction
    function void connect_phase(uvm_phase phase);
        wr_agent.ap.connect(scoreboard.wr_ap);
        rd_agent.ap.connect(scoreboard.rd_ap);
        wr_agent.ap.connect(coverage.wr_export);
        rd_agent.ap.connect(coverage.rd_export);
    endfunction
endclass
