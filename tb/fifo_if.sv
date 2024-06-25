interface fifo_if #(
    parameter int WordLength = 8
) (
    input logic clk_i
);

  logic                  rst_i;
  logic                  rd_i;
  logic                  wr_i;
  logic [WordLength-1:0] w_data_i;
  logic [WordLength-1:0] r_data_o;
  logic                  empty_o;
  logic                  full_o;

  clocking cb @(posedge clk_i);
    default input #1ns output #1ns;
    output rst_i;
    output rd_i;
    output wr_i;
    output w_data_i;
    input r_data_o;
    input empty_o;
    input full_o;
  endclocking

  modport dvr(clocking cb, output rst_i);

endinterface : fifo_if
