module test (
    fifo_if.dvr fifo_if
);

  initial begin
    $display("Begin Of Simulation.");
    reset();
    write('d0);   // One write
    write('d10);  // Three writes
    write('d20);
    write('d30);
    read();       // One read
    write('d40);  // Four writes
    write('d50);
    write('d60);
    write('d70);
    write('d80);  // One more write FULL
    read();       // Two reads
    read();
    read();       // Five reads
    read();
    read();
    read();
    read();
    read();       // One more read EMPTY
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
