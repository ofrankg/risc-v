module FW
  #(
    parameter  WIDTH = 32,
    parameter  INDEX = 5
  )
  (
    input logic             exmem_reg_write_in,
    input logic             memwb_reg_write_in,
    input logic [INDEX-1:0] idex_rs1_in,
    input logic [INDEX-1:0] idex_rs2_in,
    input logic [INDEX-1:0] exmem_rd_in,
    input logic [INDEX-1:0] memwb_rd_in,
    output logic [1:0]      rs1_src_out,
    output logic [1:0]      rs2_src_out
  );

    logic ex_hazard_rs1;
    logic ex_hazard_rs2;
    logic mem_hazard_rs1;
    logic mem_hazard_rs2;

    assign ex_hazard_rs1 = exmem_reg_write_in & (exmem_rd_in != 0) & (exmem_rd_in == idex_rs1_in);
    assign mem_hazard_rs1 = memwb_reg_write_in & (memwb_rd_in != 0) & !(ex_hazard_rs1) & (memwb_rd_in == idex_rs1_in);

    assign ex_hazard_rs2 = exmem_reg_write_in & (exmem_rd_in != 0) & (exmem_rd_in == idex_rs2_in);
    assign mem_hazard_rs2 = memwb_reg_write_in & (memwb_rd_in != 0) & !(ex_hazard_rs2) & (memwb_rd_in == idex_rs2_in);


    always_comb begin
      if (ex_hazard_rs1) rs1_src_out = 2'b10;
      else if (mem_hazard_rs1) rs1_src_out = 2'b01;
      else  rs1_src_out = 2'b00;

      if (ex_hazard_rs2) rs2_src_out = 2'b10;
      else if (mem_hazard_rs2) rs2_src_out = 2'b01;
      else  rs2_src_out = 2'b 00;
    end

endmodule // FW
