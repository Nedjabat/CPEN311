module tb_flash_reader();

logic CLOCK_50;
logic [3:0] KEY;
logic [9:0] SW;

logic [9:0] LEDR;
logic [6:0] HEX0; 
logic [6:0] HEX1;
logic [6:0] HEX2;
logic [6:0] HEX3; 
logic [6:0] HEX4;
logic [6:0] HEX5;

flash_reader DUT(.CLOCK_50, .KEY,
             .SW, .LEDR, .HEX0, .HEX1, .HEX2,
             .HEX3, .HEX4, .HEX5);


initial begin

	CLOCK_50 = 0;
	KEY[3] = 1;
	#5;
	KEY[3] = 0;
	#5;
	KEY[3] = 1;


end


initial forever #5 CLOCK_50 = ~CLOCK_50;


endmodule: tb_flash_reader

module flash(input logic clk_clk, input logic reset_reset_n,
             input logic flash_mem_write, input logic [6:0] flash_mem_burstcount,
             output logic flash_mem_waitrequest, input logic flash_mem_read,
             input logic [22:0] flash_mem_address, output logic [31:0] flash_mem_readdata,
             output logic flash_mem_readdatavalid, input logic [3:0] flash_mem_byteenable,
             input logic [31:0] flash_mem_writedata);

always_ff @(posedge clk_clk) begin

	if(flash_mem_read)begin

		flash_mem_readdata <= (flash_mem_address * 10000 + flash_mem_address * 2);


	end
	else flash_mem_readdata <= 0;

end

endmodule: flash
