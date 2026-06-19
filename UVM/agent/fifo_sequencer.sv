// ============================================================
// Sequence — a series of transactions
// Think of it as a LIST of letters to send
// ============================================================
class fifo_base_seq extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_base_seq)

    // How many transactions to send
    int num_transactions = 20;

    function new(string name = "fifo_base_seq");
        super.new(name);
    endfunction

    task body();
        fifo_seq_item item;
        repeat(num_transactions) begin
            item = fifo_seq_item::type_id::create("item");
            start_item(item);        // prepare to send
            assert(item.randomize()) // randomize data
                else `uvm_error("SEQ", "Randomization failed");
            finish_item(item);       // send it
        end
    endtask

endclass

// Write only sequence
class fifo_write_seq extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_write_seq)

    function new(string name = "fifo_write_seq");
        super.new(name);
    endfunction

    task body();
        fifo_seq_item item;
        repeat(16) begin  // write 16 items (full FIFO)
            item = fifo_seq_item::type_id::create("item");
            start_item(item);
            assert(item.randomize() with {wr_en == 1;})
                else `uvm_error("SEQ", "Randomization failed");
            finish_item(item);
        end
    endtask

endclass

// Read only sequence
class fifo_read_seq extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_read_seq)

    function new(string name = "fifo_read_seq");
        super.new(name);
    endfunction

    task body();
        fifo_seq_item item;
        repeat(16) begin  // read 16 items (empty FIFO)
            item = fifo_seq_item::type_id::create("item");
            start_item(item);
            assert(item.randomize() with {rd_en == 1;})
                else `uvm_error("SEQ", "Randomization failed");
            finish_item(item);
        end
    endtask

endclass
