module pht
  #(
    parameter						TAG	= 27,
    parameter						PC	= 32,
    parameter           COUNT = 2
  )
  (
    input	logic						     clk_in,
    input	logic						     update_in,
    input	logic		[PC-TAG-1:0] index_in,
    input	logic		[COUNT-1:0]  pattern_in,
    input	logic		[PC-TAG-1:0] new_index_in,
    input	logic		[COUNT-1:0]  new_pattern_in,
    output logic               prediction_out
  );

	logic [COUNT-1:0] pht_mem		[0:2**(PC-TAG)-1];

  initial begin
    $readmemb("pht.hex",pht_mem);
  end

	always @( negedge clk_in )
		if ( update_in ) begin
      pht_mem[new_index_in] = new_pattern_in;
		end

  assign prediction_out = pht[index_in];

endmodule // pht
