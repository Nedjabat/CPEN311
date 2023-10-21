`timescale 1ps / 1ps

module prga(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] s_addr, input logic [7:0] s_rddata, output logic [7:0] s_wrdata, output logic s_wren,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    

enum reg [4:0] {state_rest, state_ready, state_begin, state_waiti, state_readi, state_waitj, state_readj,
state_writei, state_writej, state_wait_pad, state_read_pad, state_writep} state;

reg [7:0] i_data, j_data, j, i, k, pad, pad_data, c_data, p_data;

always_ff @(posedge clk or negedge rst_n)
begin

	if(rst_n == 0)begin

		state <= state_ready;
	
	end

	else begin

		case(state) 

			state_rest: begin
				state <= state_rest;
			end			
			state_ready: begin
				i <= 0;
				if (en) state <= state_begin;
				else state <= state_ready;
			end
			state_begin: begin
				k <= 0;
				j <= 0;
				i <= (i + 1) % 256;
				state <= state_waiti;
			end

			state_waiti: begin
				state <= state_readi;
			end

			state_readi: begin
				j <= (j + s_rddata) % 256;
				i_data <= s_rddata;
				state <= state_waitj;
	
			end

			state_waitj: state <= state_readj;

			state_readj: begin

				j_data <= s_rddata;
				state <= state_writei;
	
			end
	
			state_writei: begin
	
				state <= state_writej;
	
			end
	
			state_writej: begin
				
				k <= (i_data + j_data) % 256;
				state <= state_wait_pad;

	
			end
			state_wait_pad: begin

				state <= state_read_pad;

			end
			state_read_pad: begin

				p_data = s_rddata^ct_rddata;
				state <= state_writep;

			end

			state_writep: begin
				if(ct_rddata == k) begin
					state <= state_ready;
				end else begin
					k <= k + 8'd1;
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

			s_wren = 0;
			pt_wren = 0;
			s_addr = 0;
			ct_addr = 0;
			pt_addr = 0;
			s_wrdata = 0;
			pt_wrdata = 0;
			rdy = 0;

		end
		state_ready: begin

			s_wren = 0;
			pt_wren = 0;
			s_addr = 0;
			ct_addr = 0;
			pt_addr = 0;
			s_wrdata = 0;
			pt_wrdata = 0;
			rdy = 0;

		end
		state_begin: begin
			
			s_wren = 0;
			pt_wren = 0;
			s_addr = i;
			ct_addr = 0;
			pt_addr = 0;
			s_wrdata = 0;
			pt_wrdata = 0;
			rdy = 0;

		end

		state_waiti: begin

			s_wren = 0;
			pt_wren = 0;
			s_addr = i;
			ct_addr = 0;
			pt_addr = 0;
			s_wrdata = 0;
			pt_wrdata = 0;
			rdy = 0;

		end
		state_readi: begin

			s_wren = 0;
			pt_wren = 0;
			s_addr = j;
			ct_addr = 0;
			pt_addr = 0;
			s_wrdata = 0;
			pt_wrdata = 0;
			rdy = 0;

		end

		state_waitj: begin

			s_wren = 0;
			pt_wren = 0;
			s_addr = j;
			ct_addr = 0;
			pt_addr = 0;
			s_wrdata = 0;
			pt_wrdata = 0;
			rdy = 0;
		end

		state_readj: begin
 
			s_wren = 0;
			pt_wren = 0;
			s_addr = 0;
			ct_addr = 0;
			pt_addr = 0;
			s_wrdata = 0;
			pt_wrdata = 0;
			rdy = 0;
		end

		state_writei: begin

			s_wren = 1;
			pt_wren = 0;
			s_addr = j;
			ct_addr = 0;
			pt_addr = 0;
			s_wrdata = i_data;
			pt_wrdata = 0;
			rdy = 0;

		end

		state_writej: begin

			s_wren = 1;
			pt_wren = 0;
			s_addr = i;
			ct_addr = 0;
			pt_addr = 0;
			s_wrdata = j_data;
			pt_wrdata = 0;
			rdy = 0;

		end
		
		state_wait_pad: begin

			s_wren = 0;
			pt_wren = 0;
			s_addr = pad;
			ct_addr = k;
			pt_addr = 0;
			s_wrdata = 0;
			pt_wrdata = 0;
			rdy = 0;

		end

		state_read_pad: begin

			s_wren = 0;
			pt_wren = 0;
			s_addr = 0;
			ct_addr = (k+1);
			pt_addr = 0;
			s_wrdata = 0;
			pt_wrdata = 0;
			rdy = 0;

		end

		state_writep: begin

			s_wren = 0;
			pt_wren = 1;
			s_addr = 0;
			ct_addr = 0;
			pt_addr = 1;
			s_wrdata = 0;
			pt_wrdata = p_data;
			rdy = 0;


		end
		

		default: begin

			s_wren = 0;
			pt_wren = 0;
			s_addr = 0;
			ct_addr = 0;
			pt_addr = 0;
			s_wrdata = 0;
			pt_wrdata = 0;
			rdy = 0;

		end

	endcase

end

endmodule: prga
