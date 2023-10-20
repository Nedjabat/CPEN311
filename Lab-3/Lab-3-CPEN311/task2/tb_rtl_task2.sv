`timescale 1ps / 1ps


module tb_rtl_task2();

logic CLOCK_50;
logic [3:0] KEY;
logic [9:0] SW;

logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
logic [9:0] LEDR;

task2 DUT (	.CLOCK_50, 
		.KEY, 
		.SW,
		.HEX0, 
		.HEX1,
		.HEX2,
		.HEX3,
		.HEX4,
		.HEX5,
		.LEDR);


initial begin
	SW = 10'h33C;
	CLOCK_50 = 0;  
	KEY[3] = 1;

	#5;

	KEY[3] = 0;

	#5;

	KEY[3] = 1;

	#5;



end

initial forever #5 CLOCK_50 = ~CLOCK_50;


endmodule: tb_rtl_task2
