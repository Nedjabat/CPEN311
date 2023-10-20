`timescale 1ps / 1ps

module ksa(input logic clk, input logic rst_n,
           input logic en, output logic rdy,
           input logic [23:0] key,
           output logic [7:0] addr, input logic [7:0] rddata, output logic [7:0] wrdata, output logic wren);

enum reg [3:0] {state_rest, state_ready, state_readi, state_calculatej, state_readj, state_begin, state_writei, state_writej} state, next_state;

reg [7:0] i_data, j_data, j;

reg [7:0] counter = 0;

always_ff @(posedge clk)
begin

	if(rst_n == 0)begin

		state <= state_ready;
	
	end

	else if (en == 1) begin

		state <= state_begin;
	
	end

	else begin

		case(state) 

			state_rest: state <= state_rest;
			state_ready: begin
				state <= state_ready;
				j <= 0;
				i_data <= 0;
			end
			state_begin: begin
				state <= state_readi;

			end
			state_readi: begin

				i_data <= rddata;
				j_data <= 0;

				if((counter) % 3 == 0) begin
					j <= (j + rddata + key[23:16]) % 256;
				end
				else if((counter) % 3 == 1) begin
					j <= (j + rddata + key[15:8]) % 256;
				end
				else if((counter) % 3 == 2) begin
					j <= (j + rddata + key[7:0]) % 256;
				end

				state <= state_calculatej;
	
			end
			state_calculatej: state <= state_readj;
			state_readj: begin

				j_data <= rddata;
				state <= state_writei;
	
			end
	
			state_writei: begin
	
				state <= state_writej;
	
			end
	
			state_writej: begin
				if(counter == 8'd255) begin
					counter <= 0;
					state <= state_rest;
				end
				else begin
					counter <= counter + 8'd1;
					state <= state_begin;
				end
	
			end
			
	
			default: state <= state_rest;
	
		endcase

	end

end



always_comb begin
	case(state) 

		state_rest: begin

			wren = 0;
			addr = 0;
			wrdata = 0;
			rdy = 0;

		end
		state_ready: begin

			wren = 0;
			addr = 0;
			wrdata = 0;
			rdy = 1;

		end
		state_begin: begin
			
			wren = 0;
			addr = counter;
			wrdata = 0;
			rdy = 0;

		end
		state_readi: begin

			wren = 0;
			addr = j;
			wrdata = 0;
			rdy = 0;

		end

		state_calculatej: begin

			wren = 0;
			addr = j;
			wrdata = 0;
			rdy = 0;

		end

		state_readj: begin
 

			wren = 1;
			addr = counter;
			wrdata = j_data;
			rdy = 0;

		end

		state_writei: begin

			wren = 1;
			addr = j;
			wrdata = i_data;
			rdy = 0;


		end

		state_writej: begin

			wren = 1;
			addr = counter;
			wrdata = j_data;
			rdy = 0;


		end
		

		default: begin

			wren = 0;
			addr = 0;
			wrdata = 0;
			rdy = 0;

		end

	endcase

end


endmodule: ksa
