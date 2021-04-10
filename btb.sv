module btb
  #(
    parameter						TAG	= 27,
    parameter						PC	= 32
  )
  (
    input	logic						     clk_in,
    input	logic						     update_in,
    input	logic		[PC-TAG-1:0] fetch_index_in,
    input	logic		[PC-TAG-1:0] exmem_index_in,
    input	logic		[PC-1:0]     new_pc_in,
    output logic  [PC-1:0]     fetch_pc_out,
    output logic  [PC-1:0]     exmem_pc_out
  );

	logic [PC-1:0] btb_mem		[0:2**(PC-TAG)-1];

  initial begin
    int i =0;
    for (i=0; i<2**(PC-TAG); i++)
      btb_mem[i] = 'b0;
  end

	always @( negedge clk_in )
		if ( update_in ) begin
      btb_mem[exmem_index_in] = new_pc_in;
		end

  assign fetch_pc_out = btb_mem[fetch_index_in];
  assign exmem_pc_out = btb_mem[exmem_index_in];

endmodule // btb
