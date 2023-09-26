module datapath(input slow_clock, input fast_clock, input resetb,
                input load_pcard1, input load_pcard2, input load_pcard3,
                input load_dcard1, input load_dcard2, input load_dcard3,
                output [3:0] pcard3_out,
                output [3:0] pscore_out, output [3:0] dscore_out,
                output[6:0] HEX5, output[6:0] HEX4, output[6:0] HEX3,
                output[6:0] HEX2, output[6:0] HEX1, output[6:0] HEX0);
						

// The code describing your datapath will go here.  Your datapath 
// will hierarchically instantiate six card7seg blocks, two scorehand
// blocks, and a dealcard block.  The registers may either be instatiated
// or included as sequential always blocks directly in this file.
//
// Follow the block diagram in the Lab 1 handout closely as you write this code.

wire [3:0] new_card;

wire [3:0] PCard1, PCard2, PCard3, DCard1, DCard2, DCard3;

reg4 p1 (
	.D(new_card),
	.clk(slow_clock),
	.reset(resetb),
	.Q(PCard1),
	.EN(load_pcard1)
);

reg4 p2 (
	.D(new_card),
	.clk(slow_clock),
	.reset(resetb),
	.Q(PCard2),
	.EN(load_pcard2)
);

reg4 p3 (
	.D(new_card),
	.clk(slow_clock),
	.reset(resetb),
	.Q(PCard3),
	.EN(load_pcard3)
);

reg4 d1 (
	.D(new_card),
	.clk(slow_clock),
	.reset(resetb),
	.Q(DCard1),
	.EN(load_dcard1)
);

reg4 d2 (
	.D(new_card),
	.clk(slow_clock),
	.reset(resetb),
	.Q(DCard2),
	.EN(load_dcard2)
);

reg4 d3 (
	.D(new_card),
	.clk(slow_clock),
	.reset(resetb),
	.Q(DCard3),
	.EN(load_dcard3)
);


card7seg sp1 (
	.card(PCard1),
	.seg7(HEX0)
);

card7seg sp2 (
	.card(PCard2),
	.seg7(HEX1)
);

card7seg sp3 (
	.card(PCard3),
	.seg7(HEX2)
);

card7seg sd1 (
	.card(DCard1),
	.seg7(HEX3)
);

card7seg sd2 (
	.card(DCard2),
	.seg7(HEX4)
);

card7seg sd3 (
	.card(DCard3),
	.seg7(HEX5)
);

scorehand ps (

	.card1(PCard1),
	.card2(PCard2),
	.card3(PCard3),
	.total(pscore_out)
);

scorehand ds (

	.card1(DCard1),
	.card2(DCard2),
	.card3(DCard3),
	.total(dscore_out)
);

assign pcard3_out = PCard3;

dealcard card (
	.clock(fast_clock),
	.resetb(resetb),
	.new_card
);



endmodule


