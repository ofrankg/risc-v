module bht
  #(
    parameter						TAG	= 27,
    parameter						PC	= 32
  )
  (
    input	logic						     clk_in,
    input	logic						     update_in,
    input	logic		[PC-TAG-1:0] fetch_index_in,
    input	logic		[PC-TAG-1:0] exmem_index_in,
    input	logic		[TAG-1:0]    fetch_tag_in,
    input	logic		[TAG-1:0]    exmem_tag_in,
    output logic               fetch_hit_out
  );

	logic [TAG-1:0] bht_mem		[0:2**(PC-TAG)-1];

  initial begin
    int i =0;
    for (i=0; i<2**(PC-TAG); i++)
      bht_mem[i] = 'b0;
  end

	always @( negedge clk_in )
		if ( update_in ) begin
      bht_mem[exmem_index_in] = exmem_tag_in;
		end

    assign fetch_hit_out = (fetch_tag_in == bht_mem[fetch_index_in]);

endmodule // bht
