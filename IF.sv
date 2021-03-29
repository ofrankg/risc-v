module IF
 #(
     parameter WIDTH=32
  )
  (
    input logic  				     clk_in,
    input logic              rst_in,
    input logic  [WIDTH-1:0] pc_next_in,
    output logic [WIDTH-1:0] pc_current_out,
    output logic [WIDTH-1:0] pc_plus4_out
  );

  pcreg #(.WIDTH(32)) pcreg
  (
    .clk_in (clk_in),
    .rst_in (rst_in),
    .pc_in  (pc_next_in),
    .pc_out (pc_current_out)
  );

  pcplus4 #(.WIDTH(32)) pcplus4
  (
    .pc_in  (pc_current_out),
    .pc_out (pc_plus4_out)
  );

endmodule
