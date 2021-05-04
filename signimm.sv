import riscv_types::*;
module signimm
  #(
    parameter WIDTH = 32
  )
  (
    input logic   [WIDTH-1:0]  instr_in,
    output logic  [WIDTH-1:0]  signimm_out
  );

  always_comb begin
    case (instr_in[6:0])
      op_load : signimm_out = {{20{instr_in[31]}},instr_in[WIDTH-1:20]};
      op_imm  : signimm_out = {{20{instr_in[31]}},instr_in[WIDTH-1:20]};
      op_br   : signimm_out = {{20{instr_in[31]}}, instr_in[7], instr_in[30:25], instr_in[11:8],1'b0};
      op_store: signimm_out = {{20{instr_in[31]}}, instr_in[WIDTH-1:25],instr_in[11:7]};
      op_jump : signimm_out = {{12{instr_in[31]}}, instr_in[19:12], instr_in[20], instr_in[30:21], 1'b0};
      default : signimm_out = 'b0;
    endcase
  end

endmodule // signimm
