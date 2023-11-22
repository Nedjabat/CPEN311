module flash_reader(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
                    output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
                    output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
                    output logic [9:0] LEDR);

// You may use the SW/HEX/LEDR ports for debugging. DO NOT delete or rename any ports or signals.
enum reg [4:0] {state_rest, state_start, state_do, state_ready} state;

logic clk, rst_n;

assign clk = CLOCK_50;
assign rst_n = KEY[3];

logic flash_mem_read, flash_mem_waitrequest, flash_mem_readdatavalid;
logic [22:0] flash_mem_address;
logic [31:0] flash_mem_readdata;
logic [3:0] flash_mem_byteenable;

flash flash_inst(.clk_clk(clk), .reset_reset_n(rst_n), .flash_mem_write(1'b0), .flash_mem_burstcount(1'b1),
                 .flash_mem_waitrequest(flash_mem_waitrequest), .flash_mem_read(flash_mem_read), .flash_mem_address(flash_mem_address),
                 .flash_mem_readdata(flash_mem_readdata), .flash_mem_readdatavalid(flash_mem_readdatavalid), .flash_mem_byteenable(flash_mem_byteenable), .flash_mem_writedata());

s_mem samples(.address,.clock(CLOCK_50),.data(wrdata),.wren,.q);

assign flash_mem_byteenable = 4'b1111;

// the rest of your code goes here.  don't forget to instantiate the on-chip memory
always_ff @(posedge clk)
begin

	if(rst_n == 0)
    begin
		state <= state_start;
	end

	else if (en == 1) 
    begin
		if (state == state_ready) 
            state <= state_rest;
	end

	else 
    begin
        casez(state) 
            state_rest: 
            begin
                state <= state_rest;
            end
            state_start: 
            begin
                counter <= 0;
                state <= state_do;
            end
            state_do: 
            begin
                
            end
            default: state <= state_rest;
        endcase

	end

end


always_comb 

begin

	casez(state)
		state_rest: begin
			rdy = 0;
			wren = 0;
			addr = 0;
			wrdata = 0;
		end
		state_start: begin
			rdy = 0;
			wren = 0;
			addr = 0;
			wrdata = 0;
		end
		state_do: begin
			rdy = 0;
			wren = 1;
			addr = counter;
			wrdata = counter;
		end
		state_ready:begin
			rdy = 1;
			wren = 0;
			addr = 0;
			wrdata = 0;
		end
		default: begin
			rdy = 0;
			wren = 0;
			addr = 0;
			wrdata = 0;
		end
	endcase

end

endmodule: flash_reader