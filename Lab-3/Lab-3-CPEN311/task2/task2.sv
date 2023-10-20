`timescale 1ps / 1ps

module task2(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

logic [7:0] address_init;
logic [7:0] wrdata_init;
logic wren_init;

logic [7:0] address_ksa;
logic [7:0] wrdata_ksa;
logic wren_ksa;

enum reg [3:0] {state_init1, state_init, state_swap1, state_swap, state_default} state, next_state;

logic [7:0] address;
assign address = (state == state_init)? address_init:address_ksa;
logic [7:0] wrdata; 
assign wrdata = (state == state_init)? wrdata_init:wrdata_ksa;
logic wren;
assign wren = (state == state_init)? wren_init:wren_ksa;

logic [23:0] key;
assign key = 24'b0 + SW;

logic en_init;
logic rdy_init;


logic en_ksa;
logic rdy_ksa;

logic [7:0] q;


    init i(	.clk(CLOCK_50),
		.rst_n(KEY[3]),
		.en(en_init), 
		.rdy(rdy_init),
		.addr(address_init),
		.wrdata(wrdata_init), 
		.wren(wren_init));

    s_mem s(	.address,
		.clock(CLOCK_50),
		.data(wrdata),
		.wren,
		.q);

	ksa k (	.clk(CLOCK_50),
		.rst_n(KEY[3]),
		.en(en_ksa),
		.rdy(rdy_ksa),
		.key,
		.addr(address_ksa), 
		.rddata(q), 
		.wrdata(wrdata_ksa),
		.wren(wren_ksa));


always_ff @(posedge CLOCK_50)
begin

	if (~KEY[3]) begin

		state <= state_init1;

	end

	else begin

		state <= next_state;
	end

end


always_comb begin

	case(state)
		state_default: next_state = state_default;
		state_init1: next_state = state_init;
		state_init: begin
			//next_state = state_init;
			if (wren) next_state = state_init;
			else next_state = state_swap1;

		end		
		state_swap1: next_state = state_swap;
		state_swap: next_state = state_swap;

		default: next_state = state_default;
		
	endcase

end

always_comb begin 

	case(state)

		state_default: begin
			en_init = 0;
			en_ksa = 0;
		end
		state_init1: begin
			en_init = 1;
			en_ksa = 0;
		end
		state_init: begin
			en_init = 0;
			en_ksa = 0;
		end
		state_swap1: begin
			en_init = 0;
			en_ksa = 1;
		end
		state_swap: begin
			en_init = 0;
			en_ksa = 0;
		end

		default: begin
			en_init = 0;
			en_ksa = 0;
		end
	endcase
end

endmodule: task2
