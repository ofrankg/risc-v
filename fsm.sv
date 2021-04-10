module fsm (
	input	logic				  clk_in,
	input	logic				  nrst_in,
	input	logic				  feedback_in,
  input logic	  [1:0]	confidence_in,
	output logic	[1:0]	confidence_out
);

	parameter	NN = 2'b00;
	parameter	NT = 2'b01;
	parameter	TN = 2'b10;
	parameter	TT = 2'b11;

	logic	  [1:0]	next_confidence;
  logic	  [1:0]	confidence;

	always @ ( posedge clk_in, negedge nrst_in)
		if ( !nrst_in )
			confidence <= NN;
		else
			confidence <= next_confidence;

	always @( confidence_in, feedback_in )
		case ( confidence_in )
			NN			:	if ( feedback_in )
								next_confidence = NT;
							else
								next_confidence = NN;
			NT			:	if ( feedback_in )
								next_confidence = TN;
							else
								next_confidence = NN;
			TN			:	if ( feedback_in )
								next_confidence = TT;
							else
								next_confidence = NT;
			TT			:	if ( feedback_in )
								next_confidence = TT;
							else
								next_confidence = TN;
			default	:	next_confidence = NT;
		endcase

  assign confidence_out = confidence;

endmodule // fsm
