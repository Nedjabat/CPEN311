module tb_rtl_init();

reg clk;
reg rst_n;
reg en;


wire rdy;
wire [7:0] addr;
wire [7:0] wrdata;
wire wren;




init DUT(	.clk,
		.rst_n,
		.en, 
		.rdy,
		.addr,
		.wrdata, 
		.wren);

initial begin
	clk = 0;
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

endmodule: tb_rtl_init
