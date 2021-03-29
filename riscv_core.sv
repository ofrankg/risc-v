`include "riscv_types.sv"
import riscv_types::*;
module riscv_core
 #(
     parameter WIDTH=32
  )
  (
    input   				master_clk,
    input   				master_nrst,
	 output  [WIDTH-1:0]	instruction,
    output  [WIDTH-1:0]	pc_current
  );

  // connections
	logic 				    zero;
  logic 				    branch_sel;
	//logic [WIDTH-1:0]	instruction;
	logic [WIDTH-1:0]	pc_branch;
	logic [WIDTH-1:0]	pc_next;
	logic [WIDTH-1:0]	pc_plus4;
	logic [WIDTH-1:0]	rs1_alu;
	logic [WIDTH-1:0]	rs2;
	logic [WIDTH-1:0]	rs2_signimm;
	logic [WIDTH-1:0]	rs2_alu;
	logic [WIDTH-1:0]	alu_result;
	logic [WIDTH-1:0]	data_mem;
	logic [WIDTH-1:0]	rd;
	logic [WIDTH-1:0]	rs_signimm;
	riscv_control_t   ctrl_vector;
  // instances
  pcreg #(.WIDTH(32)) pcreg
  (
    .clk_in (master_clk),
    .rst_in (master_nrst),
    .pc_in  (pc_next),
    .pc_out (pc_current)
  );

  pcplus4 #(.WIDTH(32)) pcplus4
  (
    .pc_in  (pc_current),
    .pc_out (pc_plus4)
  );

  pcbranch #(.WIDTH(32)) pcbranch
  (
    .pc_in      (pc_current),
    .signimm_in (rs_signimm),
    .pc_out     (pc_branch)
  );

	select_branch select_branch
  (
    .zero_in    (zero),
    .beq_in     (ctrl_vector.branch),
    .bneq_in    (ctrl_vector.branch_neq),
    .branch_out (branch_sel)
  );

  mux #(.WIDTH(32)) pcmux
  (
    .sel_in (branch_sel),
    .a_in   (pc_branch),
    .b_in   (pc_plus4),
    .c_out  (pc_next)
  );

  imem #(.WIDTH(32),.INDEX(6))  imem
  (
    .clk_in     (master_clk),
    .data_in    (),
    .address_in (pc_current[7:2]),
    .we_in      (),
    .data_out   (instruction)
  );

  control control
  (
    .opcode_in    (riscvi_opcode_t'(instruction[6:0])),
    .funct3_in    (instruction[14:12]),
    .funct7_in    (instruction[31:25]),
    .control_out  (ctrl_vector)
  );

  registerfile #(.WIDTH(32),.INDEX(5)) registerfile
  (
    .clk_in         (master_clk),
    .we_in          (ctrl_vector.reg_write),
    .address_w_in   (instruction[11:7]),
    .address_ra_in  (instruction[19:15]),
    .address_rb_in  (instruction[24:20]),
    .data_w_in      (rd),
    .data_a_out     (rs1_alu),
    .data_b_out     (rs2)
  );

  signimm #(.WIDTH(32)) signimm
  (
    .instr_in     (instruction),
    .signimm_out  (rs_signimm)
  );

  mux #(.WIDTH(32)) rs2mux
  (
    .sel_in (ctrl_vector.alu_src),
    .a_in   (rs_signimm),
    .b_in   (rs2),
    .c_out  (rs2_alu)
  );

  alu #(.WIDTH(32)) alu
	(
    .ctrl_in  (ctrl_vector.alu_op),
		.rs1_in   (rs1_alu),
		.rs2_in   (rs2_alu),
		.zero_out (zero),
		.rd_out   (alu_result)
	);

  dmem #(.WIDTH(32),.INDEX(6)) dmem
  (
    .clk_in     (master_clk),
    .we_in      (ctrl_vector.mem_write),
    .re_in      (ctrl_vector.mem_read),
    .data_in    (rs2),
    .address_in (alu_result[7:2]),
    .data_out   (data_mem)
  );

  mux #(.WIDTH(32)) rdmux
  (
    .sel_in (ctrl_vector.mem_to_reg),
    .a_in   (data_mem),
    .b_in   (alu_result),
    .c_out  (rd)
  );

endmodule
