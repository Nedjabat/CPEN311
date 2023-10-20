`timescale 1ps / 1ps
module tb_syn_init();

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
    #10;
    while(addr <= 255) 
    begin
		$display(" addr/wrdata = %d", addr);
		#10;
		if(addr == 0) break; 
    end
    $stop(0);

	end
	

initial forever #5 clk = ~clk;



endmodule: tb_syn_init
