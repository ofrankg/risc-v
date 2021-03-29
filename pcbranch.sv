module pcbranch
  #(
    parameter WIDTH = 32
  )
  (
    input logic   [WIDTH-1:0] pc_in,
    input logic   [WIDTH-1:0] signimm_in,
    output logic  [WIDTH-1:0] pc_out
  );

  assign pc_out = pc_in + {signimm_in[30:0],1'b0};

endmodule // pcbranch
