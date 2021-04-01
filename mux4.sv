module mux4
  #(
    parameter WIDTH = 32
  )(
    input logic   [1:0]       sel_in,
    input logic   [WIDTH-1:0] a_in,
    input logic   [WIDTH-1:0] b_in,
    input logic   [WIDTH-1:0] c_in,
    input logic   [WIDTH-1:0] d_in,
    output logic  [WIDTH-1:0] z_out
  );

  always_comb begin
    case (sel_in)
      2'b01:    z_out = b_in;
      2'b10:    z_out = c_in;
      default:  z_out = a_in;
    endcase
  end

endmodule //  mux4
