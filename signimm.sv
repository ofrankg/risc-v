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
      op_imm  : signimm_out = {{20{1'b0}},instr_in[WIDTH-1:20]};
      op_br   : signimm_out = {{20{1'b1}},instr_in[31], instr_in[7], instr_in[30:25], instr_in[11:8]};
      op_store: signimm_out = {{20{1'b0}},instr_in[WIDTH-1:25],instr_in[11:7]};
      default : signimm_out = 'b0;
    endcase
  end

endmodule // signimm
