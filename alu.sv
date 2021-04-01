import riscv_types::*;
module alu
	#(
		parameter WIDTH = 32
	)
	(
		input aluop_t					ctrl_in,
		input logic		[WIDTH-1:0]	rs1_in,
		input logic 	[WIDTH-1:0]	rs2_in,
		output logic					zero_out,
		output logic	[WIDTH-1:0]	rd_out
	);

	always_comb
		case (ctrl_in)
			alu_add	:	rd_out = rs1_in + rs2_in;
      alu_sub	:	rd_out = rs1_in - rs2_in;
      alu_sll	:	rd_out = rs1_in << rs2_in;
      alu_slt:  rd_out = $signed(rs1_in) < $signed(rs2_in) ? 32'b1: 32'b0;
      alu_sltu: rd_out = $unsigned(rs1_in) < $unsigned(rs2_in) ? 32'b1: 32'b0;
      alu_xor	:	rd_out = rs1_in ^ rs2_in;
      alu_srl	:	rd_out = rs1_in >> rs2_in;
      alu_sra	:	rd_out = $signed(rs1_in) >>> rs2_in;
			alu_or	:	rd_out = rs1_in | rs2_in;
			alu_and	:	rd_out = rs1_in & rs2_in;
			default	:	rd_out = {WIDTH{1'b0}};
		endcase

	assign zero_out = (rd_out	== {WIDTH{1'b0}}) ? 1'b1:1'b0;

endmodule
