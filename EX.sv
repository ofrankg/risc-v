import riscv_types::*;
module EX
  #(
    parameter  WIDTH = 32,
    parameter  INDEX = 5
  )
  (
    input logic [WIDTH-1:0]  pc_in,
    input logic [WIDTH-1:0]  rs1_in,
    input logic [WIDTH-1:0]  rs2_in,
    input logic [WIDTH-1:0]  signimm_in,
    input riscv_control_t    ctrl_vector_in,
    output logic             zero_out,
    output logic [WIDTH-1:0] pc_branch_out,
    output logic [WIDTH-1:0] alu_res_out
  );

    logic [WIDTH-1:0] rs2_alu;

    pcbranch #(.WIDTH(32)) pcbranch
    (
      .pc_in      (pc_in),
      .signimm_in (signimm_in),
      .pc_out     (pc_branch_out)
    );

    /* Resolve operation */

    mux #(.WIDTH(32)) rs2mux
    (
      .sel_in (ctrl_vector_in.alu_src),
      .a_in   (signimm_in),
      .b_in   (rs2_in),
      .c_out  (rs2_alu)
    );

    alu #(.WIDTH(32)) alu
    (
      .ctrl_in  (ctrl_vector_in.alu_op),
      .rs1_in   (rs1_in),
      .rs2_in   (rs2_alu),
      .zero_out (zero_out),
      .rd_out   (alu_res_out)
    );

endmodule // exe
