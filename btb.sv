module btb
  #(
    parameter						TAG	= 27,
    parameter						PC	= 32
  )
  (
    input	logic						     clk_in,
    input	logic						     update_in,
    input	logic		[PC-TAG-1:0] index_in,
    input	logic		[PC-1:0]     new_pc_in,
    output logic  [PC-1:0]     pc_out
  );

	logic [PC-1:0] btb_mem		[0:2**(PC-TAG)-1];

  initial begin
    $readmemh("btb.hex",btb_mem);
  end

	always @( negedge clk_in )
		if ( update_in ) begin
      btb_mem[index_in] = new_pc_in;
		end

  assign pc_out = btb_mem[index_in];

endmodule // btb
