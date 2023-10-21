`timescale 1ps / 1ps

module task3(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

logic [23:0] key;
logic rdy, en, ct_wren, pt_wren;
assign key = 24'b0 + SW;

logic [7:0] ct_addr, ct_rddata, ct_wrdata, pt_addr, pt_rddata, pt_wrdata;

ct_mem ct(	.address(ct_addr),
		.clock(CLOCK_50),
		.data(wrdata),
		.wren(ct_wren),
		.q(ct_rddata));

pt_mem pt(	.address(pt_addr),
		.clock(CLOCK_50),
		.data(wrdata),
		.wren(pt_wren),
		.q(pt_rddata));


arc4 a4(	.clk(CLOCK_50),
		.rst_n(KEY[3]),
		.en, 
		.rdy,
		.key,	
		.ct_addr, 
		.ct_rddata,
		.pt_addr, 
		.pt_rddata, 
		.pt_wrdata, 
		.pt_wren);

always_ff @(posedge CLK_50)
begin

	if(rdy) en <= 1;

	if(en) en <= 0;

end

endmodule: task3
