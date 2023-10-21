`timescale 1ps / 1ps

module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

enum reg [4:0] {state_rest, state_start, state_fill, state_ready} state;
reg [7:0] counter;

always_ff @(posedge clk)
begin

	if(rst_n == 0)begin

		state <= state_ready;
	
	end

	else begin

	casez(state) 
		state_rest: begin
			state <= state_rest;
		end
		state_ready: begin
			if (en) state <= state_start;
			else state <= state_ready;
		end
		state_start: begin
			counter <= 0;
			state <= state_fill;
		end
		state_fill: begin
			if(counter == 255) state <= state_ready;
			else state <= state_fill;
			counter <= counter + 1;
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
		state_fill: begin
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




endmodule: init