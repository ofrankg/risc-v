import riscv_types::*;
module MEM
  #(
    parameter  WIDTH = 32,
    parameter  INDEX = 5
  )
  (
    input logic                  clk_in,
    input                        we_in,
    input                        re_in,
    input                        zero_in,
    input riscv_control_t        ctrl_vector_in,
    input logic  [WIDTH-1:0]     address_in,
    input logic  [WIDTH-1:0]     data_in,
    output logic                 pc_src_out,
    output logic [WIDTH-1:0]     data_out
  );


  /* Resolve Next PC */
  select_branch select_branch
  (
    .zero_in    (zero_in),
    .beq_in     (ctrl_vector_in.branch),
    .bneq_in    (ctrl_vector_in.branch_neq),
    .jump_in    (ctrl_vector_in.jump),
    .branch_out (pc_src_out)
  );

  dmem #(.WIDTH(32),.INDEX(INDEX)) dcache
  (
    .clk_in     ( clk_in          ),
    .we_in      ( we_in           ),
    .re_in      ( re_in           ),
    .data_in    ( data_in         ),
    .address_in ( address_in[INDEX+1:2]   ),
    .data_out   ( data_out        )
  );

endmodule // MEM
