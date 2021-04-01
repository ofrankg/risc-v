module imem
  #(
    parameter WIDTH = 32,
    parameter INDEX = 5
  )(
    input logic              clk_in,
    input logic  [WIDTH-1:0] data_in,
    input logic  [INDEX-1:0] address_in,
    input logic              we_in,
    output logic [WIDTH-1:0] data_out
  );

  logic [WIDTH-1:0] mem [0:2**INDEX-1];

  initial begin
    $readmemh("HZD_tst.hex",mem);
  end

  assign data_out = mem [address_in];

endmodule // imem
