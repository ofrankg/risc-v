import riscv_types::*;
module EX
  #(
    parameter  WIDTH = 32,
    parameter  INDEX = 5
  )
  (
    input logic [1:0]        rs1_src_in,
    input logic [1:0]        rs2_src_in,
    input logic [WIDTH-1:0]  pc_in,
    input logic [WIDTH-1:0]  rs1_in,
    input logic [WIDTH-1:0]  rs2_in,
    input logic [WIDTH-1:0]  signimm_in,
    input logic [WIDTH-1:0]  wb_data_to_write_in,
    input logic [WIDTH-1:0]  exmem_alu_res_in,
    input riscv_control_t    ctrl_vector_in,
    output logic             zero_out,
    output logic [WIDTH-1:0] pc_branch_out,
    output logic [WIDTH-1:0] drs2_fw_out,
    output logic [WIDTH-1:0] alu_res_out
  );

    logic [WIDTH-1:0] rs2_alu;
    logic [WIDTH-1:0] rs1_alu;

    pcbranch #(.WIDTH(32)) pcbranch
    (
      .pc_in      (pc_in),
      .signimm_in (signimm_in),
      .pc_out     (pc_branch_out)
    );

    /* Resolve operation */

    mux4 #(.WIDTH(32)) RS1
    (
        .sel_in (rs1_src_in),
        .a_in   (rs1_in),
        .b_in   (wb_data_to_write_in),
        .c_in   (exmem_alu_res_in),
        .d_in   (),
        .z_out  (rs1_alu)
    );

    mux4 #(.WIDTH(32)) RS2
    (
        .sel_in (rs2_src_in),
        .a_in   (rs2_in),
        .b_in   (wb_data_to_write_in),
        .c_in   (exmem_alu_res_in),
        .d_in   (),
        .z_out  (drs2_fw_out)
    );

    mux2 #(.WIDTH(32)) rs2mux
    (
      .sel_in (ctrl_vector_in.alu_src),
      .a_in   (drs2_fw_out),
      .b_in   (signimm_in),
      .z_out  (rs2_alu)
    );

    alu #(.WIDTH(32)) alu
    (
      .ctrl_in  (ctrl_vector_in.alu_op),
      .rs1_in   (rs1_alu),
      .rs2_in   (rs2_alu),
      .zero_out (zero_out),
      .rd_out   (alu_res_out)
    );

endmodule // exe
