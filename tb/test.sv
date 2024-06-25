module test (
    fifo_if.dvr fifo_if
);

  initial begin
    $display("Begin Of Simulation.");
    reset();
    repeat(1) write($urandom_range(1,255));   // One write
    repeat(3) write($urandom_range(1,255));   // Three writes
    repeat(1) read();                         // One read
    repeat(4) write($urandom_range(1,255));   // Four writes
    repeat(1) write($urandom_range(1,255));   // One more write FULL
    repeat(2) read();                         // Two reads
    repeat(5) read();                         // Five reads
    repeat(1) read();                         // One more read EMPTY
    $display("End Of Simulation.");
    $finish;
  end

  task reset();
    fifo_if.rst_i = 1'b1;
    fifo_if.cb.rd_i     <= 1'b0;
    fifo_if.cb.wr_i     <= 1'b0;
    fifo_if.cb.w_data_i <= 'd0;
    repeat (1) @(fifo_if.cb);
    fifo_if.cb.rst_i <= 1'b0;
    repeat (1) @(fifo_if.cb);
  endtask : reset

  task write(input logic [7:0] value);
    fifo_if.cb.w_data_i <= value;
    fifo_if.cb.wr_i     <= 1'b1;
    @(fifo_if.cb);
    fifo_if.cb.wr_i <= 1'b0;
    repeat (1) @(fifo_if.cb);
  endtask : write

  task read();
    fifo_if.cb.rd_i <= 1'b1;
    @(fifo_if.cb);
    fifo_if.cb.rd_i <= 1'b0;
    repeat (1) @(fifo_if.cb);
  endtask : read

endmodule : test
