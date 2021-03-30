import riscv_types::*;
module ID
  #(
    parameter WIDTH = 32,
    parameter INDEX = 5
  )
  (
    input logic               clk_in,
    input logic               we_in,
    input logic [INDEX-1:0]   rd_in,
    input logic [WIDTH-1:0]   instr_in,
    input logic [WIDTH-1:0]   data_in,
    output logic [INDEX-1:0]   rd_out,
    output logic [WIDTH-1:0]  drs1_out,
    output logic [WIDTH-1:0]  drs2_out,
    output logic [WIDTH-1:0]  signimm_out,
    output riscv_control_t    ctrl_vector_out
  );

    logic [4:0] rd;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [2:0] funct3;
    logic [6:0] funct7;
    riscvi_opcode_t opcode;

    assign opcode = riscvi_opcode_t'(instr_in[6:0]);
    assign funct3 = instr_in[14:12];
    assign funct7 = instr_in[31:25];

    assign rd_out = instr_in[11:7];
    assign rs1 = instr_in[19:15];
    assign rs2 = instr_in[24:20];


    control control
    (
      .opcode_in    (opcode),
      .funct3_in    (funct3),
      .funct7_in    (funct7),
      .control_out  (ctrl_vector_out)
    );

    registerfile #(.WIDTH(32),.INDEX(5)) registerfile
    (
      .clk_in         (clk_in),
      .we_in          (we_in),
      .address_w_in   (rd_in),
      .address_ra_in  (rs1),
      .address_rb_in  (rs2),
      .data_w_in      (data_in),
      .data_a_out     (drs1_out),
      .data_b_out     (drs2_out)
    );

    signimm #(.WIDTH(32)) signimm
      (
        .instr_in     (instr_in),
        .signimm_out  (signimm_out)
      );

endmodule // ID
