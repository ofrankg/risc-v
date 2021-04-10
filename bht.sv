module bht
  #(
    parameter						TAG	= 27,
    parameter						PC	= 32
  )
  (
    input	logic						     clk_in,
    input	logic						     write_in,
    input	logic		[PC-TAG-1:0] index_in,
    input	logic		[TAG-1:0]    tag_in,
    input	logic		[PC-TAG-1:0] new_index_in,
    input	logic		[TAG-1:0]    new_tag_in,
    output logic               hit_out
  );

	logic [TAG-1:0] bht_mem		[0:2**(PC-TAG)-1];

  initial begin
    $readmemh("bht.hex",bht_mem);
  end

	always @( negedge clk_in )
		if ( write_in ) begin
      bht_mem[new_index_in] = new_tag_in;
		end

  assign hit_out = tag_in == bht_mem[index_in] ? 1'b1 : 1'b0;

endmodule // bht
