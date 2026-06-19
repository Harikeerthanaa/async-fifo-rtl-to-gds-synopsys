class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)

  `uvm_analysis_imp_decl(_wr)
  `uvm_analysis_imp_decl(_rd)

  uvm_analysis_imp_wr #(fifo_seq_item,
                        fifo_scoreboard) wr_ap;
  uvm_analysis_imp_rd #(fifo_seq_item,
                        fifo_scoreboard) rd_ap;

  // Store write data in order
  logic [7:0] ref_model[$];
  // Store read data in order  
  logic [7:0] rd_model[$];

  int pass_count = 0;
  int fail_count = 0;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_ap = new("wr_ap", this);
    rd_ap = new("rd_ap", this);
  endfunction

  // Store write data
  function void write_wr(fifo_seq_item item);
    if(item.wr_en) begin
      ref_model.push_back(item.wr_data);
      `uvm_info("SB",
        $sformatf("WR stored: %0h queue=%0d",
        item.wr_data, ref_model.size()),
        UVM_HIGH)
    end
  endfunction

  // Store read data - compare later
  function void write_rd(fifo_seq_item item);
    rd_model.push_back(item.rd_data);
    `uvm_info("SB",
      $sformatf("RD captured: %0h",
      item.rd_data),
      UVM_HIGH)
  endfunction

  // Compare everything at end
  function void report_phase(uvm_phase phase);
    logic [7:0] exp;
    logic [7:0] got;
    int compare_count;

    compare_count = (ref_model.size() < rd_model.size())
                    ? ref_model.size()
                    : rd_model.size();

    `uvm_info("SB",
      $sformatf("Comparing: wr_count=%0d rd_count=%0d",
      ref_model.size(), rd_model.size()),
      UVM_LOW)

    for(int i = 0; i < compare_count; i++) begin
      exp = ref_model.pop_front();
      got = rd_model.pop_front();
      if(got === exp) begin
        pass_count++;
        `uvm_info("SB",
          $sformatf("PASS Expected=%0h Got=%0h",
          exp, got), UVM_LOW)
      end else begin
        fail_count++;
        `uvm_error("SB",
          $sformatf("FAIL Expected=%0h Got=%0h",
          exp, got))
      end
    end

    `uvm_info("SB","========================",UVM_LOW)
    `uvm_info("SB","SCOREBOARD SUMMARY",      UVM_LOW)
    `uvm_info("SB",
      $sformatf("PASS: %0d", pass_count),     UVM_LOW)
    `uvm_info("SB",
      $sformatf("FAIL: %0d", fail_count),     UVM_LOW)
    `uvm_info("SB","========================",UVM_LOW)
  endfunction

endclass
