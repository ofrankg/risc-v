module IF
 #(
     parameter WIDTH=32
  )
  (
    input logic  				     clk_in,
    input logic              rst_in,
    input logic              stall_in,
    input logic              pc_src_in,
    input logic              prediction_in,
    input logic              flush_in,
    input logic  [WIDTH-1:0] pc_prediction_in,
    input logic  [WIDTH-1:0] pc_branch_in,
    output logic [WIDTH-1:0] pc_current_out
  );

    logic  [WIDTH-1:0] pc_plus4;
    logic  [WIDTH-1:0] pc_next;
    logic  [WIDTH-1:0] pc_spec;

    mux2 #(.WIDTH(32)) pcmux
    (
      .sel_in (prediction_in),
      .a_in   (pc_plus4),
      .b_in   (pc_prediction_in),
      .z_out  (pc_next)
    );

    mux2 #(.WIDTH(32)) pcbpu
    (
      .sel_in (flush_in),
      .a_in   (pc_next),
      .b_in   (pc_branch_in),
      .z_out  (pc_spec)
    );

    pcreg #(.WIDTH(32)) pcreg
    (
      .clk_in   (clk_in),
      .rst_in   (rst_in),
      .stall_in (stall_in),
      .pc_in    (pc_spec),
      .pc_out   (pc_current_out)
    );

    pcplus4 #(.WIDTH(32)) pcplus4
    (
      .pc_in  (pc_current_out),
      .pc_out (pc_plus4)
    );

endmodule
