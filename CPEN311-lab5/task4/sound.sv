module sound(input CLOCK_50, input CLOCK2_50, input [3:0] KEY, input [9:0] SW,
             input AUD_DACLRCK, input AUD_ADCLRCK, input AUD_BCLK, input AUD_ADCDAT,
			 inout FPGA_I2C_SDAT, output FPGA_I2C_SCLK, output AUD_DACDAT, output AUD_XCK,
             output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2,
             output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5,
             output [9:0] LEDR);
			
// an enumerated type for our state machine

typedef enum { state_wait_until_ready, state_send_sample, state_done, state_wait_for_accepted, state_count } state_type;

// signals that are used to communicate with the audio core

reg read_ready, write_ready, write_s;
reg [15:0] writedata_left, writedata_right;
reg [15:0] readdata_left, readdata_right;	
wire reset, read_s;

// some signals I will use in my always block

state_type state;
reg [15:0] sample;

// signals that are used to communicate with the flash core
// DO NOT alter these -- we will use them to test your design

reg flash_mem_read;
reg flash_mem_waitrequest;
reg [22:0] flash_mem_address;
reg [31:0] flash_mem_readdata;
reg flash_mem_readdatavalid;
reg [3:0] flash_mem_byteenable;
reg rst_n, clk;

// instantiate the parts of the audio core. 

clock_generator my_clock_gen(CLOCK2_50, reset, AUD_XCK);
audio_and_video_config cfg(CLOCK_50, reset, FPGA_I2C_SDAT, FPGA_I2C_SCLK);
audio_codec codec(CLOCK_50,reset,read_s,write_s,writedata_left, writedata_right,AUD_ADCDAT,AUD_BCLK,AUD_ADCLRCK,AUD_DACLRCK,read_ready, write_ready,readdata_left, readdata_right,AUD_DACDAT);
flash flash_inst(.clk_clk(clk), .reset_reset_n(rst_n), .flash_mem_write(1'b0), .flash_mem_burstcount(1'b1),
                 .flash_mem_waitrequest(flash_mem_waitrequest), .flash_mem_read(flash_mem_read), .flash_mem_address(flash_mem_address),
                 .flash_mem_readdata(flash_mem_readdata), .flash_mem_readdatavalid(flash_mem_readdatavalid), .flash_mem_byteenable(flash_mem_byteenable), .flash_mem_writedata());

// The audio core requires an active high reset signal

assign reset = ~(KEY[3]);

// we will never read from the microphone in this lab, so we might as well set read_s to 0.

assign read_s = 1'b0;

//flash reader stuff

int counter;

assign clk = CLOCK_50;
assign rst_n = KEY[3];

reg signed [31:0] readdata;
reg signed [15:0] divisor;

logic [2:0] loc;
//integer cnt;

assign flash_mem_byteenable = 4'b1111;
assign divisor = 16'd64;

reg [1:0] mode;

assign mode = SW[1:0];


// The main state machine in the design. The purpose of this state machien
// is to send samples to the audio core. This machine will send 91 high samples
// followed by 91 low samples, and repeat. It turns out that this square wave 
// will sound like a single tone when played. In the lab, you will modify this
// to send the actual samples (which descirbe a waveform much more complex
// than just a square wave).
	
always_ff @(posedge CLOCK_50)
   if (reset == 1'b1) begin
         state <= state_wait_until_ready;
			loc <= 0;
			counter <= 0;
			readdata <= 0;
         write_s <= 1'b0;
			//cnt <= 0;
			
   end else begin
      case (state)
		
         state_wait_until_ready: begin
				 
				     // In this state, we set write_s to 0,
					 // and wait for write_ready to become 1.
					 // The write_ready signal will go 1 when the FIFOs
					 // are ready to accept new data.  We can't do anything
					 // until this signal goes to a 1.
					 
				    write_s <= 1'b0;
                if (write_ready == 1'b1)  					
						if (loc[2] == 1) begin
							
							loc <= 3'b000;
							counter <= counter + 1;
							flash_mem_read <= 1'b1;
							flash_mem_address <= counter;
							state <= state_count;
							
						end
						else state <= state_send_sample;
             end // state_wait_until_ready				   
   
			state_count:
			begin
			
				if (counter < 32'h100000)
				begin
				
//					readdata <= counter * 32'h10000 + counter;
//					state <= state_send_sample;
//					flash_mem_read <= 1'b0;
//									
					if (flash_mem_readdatavalid)
					begin
						//if (flash_mem_readdata == readdata || readdata == 0 || readdata == 32'hFFFFFFFF) state <= state_count;
						//else begin
							readdata <= flash_mem_readdata;
							state <= state_send_sample;
						//end
					end
					else state <= state_count;

					
				end
				else
				begin
					//flash_mem_read <= 1'b0;
					//state <= state_done;
					counter <= 0;
					state <= state_wait_until_ready;
				end
				
			end
	
			state_done: state <= state_done;

	
         state_send_sample: begin
			
				flash_mem_read <= 1'b0;
				flash_mem_address <= 0;
				 
					if (loc > 3) begin	
					
						writedata_right <= $signed($signed(readdata[31:16])/$signed(divisor));
						writedata_left <= $signed($signed(readdata[31:16])/$signed(divisor));
					
					end else begin
					
						writedata_right <= $signed($signed(readdata[15:0])/$signed(divisor));
						writedata_left <= $signed($signed(readdata[15:0])/$signed(divisor));
						
					end
					
					
				if (mode == 2'b00 || mode == 2'b11) begin
				
					loc <= loc + 2;
					
				end else if (mode == 2'b01) begin

					loc <= loc + 4;
				
				end else if (mode == 2'b10) begin

					loc <= loc + 1;
				
				end
				
				
				write_s <= 1'b1;  
				state <= state_wait_for_accepted;
			
			end // state_send_sample
					
					
		       state_wait_for_accepted: begin

								
				    if (write_ready == 1'b0)
								
				        state <= state_wait_until_ready;
				    
					end // state_wait_for_accepted
					
	          default: begin
				 
				    // should never happen, but good practice
					 
                state <= state_wait_until_ready;
					 
				 end // default
			endcase
     end  // if 

endmodule: sound
