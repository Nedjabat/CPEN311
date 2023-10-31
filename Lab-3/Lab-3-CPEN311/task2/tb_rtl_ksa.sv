`timescale 1ps / 1ps
module tb_rtl_ksa();

reg clk;
reg rst_n;
reg en;


wire rdy;
wire [7:0] addr;
wire [7:0] wrdata;
wire wren;

reg [23:0] key;
reg [7:0] rddata;


ksa DUT(	.clk,
		.rst_n,
		.en, 
		.rdy,
		.key,
		.addr,
		.rddata,
		.wrdata, 
		.wren);

initial begin
	clk = 0;
	rddata = 0;
	key= 24'b000000110101111100111100 ;
	rst_n = 1;
	en = 0;

	#5;

	rst_n = 0;


	#5;

	en = 1;
	rst_n = 1;

	#10;

	en = 0;
	

end

initial forever #5 clk = ~clk;

endmodule: tb_rtl_ksa
