module riscv_core_tst();

	logic	[31:0]	pc_current;
	logic				master_clk;
	logic				master_nrst;
	logic	[31:0]	instruction;

	initial begin
		master_clk = 1'b0;
		master_nrst = 1'b0;
		pc_current = 32'b0;
	end

	always #5 master_clk = !master_clk;

	always begin
		#10 master_nrst = 1'b1;
		#50000;
	end

	riscv_core #(.WIDTH(32)) DUT
	(
		.master_clk (master_clk),
		.master_nrst (master_nrst),
		.instruction (instruction),
		.pc_current	(pc_current)
  );

endmodule
