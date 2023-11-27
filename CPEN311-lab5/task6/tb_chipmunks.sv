module tb_chipmunks();

// Your testbench goes here.

logic CLOCK_50;
logic CLOCK2_50;
logic [3:0] KEY;
logic [9:0] SW;

logic [9:0] LEDR;
logic [6:0] HEX0; 
logic [6:0] HEX1;
logic [6:0] HEX2;
logic [6:0] HEX3; 
logic [6:0] HEX4;
logic [6:0] HEX5;
logic write_ready;


logic AUD_DACLRCK;
logic AUD_ADCLRCK; 
logic AUD_BCLK; 
logic AUD_ADCDAT;
wire FPGA_I2C_SDAT;
logic FPGA_I2C_SCLK;
logic AUD_DACDAT;
logic AUD_XCK;


chipmunks DUT(.CLOCK_50, .CLOCK2_50, .KEY,
             .SW, .AUD_DACLRCK, .AUD_ADCLRCK, .AUD_BCLK, .AUD_ADCDAT,
             .FPGA_I2C_SDAT,.FPGA_I2C_SCLK, .AUD_DACDAT, .AUD_XCK,.LEDR, .HEX0, .HEX1, .HEX2,
             .HEX3, .HEX4, .HEX5);


initial begin

	//write_ready = 1'b0;
	CLOCK_50 = 0;
	KEY[3] = 1;
	#5;
	KEY[3] = 0;
	#5;
	KEY[3] = 1;

	

end


initial forever #5 CLOCK_50 = ~CLOCK_50;
//initial forever #20 write_ready = ~write_ready;

endmodule: tb_chipmunks

module flash(input logic clk_clk, input logic reset_reset_n,
             input logic flash_mem_write, input logic flash_mem_burstcount,
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
// Any other simulation-only modules you need

