module flash_reader(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
                    output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
                    output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
                    output logic [9:0] LEDR);

	// You may use the SW/HEX/LEDR ports for debugging. DO NOT delete or rename any ports or signals.
	enum reg [4:0] {state_start,state_ready, state_write1, state_write2, state_store, state_count,state_done} state;
	logic clk, rst_n;

	logic [31:0] sample;
	int counter;

	assign clk = CLOCK_50;
	assign rst_n = KEY[3];

	logic flash_mem_read, flash_mem_waitrequest, flash_mem_readdatavalid;
	logic [22:0] flash_mem_address;
	logic [31:0] flash_mem_readdata;
	logic [3:0] flash_mem_byteenable;

	reg [31:0] readdata;

	logic [7:0] address;
	logic [15:0] data, q;
	logic wren;

	assign flash_mem_byteenable = 4'b1111;


	flash flash_inst(.clk_clk(clk), .reset_reset_n(rst_n), .flash_mem_write(1'b0), .flash_mem_burstcount(7'b1),
					.flash_mem_waitrequest(flash_mem_waitrequest), .flash_mem_read(flash_mem_read), .flash_mem_address(flash_mem_address),
					.flash_mem_readdata(flash_mem_readdata), .flash_mem_readdatavalid(flash_mem_readdatavalid), .flash_mem_byteenable(flash_mem_byteenable), .flash_mem_writedata());

	s_mem samples(.address,.clock(CLOCK_50),.data,.wren,.q);

	
	// the rest of your code goes here.  don't forget to instantiate the on-chip memory
	always_ff @(posedge clk)
	begin
		if(rst_n == 0)
		begin
			state <= state_start;
		end
		else 
		begin
			casez(state) 
			state_start: 
			begin
				counter <= 0;
				state <= state_count;
			end

			state_store: 
			begin
				
				if (flash_mem_readdatavalid)
				begin
					readdata <= flash_mem_readdata;
					state <= state_write1;
				end
				else
				begin
					state <= state_count;
				end
			end

			state_write1:
			begin
				state <= state_write2;
			end

			state_write2:
			begin
				counter <= counter + 1;
				state <= state_count;
			end

			state_count:
			begin
				if (counter < 128)
				begin
					counter <= counter + 1;
					state <= state_store;
				end
				else
				begin
					state <= state_done;
				end
			end
				
			state_done: state <= state_done;

			default: state <= state_done;
			endcase
		end
	end


	always_comb
	begin
		casez(state)
			state_start: 
			begin
				wren = 1'b0;
				flash_mem_read = 1'b1;
				address = counter * 2;
				data = readdata[31:16];
				flash_mem_address = counter;
			end

			state_ready: 
			begin
				wren = 1'b0;
				flash_mem_read = 1'b1;
				address = counter * 2;
				data = readdata[31:16];
				flash_mem_address = counter;
			end

			state_write1:
			begin

				wren = 1'b1;
				flash_mem_read = 1'b0;
				flash_mem_address = counter;
				address = counter * 2;
				data = readdata[31:16];

			end

			state_write2:
			begin
				wren = 1'b1;
				flash_mem_read = 1'b0;
				flash_mem_address = counter;
				address = counter * 2 + 1;
				data = readdata[15:0];
			end

			state_count:
			begin
				wren = 1'b0;
				flash_mem_read = 1'b1;
				flash_mem_address = counter;
				address = counter * 2;
				data = readdata[31:16];

			end

			state_store:
			begin
				wren = 1'b0;
				flash_mem_read = 1'b1;
				address = counter * 2;
				data = readdata[31:16];
				flash_mem_address = counter;

			end

			state_done:
			begin
				wren = 1'b0;
				flash_mem_read = 1'b0;
				address = counter * 2;
				data = readdata[31:16];
				flash_mem_address = counter;
			end

			default: 
			begin
				wren = 1'b0;
				flash_mem_read = 1'b1;
				address = counter * 2;
				data = readdata[31:16];
				flash_mem_address = counter;
			end
		endcase
	end

endmodule: flash_reader