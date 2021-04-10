module BPU
  #(
    parameter  PC = 32,
    parameter  TAG = 27
  )
  (
    input logic           clk_in,
    input logic           write_pc_in,
    input logic [PC-1:0]  fetch_pc_in,
    input logic [PC-1:0]  decode_pc_in,
    input logic [PC-1:0]  exe_pc_in,
    input logic [PC-1:0]  exe_new_pc_in,
    output logic          prediction_out
  );

  logic [PC-TAG-1:0] fetch_index;
  logic [PC-TAG-1:0] decode_index;
  logic [PC-TAG-1:0] exe_index;

  logic [TAG-1:0] fetch_tag;
  logic [TAG-1:0] decode_tag;
  logic [TAG-1:0] new_tag;

  logic [PC-1:0]  pc_btb;

  logic hit;
  logic update;

  assign fetch_index = fetch_pc_in[PC-TAG-1:0];
  assign decode_index = decode_pc_in[PC-TAG-1:0];
  assign exe_index = exe_pc_in[PC-TAG-1:0];

  assign fetch_tag = fetch_pc_in[PC-1:PC-TAG];
  assign decode_tag = decode_pc_in[PC-1:PC-TAG];
  assign new_tag = exe_new_pc_in[PC-1:PC-TAG];

  assign write = write_pc_in & !hit;

  bht #(.TAG(27),.PC(32)) BHT
  (
    .clk_in        (clk_in),
    .write_in      (write),
    .index_in      (fetch_index),
    .tag_in        (fetch_tag),
    .new_index_in  (decode_index),
    .new_tag_in    (decode_tag),
    .hit_out       (hit)
  );

  // pht #(.TAG(27),.PC(32),.COUNT(2) PHT
  // (
  //   .clk_in         (),
  //   .update_in      (),
  //   .index_in       (),
  //   .pattern_in     (),
  //   .new_index_in   (),
  //   .new_pattern_in (),
  //   .prediction_out ()
  // );
  //

  assign update = (pc_btb == exe_new_pc_in) ? 1'b0 : 1'b1;

  btb #(.TAG(27),.PC(32)) BTB
  (
    .clk_in       (clk_in),
    .update_in    (update),
    .index_in     (exe_index),
    .new_pc_in    (exe_new_pc_in),
    .pc_out       (pc_btb)
  );

endmodule // BPU
