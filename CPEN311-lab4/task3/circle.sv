module circle(input logic clk, input logic rst_n, input logic [2:0] colour,
              input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] radius,
              input logic start, output logic done,
              output logic [7:0] vga_x, output logic [6:0] vga_y,
              output logic [2:0] vga_colour, output logic vga_plot);
	
	//colour should be assigned by top module, would be green in this task
	assign vga_colour = colour;


	reg signed [9:0] offset_x; 
	reg signed [9:0] offset_y;
	reg signed [9:0] crit;

	enum reg [5:0] {state_rest, state_start, p1, p2, p3, p4, p5, p6, p7, p8} state;


	//state machine calculates offset_x, offset_y, and crit because they need to be remembered
	//it should cycle through the 8 pixels and at the last pixel it will check if it's done
	always_ff @(posedge clk, negedge rst_n) 
	begin

		if (rst_n == 0)
		begin
			state = state_rest;
		end

		else if (start == 1 && state == state_rest)
		begin
			state = state_start;
		end

		else begin

			casez(state)

			state_rest: state <= state_rest;
			state_start: begin
				offset_y = 0;
				offset_x = radius;
				crit = 1 - radius;

				if (offset_y <= offset_x) state <= p1; 
				else state <= state_rest;
			end
			p1: state <= p2; 
			p2: state <= p3; 
			p3: state <= p4; 
			p4: state <= p5; 
			p5: state <= p6; 
			p6: state <= p7; 
			p7: state <= p8; 
			p8: begin
				
			//the calculation for crit needs to be signed somehow
			// i made everything here signed so hopefully it works
				offset_y <= offset_y + 1;
				
				if(crit <= 0) crit <= crit + (2 * offset_y) + 1; 
				else begin
					offset_x <= offset_x - 1;
					crit <= crit + 2 * (offset_y - offset_x) + 1;
				
				end

				if (offset_y <= offset_x) state <= p1; 
				else 
				begin
					state <= state_rest;
					done <= 1;
				end
				
			end
			default: state <= state_rest;

			endcase

		end
	end

	//comb logic needs to output x, y, and plot
	//if x or y is out of bounds then dont draw anything 
	//u can check to see if i made any mistakes
	always_comb  
     	begin

		casez(state)

			state_rest: begin
				vga_x = 0;
				vga_y = 0;
				vga_plot = 0;
			end

			state_start: begin
				vga_x = 0;
				vga_y = 0;
				vga_plot = 0;
			end

			p1: begin

				if((centre_x + offset_x[8:0]) > 159 || (centre_x + offset_x[8:0]) < 0 
					|| (centre_y + offset_y[8:0]) > 119 || (centre_y + offset_y[8:0]) < 0) begin
					vga_x = 0;
					vga_y = 0;
					vga_plot = 0;
				end
				else begin
					vga_x = (centre_x + offset_x[8:0]);
					vga_y = (centre_y + offset_y[8:0]);
					vga_plot = 1;
				end 
			end

			p2: begin

				if((centre_x + offset_y[8:0]) > 159 || (centre_x + offset_y[8:0]) < 0 
					|| (centre_y + offset_x[8:0]) > 119 || (centre_y + offset_x[8:0]) < 0) begin
					vga_x = 0;
					vga_y = 0;
					vga_plot = 0;
				end
				else begin
					vga_x = (centre_x + offset_y[8:0]);
					vga_y = (centre_y + offset_x[8:0]);
					vga_plot = 1;
				end 

			end

			p3: begin
				if((centre_x - offset_x[8:0]) > 159 || (centre_x - offset_x[8:0]) < 0 
					|| (centre_y + offset_y[8:0]) > 119 || (centre_y + offset_y[8:0]) < 0) begin
					vga_x = 0;
					vga_y = 0;
					vga_plot = 0;
				end
				else begin
					vga_x = (centre_x - offset_x[8:0]);
					vga_y = (centre_y + offset_y[8:0]);
					vga_plot = 1;
				end 
			end

			p4: begin
				if((centre_x - offset_y[8:0]) > 159 || (centre_x - offset_y[8:0]) < 0 
					|| (centre_y + offset_x[8:0]) > 119 || (centre_y + offset_x[8:0]) < 0) begin
					vga_x = 0;
					vga_y = 0;
					vga_plot = 0;
				end
				else begin
					vga_x = (centre_x - offset_y[8:0]);
					vga_y = (centre_y + offset_x[8:0]);
					vga_plot = 1;
				end 
			end
 
			p5: begin
				if((centre_x - offset_x[8:0]) > 159 || (centre_x - offset_x[8:0]) < 0 
					|| (centre_y - offset_y[8:0]) > 119 || (centre_y - offset_y[8:0]) < 0) begin
					vga_x = 0;
					vga_y = 0;
					vga_plot = 0;
				end
				else begin
					vga_x = (centre_x - offset_x[8:0]);
					vga_y = (centre_y - offset_y[8:0]);
					vga_plot = 1;
				end 
			end

			p6: begin
				if((centre_x - offset_y[8:0]) > 159 || (centre_x - offset_y[8:0]) < 0 
					|| (centre_y - offset_x[8:0]) > 119 || (centre_y - offset_x[8:0]) < 0) begin
					vga_x = 0;
					vga_y = 0;
					vga_plot = 0;
				end
				else begin
					vga_x = (centre_x - offset_y[8:0]);
					vga_y = (centre_y - offset_x[8:0]);
					vga_plot = 1;
				end 
			end

			p7: begin
				if((centre_x + offset_x[8:0]) > 159 || (centre_x + offset_x[8:0]) < 0 
					|| (centre_y - offset_y[8:0]) > 119 || (centre_y - offset_y[8:0]) < 0) begin
					vga_x = 0;
					vga_y = 0;
					vga_plot = 0;
				end
				else begin
					vga_x = (centre_x + offset_x[8:0]);
					vga_y = (centre_y - offset_y[8:0]);
					vga_plot = 1;
				end 
			end

			p8: begin
				if((centre_x + offset_y[8:0]) > 159 || (centre_x + offset_y[8:0]) < 0 
					|| (centre_y - offset_x[8:0]) > 119 || (centre_y - offset_x[8:0]) < 0) begin
					vga_x = 0;
					vga_y = 0;
					vga_plot = 0;
				end
				else begin
					vga_x = (centre_x + offset_y[8:0]);
					vga_y = (centre_y - offset_x[8:0]);
					vga_plot = 1;
				end 
			end
			
			default: begin
				vga_x = 0;
				vga_y = 0;
				vga_plot = 0;
			end

		endcase

	end


	
endmodule

