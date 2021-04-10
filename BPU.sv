module BPU
  #(
    parameter  PC = 32,
    parameter  TAG = 27
  )
  (
    input logic           clk_in,
    input logic           nrst_in,
    input logic           exmem_jmp_br_in,
    input logic           exmem_pc_src_in,
    input logic [PC-1:0]  fetch_pc_in,
    input logic [PC-1:0]  exmem_pc_in,
    input logic [PC-1:0]  exmem_pc_branch_in,
    output logic          fetch_prediction_out,
    output logic [1:0]    exmem_confidence_out,
    output logic [PC-1:0] pc_prediction_out,
    output logic [PC-1:0] pc_restore_out
  );

  logic [PC-TAG-1:0]  fetch_index;
  logic [PC-TAG-1:0]  exmem_index;
  logic [TAG-1:0]     fetch_tag;
  logic [TAG-1:0]     exmem_tag;
  logic [1:0]         confidence;
  logic [1:0]         new_confidence;
  logic               fetch_hit;

  assign fetch_index = fetch_pc_in[PC-TAG-1:0];
  assign exmem_index = exmem_pc_in[PC-TAG-1:0];

  assign fetch_tag = fetch_pc_in[PC-1:PC-TAG];
  assign exmem_tag = exmem_pc_in[PC-1:PC-TAG];

  assign fetch_prediction_out = fetch_hit ? confidence[1] : 1'b0;

  assign pc_restore_out = exmem_pc_src_in ? exmem_pc_branch_in : (exmem_pc_in + 32'h4);

  bht #(.TAG(TAG),.PC(PC)) BHT
  (
    .clk_in         (clk_in),
    .update_in      (exmem_jmp_br_in),
    .fetch_index_in (fetch_index),
    .exmem_index_in (exmem_index),
    .fetch_tag_in   (fetch_tag),
    .exmem_tag_in   (exmem_tag),
    .fetch_hit_out  (fetch_hit)
  );

  btb #(.TAG(TAG),.PC(PC)) BTB
  (
    .clk_in         (clk_in),
    .update_in      (exmem_jmp_br_in),
    .fetch_index_in (fetch_index),
    .exmem_index_in (exmem_index),
    .new_pc_in      (exmem_pc_branch_in),
    .fetch_pc_out   (pc_prediction_out),
    .exmem_pc_out   ()
  );

  pht #(.TAG(TAG),.PC(PC),.COUNT(2)) PHT
  (
    .clk_in                 (clk_in),
    .update_in              (exmem_jmp_br_in),
    .fetch_index_in         (fetch_index),
    .new_confidence_in      (new_confidence),
    .exmem_index_in         (exmem_index),
    .fetch_confidence_out   (confidence),
    .exmem_confidence_out   (exmem_confidence_out)
  );

  fsm FSM
  (
  	.clk_in          (clk_in),
  	.nrst_in         (nrst_in),
  	.feedback_in     (exmem_pc_src_in),
    .confidence_in   (exmem_confidence_out),
  	.confidence_out  (new_confidence)
  );

endmodule // BPU
