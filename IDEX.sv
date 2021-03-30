import riscv_types::*;
module IDEX
  #(
    parameter WIDTH = 32,
    parameter INDEX = 5
  )
  (
    input logic              clk_in,
    input logic              rst_in,
    /* From ifid */
    input logic [WIDTH-1:0]  pc_in,

    /* From decode stage */
    input logic [INDEX-1:0]  rs1_in,
    input logic [INDEX-1:0]  rs2_in,
    input logic [INDEX-1:0]  rd_in,
    input logic [WIDTH-1:0]  drs1_in,
    input logic [WIDTH-1:0]  drs2_in,
    input logic [WIDTH-1:0]  signimm_in,
    input riscv_control_t    ctrl_vector_in,

    /* To exe */
    // output logic [WIDTH-1:0]  instr_out,
    output logic [WIDTH-1:0]  pc_out,
    output logic [INDEX-1:0]  rs1_out,
    output logic [INDEX-1:0]  rs2_out,
    output logic [INDEX-1:0]  rd_out,
    output logic [WIDTH-1:0]  drs1_out,
    output logic [WIDTH-1:0]  drs2_out,
    output logic [WIDTH-1:0]  signimm_out,
    output riscv_control_t    ctrl_vector_out
  );

    logic [WIDTH-1:0]  pc;
    logic [INDEX-1:0]  rs1;
    logic [INDEX-1:0]  rs2;
    logic [INDEX-1:0]  rd;
    logic [WIDTH-1:0]  drs1;
    logic [WIDTH-1:0]  drs2;
    logic [WIDTH-1:0]  signimm;
    riscv_control_t    ctrl_vector;


    always_ff @ (posedge clk_in, negedge rst_in) begin
      if (!rst_in) begin
        pc      <= {WIDTH{1'b0}};
        rs1     <= {INDEX{1'b0}};
        rs2     <= {INDEX{1'b0}};
        rd      <= {INDEX{1'b0}};
        drs1 <= {WIDTH{1'b0}};
        drs2 <= {WIDTH{1'b0}};
        signimm <= {WIDTH{1'b0}};
        ctrl_vector <= 11'b0;
      end
      else begin
        pc      <= pc_in;
        rs1     <= rs1_in;
        rs2     <= rs2_in;
        rd      <= rd_in;
        drs1    <= drs1_in;
        drs2    <= drs2_in;
        signimm <= signimm_in;
        ctrl_vector <= ctrl_vector_in;
      end
    end

    always_ff @ (negedge clk_in) begin
      pc_out      <= pc;
      rs1_out     <= rs1;
      rs2_out     <= rs2;
      rd_out      <= rd;
      drs1_out <= drs1;
      drs2_out <= drs2;
      signimm_out <= signimm;
      ctrl_vector_out <= ctrl_vector;
    end

endmodule
