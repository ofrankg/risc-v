module pcplus4
  #(
    parameter WIDTH = 32
  )(
    input logic   [WIDTH-1:0]  pc_in,
    output logic  [WIDTH-1:0]  pc_out
);

  assign pc_out = pc_in + 32'b100;

endmodule
