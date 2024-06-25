`timescale 1ns / 100ps

module tb;

  // Clock signal
  parameter CLK_PERIOD = 10ns;
  logic clk_i = 0;
  always #(CLK_PERIOD / 2) clk_i = ~clk_i;

  // Paramaters
  localparam int WordLength = 8;
  localparam int AddrBits = 3;

  // Interface
  fifo_if #(.WordLength(WordLength)) vif (clk_i);

  // Test
  test top_test (vif);

  // Instantiation
  fifo #(
      .WordLength(WordLength),
      .AddrBits  (AddrBits)
  ) dut (
      .clk_i(vif.clk_i),
      .rst_i(vif.rst_i),
      .rd_i(vif.rd_i),
      .wr_i(vif.wr_i),
      .w_data_i(vif.w_data_i),
      .r_data_o(vif.r_data_o),
      .empty_o(vif.empty_o),
      .full_o(vif.full_o)
  );

  initial begin
    $timeformat(-9, 1, "ns", 10);
  end

endmodule
