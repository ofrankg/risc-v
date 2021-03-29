module pcreg
  #(
    parameter WIDTH = 32
  )(
    input logic                clk_in,
    input logic                rst_in,
    input logic   [WIDTH-1:0]  pc_in,
    output logic  [WIDTH-1:0]  pc_out
);
  always_ff @ (posedge clk_in, negedge rst_in) begin
    if (!rst_in)
      pc_out <= 'b0;
    else
      pc_out <= pc_in;
  end
endmodule
