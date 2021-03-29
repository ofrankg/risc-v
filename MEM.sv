module MEM
  #(
    parameter  WIDTH = 32,
    parameter  INDEX = 5
  )
  (
    input logic                  clk_in,
    input                        we_in,
    input                        re_in,
    input logic  [WIDTH-1:0]     address_in,
    input logic  [WIDTH-1:0]     data_in,
    output logic [WIDTH-1:0]     data_out
  );

  dmem #(.WIDTH(32),.INDEX(INDEX)) dcache
  (
    .clk_in     ( clk_in          ),
    .we_in      ( we_in           ),
    .re_in      ( re_in           ),
    .data_in    ( data_in         ),
    .address_in ( address_in[INDEX+1:2]   ),
    .data_out   ( data_out        )
  );

endmodule // MEM
