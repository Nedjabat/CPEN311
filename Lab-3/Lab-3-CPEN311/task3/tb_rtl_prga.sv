module tb_rtl_prga();


logic clk, rst_n, en;
logic [23:0] key;
logic [7:0] s_rddata, ct_rddata, pt_rddata;


logic rdy;
logic [7:0] s_addr, ct_addr, pt_addr, s_wrdata, pt_wrdata;
logic s_wren, pt_wren;



prga p( 	.clk,
		.rst_n,
		.en,
		.rdy,
		.key,
		.s_addr,
		.ct_addr,
		.pt_addr,
		.s_rddata, 
		.ct_rddata, 
		.pt_rddata, 
		.s_wrdata,
		.pt_wrdata,
		.s_wren,
		.pt_wren);









endmodule: tb_rtl_prga
