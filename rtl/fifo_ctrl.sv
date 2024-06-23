///////////////////////////////////////////////////////////////////////////////////
// [Filename]       fifo_ctrl.sv
// [Project]        fifo_ip
// [Author]         Ciro Bermudez
// [Language]       SystemVerilog 2017 [IEEE Std. 1800-2017]
// [Created]        2024.06.22
// [Description]    Module FIFO controller for a register file
// [Notes]          
// [Status]         Draft -> Under Development -> Testing
///////////////////////////////////////////////////////////////////////////////////

module fifo_ctrl #(
    //parameter int WordLength = 8,
    parameter int AddrBits = 4
) (
    input  logic                clk_i,
    input  logic                rst_i,
    input  logic                rd_i,
    input  logic                wr_i,
    output logic [AddrBits-1:0] w_addr_o,
    output logic [AddrBits-1:0] r_addr_o,
    output logic                empty_o,
    output logic                full_o
);

  typedef enum logic [1:0] {
    NONE,
    READ,
    WRITE,
    BOTH
  } fifo_cmd_e;

  fifo_cmd_e fifo_cmd = {wr_i, rd_i};
  logic [AddrBits-1:0] w_ptr_q, w_ptr_d, w_ptr_succ;
  logic [AddrBits-1:0] r_ptr_q, r_ptr_d, r_ptr_succ;
  logic full_q, full_d;
  logic empty_q, empty_d;

  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      w_ptr_q <= 'd0;
      r_ptr_q <= 'd0;
      full_q  <= 1'b0;
      empty_q <= 1'b1;
    end else begin
      w_ptr_q <= w_ptr_d;
      r_ptr_q <= r_ptr_d;
      full_q  <= full_d;
      empty_q <= empty_d;
    end
  end

  always_comb begin
    // Successive pointer values
    w_ptr_succ = w_ptr_q + 'd1;
    r_ptr_succ = r_ptr_q + 'd1;
    // Default keep old values
    w_ptr_d = w_ptr_q;
    r_ptr_d = r_ptr_q;
    full_d = full_q;
    empty_d = empty_q;
    unique case (fifo_cmd)
      READ: begin
        if (~empty_q) begin
          r_ptr_d = r_ptr_succ;
          full_d  = 1'b0;
          if (r_ptr_succ == w_ptr_q) begin
            empty_d = 1'b1;
          end
        end
      end
      WRITE: begin
        if (~full_q) begin
          w_ptr_d = w_ptr_succ;
          empty_d = 1'b0;
          if (w_ptr_succ == r_ptr_q) begin
            full_d = 1'b1;
          end
        end
      end
      BOTH: begin
        w_ptr_d = w_ptr_succ;
        r_ptr_d = r_ptr_succ;
      end
      //default: ;
    endcase
  end

  assign full_o   = full_q;
  assign empty_o  = empty_q;
  assign w_addr_o = w_ptr_q;
  assign r_addr_o = r_ptr_q;

endmodule

