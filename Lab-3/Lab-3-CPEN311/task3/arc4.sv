`timescale 1ps / 1ps

module arc4(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);


logic [7:0] address_init;
logic [7:0] wrdata_init;
logic wren_init;

logic [7:0] address_ksa;
logic [7:0] wrdata_ksa;
logic wren_ksa;

logic [7:0] address_prga;
logic [7:0] wrdata_prga;
logic wren_prga;

logic rdy_ksa, rdy_prga, rdy_init;
logic en_ksa, en_prga, en_init;

enum reg [3:0] {state_init, state_swap, state_default, state_wait_init, state_wait_swap, state_wait_prga, state_prga} state;

logic [7:0] address;
assign address = (~rdy)? address_init:(~rdy_ksa)? address_ksa:address_prga;
logic [7:0] wrdata; 
assign wrdata = (~rdy)? wrdata_init:(~rdy_ksa)? wrdata_ksa:wrdata_prga;
logic wren;
assign wren = (~rdy)? wren_init:(~rdy_ksa)? wren_ksa:wren_prga;

logic [7:0] q;


init i(		.clk(CLOCK_50),
		.rst_n,
		.en, 
		.rdy,
		.addr(address_init),
		.wrdata(wrdata_init), 
		.wren(wren_init));

s_mem s(	.address,
		.clock(CLOCK_50),
		.data(wrdata),
		.wren,
		.q);

ksa k (		.clk(CLOCK_50),
		.rst_n,
		.en,
		.rdy(rdy_ksa),
		.key,
		.addr(address_ksa), 
		.rddata(q), 
		.wrdata(wrdata_ksa),
		.wren(wren_ksa));

prga p( 	.clk(CLOCK_50),
		.rst_n,
		.en,
		.rdy(rdy_prga),
		.key,
		.s_addr(address_prga),
		.ct_addr,
		.pt_addr,
		.s_rddata(q), 
		.ct_rddata, 
		.pt_rddata, 
		.s_wrdata(wrdata_prga),
		.pt_wrdata,
		.s_wren(wren_prga),
		.pt_wren);


always_ff @(posedge CLOCK_50)
begin

	if(~rst_n) begin
		state <= state_default;
	end

	else begin

		case(state)
			state_default: begin
				if(rdy_init) begin
					en_init <= 1;
					state <= state_wait_init;
				end
				else state <= state_default;
			end

			state_wait_init: begin
				en_init <= 0;
				state <= state_init;
			end

			state_init: begin
				if(rdy_init) begin
					en_ksa <= 1;
					state <= state_wait_swap;
				end
				else state <= state_init;
			end

			state_wait_swap: begin
				en_ksa <= 0;
				state <= state_swap;
			end

			state_swap: begin		
				if(rdy_ksa) begin
					en_prga <= 1;
					state <= state_wait_prga;
				end
				else state <= state_swap;
			end

			state_wait_prga: begin
				en_ksa <= 0;
				state <= state_prga;
			end

			state_prga: begin		
				if(rdy_prga) begin
					state <= state_default;
				end
				else state <= state_prga;
			end

			default: begin
				if(rdy_init) begin
					en_init <= 1;
					state <= state_init;
				end
				else state <= state_default;
			end
			
		endcase
	end

end

endmodule: arc4
