module music(input CLOCK_50, input CLOCK2_50, input [3:0] KEY, input [9:0] SW,
             input AUD_DACLRCK, input AUD_ADCLRCK, input AUD_BCLK, input AUD_ADCDAT, input write_ready,
             inout FPGA_I2C_SDAT, output FPGA_I2C_SCLK, output AUD_DACDAT, output AUD_XCK,
             output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2,
             output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5,
             output [9:0] LEDR);
			
// signals that are used to communicate with the audio core
// DO NOT alter these -- we will use them to test your design

reg read_ready, write_s;
//reg write_ready;
reg [15:0] writedata_left, writedata_right;
reg [15:0] readdata_left, readdata_right;	
wire reset, read_s;

// signals that are used to communicate with the flash core
// DO NOT alter these -- we will use them to test your design

reg flash_mem_read;
reg flash_mem_waitrequest;
reg [22:0] flash_mem_address;
reg [31:0] flash_mem_readdata;
reg flash_mem_readdatavalid;
reg [3:0] flash_mem_byteenable;
reg rst_n, clk;

// DO NOT alter the instance names or port names below -- we will use them to test your design

clock_generator my_clock_gen(CLOCK2_50, reset, AUD_XCK);
audio_and_video_config cfg(CLOCK_50, reset, FPGA_I2C_SDAT, FPGA_I2C_SCLK);
audio_codec codec(CLOCK_50,reset,read_s,write_s,writedata_left, writedata_right,AUD_ADCDAT,AUD_BCLK,AUD_ADCLRCK,AUD_DACLRCK,read_ready, write_ready,readdata_left, readdata_right,AUD_DACDAT);
flash flash_inst(.clk_clk(clk), .reset_reset_n(rst_n), .flash_mem_write(1'b0), .flash_mem_burstcount(1'b1),
                 .flash_mem_waitrequest(flash_mem_waitrequest), .flash_mem_read(flash_mem_read), .flash_mem_address(flash_mem_address),
                 .flash_mem_readdata(flash_mem_readdata), .flash_mem_readdatavalid(flash_mem_readdatavalid), .flash_mem_byteenable(flash_mem_byteenable), .flash_mem_writedata());

// your code for the rest of this task here

// an enumerated type for our state machine

typedef enum { state_wait_until_ready, state_store, state_count, state_send_sample, state_wait_for_accepted } state_type;

// some signals I will use in my always block

integer cnt;
state_type state;
reg [15:0] sample;
assign reset = ~(KEY[3]);
assign read_s = 1'b0;

reg signed [15:0] divisor = 64;


//flash reader stuff

int counter;

assign clk = CLOCK_50;
assign rst_n = KEY[3];

reg signed [31:0] readdata;

logic [7:0] address;
logic [15:0] data, q;
logic wren;

logic loc;

assign flash_mem_byteenable = 4'b1111;



	
always_ff @(posedge CLOCK_50)
   if (reset == 1'b1) begin
         state <= state_wait_until_ready;
         write_s <= 1'b0;
	loc <= 0;
			
   end else begin
      case (state)
		
      		state_wait_until_ready: begin
			write_s <= 1'b0;
                	if (write_ready == 1)  begin
				if (loc == 0) state <= state_count;
				else state <= state_send_sample;
			end
             	end		   
   
            	state_store: 
            	begin
			readdata <= flash_mem_readdata;
			state <= state_send_sample;
           	end

		state_count:
		begin
			if (counter < 24'h80000)
			begin
				state <= state_store;
			end else begin
				counter <= 0;
			end
		end

         	state_send_sample: begin
					 
			if (loc == 0) begin
				writedata_right <= readdata[31:16]/divisor;
				writedata_left <= readdata[31:16]/divisor;
			end
			else begin
				writedata_right <= readdata[15:0]/divisor;
				writedata_left <= readdata[15:0]/divisor;
 			end

	 		write_s <= 1'b1;  

			loc <= loc + 1;
			counter <= counter + 1;
        	        state <= state_wait_for_accepted;
		end 
					
		state_wait_for_accepted: begin
					 
			if (write_ready == 1'b0) state <= state_wait_until_ready;    
			else state <= state_wait_for_accepted;
		end 
					
		default: begin
				 
        	        state <= state_wait_until_ready;
					 
		end // default

	endcase

end  // if 

always_comb 

begin

	casez(state)
		state_wait_until_ready: 
		begin
			flash_mem_read = 1'b0;
		end

		state_count:
		begin
			flash_mem_read = 1'b1;

			flash_mem_address = counter;

		end

		state_store:
		begin
			flash_mem_read = 1'b0;

		end

         	state_send_sample: begin

			flash_mem_read = 1'b0;
					 
		end 
					
		state_wait_for_accepted: begin

			flash_mem_read = 1'b0;

		end

		default: 
		begin
			flash_mem_read = 1'b0;
		end
	endcase
end

endmodule: music
