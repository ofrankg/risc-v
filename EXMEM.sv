import riscv_types::*;
module EXMEM
  #(
    parameter WIDTH = 32,
    parameter INDEX = 5
  )
  (
    input                     clk_in,
    input                     rst_in,
    input logic               flush_in,
    input logic               zero_in,
    input logic  [WIDTH-1:0]  pc_in,
    input logic  [WIDTH-1:0]  pc_branch_in,
    input logic  [WIDTH-1:0]  alu_res_in,
    input logic  [INDEX-1:0]  rd_in,
    input logic  [WIDTH-1:0]  drs2_in,
    input riscv_control_t     ctrl_vector_in,
    output logic              zero_out,
    output logic  [WIDTH-1:0] pc_out,
    output logic  [WIDTH-1:0] pc_branch_out,
    output logic  [WIDTH-1:0] alu_res_out,
    output logic  [INDEX-1:0] rd_out,
    output logic  [WIDTH-1:0] drs2_out,
    output riscv_control_t    ctrl_vector_out
  );

    logic  [WIDTH-1:0]  pc;
    logic  [WIDTH-1:0]  pc_branch;
    logic  [WIDTH-1:0]  alu_res;
    logic    				zero;
    logic  [INDEX-1:0]  rd;
    logic  [WIDTH-1:0]  drs2;
    riscv_control_t     ctrl_vector;


    always_ff @ (posedge clk_in, negedge rst_in) begin
      if (!rst_in) begin
        pc          <= {WIDTH{1'b0}};
        pc_branch   <= {WIDTH{1'b0}};
        alu_res     <= {WIDTH{1'b0}};
        zero        <= 1'b0;
        rd          <= {INDEX{1'b0}};
        drs2        <= {WIDTH{1'b0}};
        ctrl_vector <= 'b0;
      end
      else begin
        if (flush_in) begin
          pc          <= {WIDTH{1'b0}};
          pc_branch    <= {WIDTH{1'b0}};
          alu_res     <= {WIDTH{1'b0}};
          zero        <= 1'b0;
          rd          <= {INDEX{1'b0}};
          drs2        <= {WIDTH{1'b0}};
          ctrl_vector <= 'b0;
        end
        else begin
          pc          <= pc_in;
          pc_branch    <= pc_branch_in;
          alu_res     <= alu_res_in;
          zero        <= zero_in;
          rd          <= rd_in;
          drs2        <= drs2_in;
          ctrl_vector <= ctrl_vector_in;
        end
      end
    end

    always_ff @ (negedge clk_in) begin
      pc_out          <= pc;
      pc_branch_out   <= pc_branch;
      alu_res_out     <= alu_res;
      zero_out        <= zero;
      rd_out          <= rd;
      drs2_out        <= drs2;
      ctrl_vector_out <= ctrl_vector;
    end

endmodule // EXMEM
