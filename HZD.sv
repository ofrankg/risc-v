module HZD
  #(
    parameter  WIDTH = 32,
    parameter  INDEX = 5
  )
  (
    input logic             idex_mem_read_in,
    input logic             branch_in,
    input logic [WIDTH-1:0] exmem_branch_in,
    input logic [WIDTH-1:0] idex_pc_in,
    input logic [INDEX-1:0] idex_rd_in,
    input logic [INDEX-1:0] ifid_rs1_in,
    input logic [INDEX-1:0] ifid_rs2_in,
    output logic            stall_out,
    output logic            flush_out
  );

  assign stall_out = idex_mem_read_in & ((idex_rd_in == ifid_rs1_in) | (idex_rd_in == ifid_rs2_in));
  assign flush_out = branch_in & (exmem_branch_in != idex_pc_in);

endmodule // HZD
