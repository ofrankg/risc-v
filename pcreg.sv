module pcreg
  #(
    parameter WIDTH = 32
  )(
    input logic                clk_in,
    input logic                rst_in,
    input logic                stall_in,
    input logic   [WIDTH-1:0]  pc_in,
    output logic  [WIDTH-1:0]  pc_out
);
  logic [WIDTH-1:0] pc;
  always_ff @ (posedge clk_in, negedge rst_in) begin
    if (!rst_in)
      pc <= 'b0;
    else begin
      if (!stall_in)
        pc <= pc_in;
    end
  end

  always_ff @ (negedge clk_in) begin
      pc_out <= pc;
  end

endmodule
