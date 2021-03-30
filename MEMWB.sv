module MEMWB
  #(
    parameter WIDTH = 32,
    parameter INDEX = 5
  )
  (
    input logic               clk_in,
    input logic               rst_in,
    input logic               mem_to_reg_in,
    input logic               reg_write_in,
    input logic [INDEX-1:0]   rd_in,
    input logic [WIDTH-1:0]   data_mem_in,
    input logic [WIDTH-1:0]   alu_res_in,
    output logic              mem_to_reg_out,
    output logic              reg_write_out,
    output logic [INDEX-1:0]  rd_out,
    output logic [WIDTH-1:0]  data_mem_out,
    output logic [WIDTH-1:0]  alu_res_out
  );

    logic              mem_to_reg;
    logic              reg_write;
    logic [INDEX-1:0]  rd;
    logic [WIDTH-1:0]  data_mem;
    logic [WIDTH-1:0]  alu_res;

    always_ff @ (posedge clk_in, negedge rst_in) begin
      if (!rst_in) begin
        mem_to_reg  <= 1'b0;
        reg_write   <= 1'b0;
        rd          <= {INDEX{1'b0}};
        data_mem    <= {WIDTH{1'b0}};
        alu_res        <= {WIDTH{1'b0}};
      end
      else begin
        mem_to_reg <= mem_to_reg_in;
        reg_write  <= reg_write_in;
        rd         <= rd_in;
        data_mem   <= data_mem_in;
        alu_res       <= alu_res_in;
      end
    end

    always @ (negedge clk_in) begin
      mem_to_reg_out <= mem_to_reg;
      reg_write_out <= reg_write;
      rd_out <= rd;
      data_mem_out <= data_mem;
      alu_res_out <= alu_res;
    end

endmodule //MEMWB
