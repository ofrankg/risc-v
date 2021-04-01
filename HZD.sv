module HZD
  #(
    parameter  WIDTH = 32,
    parameter  INDEX = 5
  )
  (
    input logic             idex_mem_read_in,
    input logic [INDEX-1:0] idex_rd_in,
    input logic [INDEX-1:0] ifid_rs1_in,
    input logic [INDEX-1:0] ifid_rs2_in,
    output logic            stall_out
  );

  assign stall_out = idex_mem_read_in & ((idex_rd_in == ifid_rs1_in) | (idex_rd_in == ifid_rs2_in));

endmodule // HZD
