module mux
  #(
    parameter WIDTH = 32
  )(
    input logic               sel_in,
    input logic   [WIDTH-1:0] a_in,
    input logic   [WIDTH-1:0] b_in,
    output logic  [WIDTH-1:0] c_out
  );

  assign c_out = sel_in ? a_in : b_in;

endmodule
