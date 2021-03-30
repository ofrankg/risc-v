module IF
 #(
     parameter WIDTH=32
  )
  (
    input logic  				     clk_in,
    input logic              rst_in,
    input logic              pc_src_in,
    input logic  [WIDTH-1:0] pc_branch_in,
    output logic [WIDTH-1:0] pc_current_out
  );

    logic  [WIDTH-1:0] pc_plus4;
    logic  [WIDTH-1:0] pc_next;

    mux #(.WIDTH(32)) pcmux
    (
      .sel_in (pc_src_in),
      .a_in   (pc_branch_in),
      .b_in   (pc_plus4),
      .c_out  (pc_next)
    );

    pcreg #(.WIDTH(32)) pcreg
    (
      .clk_in (clk_in),
      .rst_in (rst_in),
      .pc_in  (pc_next),
      .pc_out (pc_current_out)
    );

    pcplus4 #(.WIDTH(32)) pcplus4
    (
      .pc_in  (pc_current_out),
      .pc_out (pc_plus4)
    );

endmodule
