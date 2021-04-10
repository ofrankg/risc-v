module pht
  #(
    parameter						TAG	= 27,
    parameter						PC	= 32,
    parameter           COUNT = 2
  )
  (
    input	logic						       clk_in,
    input	logic						       update_in,
    input	logic		[PC-TAG-1:0]   fetch_index_in,
    input	logic		[COUNT-1:0]    new_confidence_in,
    input	logic		[PC-TAG-1:0]   exmem_index_in,
    output logic  [COUNT-1:0]          fetch_confidence_out,
    output	logic		[COUNT-1:0]  exmem_confidence_out
  );

	logic [COUNT-1:0] pht_mem		[0:2**(PC-TAG)-1];

  initial begin
    int i =0;
    for (i=0; i<2**(PC-TAG); i++)
      pht_mem[i] = 'b0;
  end

	always @( negedge clk_in )
		if ( update_in ) begin
      pht_mem[exmem_index_in] = new_confidence_in;
		end

  assign fetch_confidence_out = pht_mem[fetch_index_in];
  assign exmem_confidence_out = pht_mem[exmem_index_in];

endmodule // pht
