module WB
  #(
    parameter  WIDTH = 32
  )
  (
    input logic              sel_in,
    input logic  [WIDTH-1:0] data_in,
    input logic  [WIDTH-1:0] alu_res_in,
    output logic [WIDTH-1:0] data_out
  );

  mux2 #(.WIDTH(32)) muxWB
  (
      .sel_in (sel_in),
      .a_in   (alu_res_in),
      .b_in   (data_in),
      .z_out  (data_out)
    );

endmodule // WB
