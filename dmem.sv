module dmem
  #(
    parameter WIDTH = 32,
    parameter INDEX = 5
  )(
    input logic              clk_in,
    input logic              we_in,
    input logic              re_in,
    input logic  [WIDTH-1:0] data_in,
    input logic  [INDEX-1:0] address_in,
    output logic [WIDTH-1:0] data_out
  );

  logic [WIDTH-1:0] dcache [0:2**INDEX-1];

  initial begin
    $readmemh("dcache.hex",dcache);
  end

  assign data_out = re_in ? dcache [address_in] : 'b0;

  always_ff @ (negedge clk_in) begin
    if(we_in)
      dcache[address_in] = data_in;
  end

endmodule // imem
