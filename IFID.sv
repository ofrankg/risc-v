module IFID
 #(
     parameter WIDTH=32
  )
  (
    input logic               clk_in,
    input logic               rst_in,
    input logic               stall_in,
    input logic               flush_in,
    /* From fetch */
    input logic  [WIDTH-1:0]  pc_in,
    input logic  [WIDTH-1:0]  instr_in,
    /* To decode */
    output logic [WIDTH-1:0]	pc_out,
    output logic [WIDTH-1:0]	instr_out
  );

  logic          [WIDTH-1:0]  pc;
  logic          [WIDTH-1:0]  instr;

  always @ (posedge clk_in, negedge rst_in) begin
    if (!rst_in) begin
      pc <= {WIDTH{1'b0}};
      instr <= {WIDTH{1'b0}};
    end
    else begin
      if (!stall_in) begin
        pc <= pc_in;
        instr <= instr_in;
      end
      else if (flush_in) begin
        instr <= {WIDTH{1'b0}};
      end
    end
  end

  always @ (negedge clk_in) begin
    pc_out <= pc;
    instr_out <= instr;
  end

endmodule
