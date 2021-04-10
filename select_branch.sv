module select_branch
  (
    input logic   zero_in,
    input logic   beq_in,
    input logic   bneq_in,
    input logic   jump_in,
    output logic  branch_out
  );

  assign branch_out = (zero_in & beq_in) | (!zero_in & bneq_in) | jump_in;

endmodule // select_branch
