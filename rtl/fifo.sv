///////////////////////////////////////////////////////////////////////////////////
// [Filename]       fifo.sv
// [Project]        fifo_ip
// [Author]         Ciro Bermudez
// [Language]       SystemVerilog 2017 [IEEE Std. 1800-2017]
// [Created]        2024.06.22
// [Description]    Top FIFO IP module 
// [Notes]          Dependencies:
//                    reg_file.sv
//                    fifo_ctrl.sb
// [Status]         Draft <- Under Development <- Testing
///////////////////////////////////////////////////////////////////////////////////

module fifo #(
    parameter int WordLength = 8,
    parameter int AddrBits   = 4
) (
    input  logic                  clk_i,
    input  logic                  rst_i,
    input  logic                  rd_i,
    input  logic                  wr_i,
    input  logic [WordLength-1:0] w_data_i,
    output logic [WordLength-1:0] r_data_o,
    output logic                  empty_o,
    output logic                  full_o
);

  logic [AddrBits-1:0] w_addr;
  logic [AddrBits-1:0] r_addr;
  logic                wr_en;
  logic                full;

  assign wr_en  = wr_i & ~full;
  assign full_o = full;

  fifo_ctrl #(
      .AddrBits(AddrBits)
  ) fifo_ctrl_m (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .rd_i(rd_i),
      .wr_i(wr_i),
      .w_addr_o(w_addr),
      .r_addr_o(r_addr),
      .empty_o(empty_o),
      .full_o(full)
  );

  reg_file #(
      .WordLength(WordLength),
      .AddrBits  (AddrBits)
  ) reg_file_m (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .wr_en_i(wr_en),
      .w_addr_i(w_addr),
      .r_addr_i(r_addr),
      .w_data_i(w_data_i),
      .r_data_o(r_data_o)
  );

endmodule : fifo

