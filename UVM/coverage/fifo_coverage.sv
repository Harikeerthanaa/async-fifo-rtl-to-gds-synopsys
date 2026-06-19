class fifo_coverage extends uvm_component;
    `uvm_component_utils(fifo_coverage)

    `uvm_analysis_imp_decl(_wr)
    `uvm_analysis_imp_decl(_rd)

    uvm_analysis_imp_wr #(fifo_seq_item,
        fifo_coverage) wr_export;
    uvm_analysis_imp_rd #(fifo_seq_item,
        fifo_coverage) rd_export;

    fifo_seq_item item;

    // Write side coverage
    covergroup fifo_wr_cg;
        cp_wr_en: coverpoint item.wr_en {
            bins no_write = {0};
            bins write    = {1};
        }
        cp_wr_data: coverpoint item.wr_data {
            bins low  = {[8'h00:8'h3F]};
            bins mid  = {[8'h40:8'hBF]};
            bins high = {[8'hC0:8'hFF]};
        }
    endgroup

    // Read side coverage
    covergroup fifo_rd_cg;
        cp_rd_en: coverpoint item.rd_en {
            bins no_read = {0};
            bins read    = {1};
        }
        cp_rd_data: coverpoint item.rd_data {
            bins low  = {[8'h00:8'h3F]};
            bins mid  = {[8'h40:8'hBF]};
            bins high = {[8'hC0:8'hFF]};
        }
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        fifo_wr_cg = new();
        fifo_rd_cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wr_export = new("wr_export", this);
        rd_export = new("rd_export", this);
    endfunction

    function void write_wr(fifo_seq_item t);
        item = t;
        fifo_wr_cg.sample();
    endfunction

    function void write_rd(fifo_seq_item t);
        item = t;
        fifo_rd_cg.sample();
    endfunction

    function void report_phase(uvm_phase phase);
        real wr_cov = fifo_wr_cg.get_coverage();
        real rd_cov = fifo_rd_cg.get_coverage();
        real total  = (wr_cov + rd_cov) / 2.0;
        `uvm_info("COV",
            $sformatf("WR Coverage  = %0.2f%%",
            wr_cov), UVM_NONE)
        `uvm_info("COV",
            $sformatf("RD Coverage  = %0.2f%%",
            rd_cov), UVM_NONE)
        `uvm_info("COV",
            $sformatf(
            "Functional Coverage = %0.2f%%",
            total), UVM_NONE)
    endfunction

endclass
