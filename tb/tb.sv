`timescale 1ns / 100ps

module tb;

  // Clock signal
  parameter CLK_PERIOD = 10ns;
  logic clk_i = 0;
  always #(CLK_PERIOD / 2) clk_i = ~clk_i;

  // Paramaters
  localparam int WordLength = 8;
  localparam int AddrBits = 4;

  // Interface
  fifo_if #(.WordLength(WordLength)) vif (clk_i);

  // Test
  test top_test (vif);

  // Instantiation
  fifo #(
      .WordLength(WordLengt),
      .AddrBits  (AddrBits)
  ) dut (
      .rst_i(rst_i),
      .clk_i(clk_i),
      .rd_i(rd_i),
      .wr_i(wr_i),
      .w_data_i(w_data_i),
      .r_data_o(r_data_o),
      .empty_o(empty_o),
      .full_o(full_o)
  );

  initial begin
    $timeformat(-9, 1, "ns", 10);
  end

endmodule
