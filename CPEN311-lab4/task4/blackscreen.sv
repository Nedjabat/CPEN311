module reuleaux(input logic clk, input logic rst_n, input logic [2:0] colour,
                input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] diameter,
                input logic start, output logic done,
                output logic [7:0] vga_x, output logic [6:0] vga_y,
                output logic [2:0] vga_colour, output logic vga_plot);

	//colour should be assigned by top module
	assign vga_colour = colour;

	reg signed [9:0] offset_x; 
	reg signed [9:0] offset_y;
	reg signed [9:0] crit;

	enum reg [5:0] {state_rest, state_start, c1o1, c1o2, c2o6, c2o7, c3o3, c3o4} state;

	//my idea is that we only need to draw octant 1 and 2 of the left circle, octant 6 and 7 of the top circle,
	//and octant 3 and 4 of the right circle
	//and we check if the points are between the 3 points of the triangle and if they're within bounds

	reg [8:0] ptop_x;
	reg [8:0] pleft_x;
	reg [8:0] pright_x;

	reg [8:0] ptop_y;
	reg [8:0] pleft_y;
	reg [8:0] pright_y;


	assign ptop_x = centre_x;
	assign ptop_y = centre_y + (diameter/2);
	assign pleft_x = centre_x - (diameter/2);
	assign pleft_y = centre_y - (diameter/2);
	assign pright_x = centre_x + (diameter/2);
	assign pright_y = centre_y - (diameter/2);


	//state machine calculates offset_x, offset_y, and crit because they need to be remembered
	//it should draw first circle, second circle, then 3rd circle

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
				offset_y <= 0;
				offset_x <= diameter;
				crit <= 1 - diameter;

				if (offset_y <= offset_x) state <= c1o1; 
				else state <= state_rest;
			end
			c1o1: state <= c1o2; 
			c1o2: begin

				offset_y <= offset_y + 1;
				
				if(crit <= 0) crit <= crit + (2 * offset_y) + 1; 
				else begin
					offset_x <= offset_x - 1;
					crit <= crit + 2 * (offset_y - offset_x) + 1;
				
				end

				if (offset_y <= offset_x) state <= c1o1; 
				else 
				begin
					offset_y <= 0;
					offset_x <= diameter;
					crit <= 1 - diameter;
					state <= c2o6;
				end
				
			end

			c2o6: state <= c2o7; 
			c2o7: begin

				offset_y <= offset_y + 1;
				
				if(crit <= 0) crit <= crit + (2 * offset_y) + 1; 
				else begin
					offset_x <= offset_x - 1;
					crit <= crit + 2 * (offset_y - offset_x) + 1;
				
				end

				if (offset_y <= offset_x) state <= c2o6; 
				else 
				begin
					offset_y <= 0;
					offset_x <= diameter;
					crit <= 1 - diameter;
					state <= c3o3;
				end
				
			end

			c3o3: state <= c3o4; 
			c3o4: begin

				offset_y <= offset_y + 1;
				
				if(crit <= 0) crit <= crit + (2 * offset_y) + 1; 
				else begin
					offset_x <= offset_x - 1;
					crit <= crit + 2 * (offset_y - offset_x) + 1;
				
				end

				if (offset_y <= offset_x) state <= c3o3; 
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

			c1o1: begin

				if((pleft_x + offset_x[8:0]) > 159 || (pleft_x + offset_x[8:0]) < 0 
					|| (pleft_y + offset_y[8:0]) > 119 || (pleft_y + offset_y[8:0]) < 0) begin
					vga_x = 0;
					vga_y = 0;
					vga_plot = 0;
				end
				else begin
					vga_x = (pleft_x + offset_x[8:0]);
					vga_y = (pleft_y + offset_y[8:0]);
					vga_plot = 1;
				end 
			end

			c1o2: begin

				if((pleft_x + offset_y[8:0]) > 159 || (pleft_x + offset_y[8:0]) < 0 
					|| (pleft_y + offset_x[8:0]) > 119 || (pleft_y + offset_x[8:0]) < 0) begin
					vga_x = 0;
					vga_y = 0;
					vga_plot = 0;
				end
				else begin
					vga_x = (pleft_x + offset_y[8:0]);
					vga_y = (pleft_y + offset_x[8:0]);
					vga_plot = 1;
				end 

			end

			c3o4: begin
				if((pright_x - offset_x[8:0]) > 159 || (pright_x - offset_x[8:0]) < 0 
					|| (pright_y + offset_y[8:0]) > 119 || (pright_y + offset_y[8:0]) < 0) begin
					vga_x = 0;
					vga_y = 0;
					vga_plot = 0;
				end
				else begin
					vga_x = (pright_x - offset_x[8:0]);
					vga_y = (pright_y + offset_y[8:0]);
					vga_plot = 1;
				end 
			end

			c3o3: begin
				if((pright_x - offset_y[8:0]) > 159 || (pright_x - offset_y[8:0]) < 0 
					|| (pright_y + offset_x[8:0]) > 119 || (pright_y + offset_x[8:0]) < 0) begin
					vga_x = 0;
					vga_y = 0;
					vga_plot = 0;
				end
				else begin
					vga_x = (pright_x - offset_y[8:0]);
					vga_y = (pright_y + offset_x[8:0]);
					vga_plot = 1;
				end 
			end


			c2o6: begin
				if((ptop_x - offset_y[8:0]) > 159 || (ptop_x - offset_y[8:0]) < 0 
					|| (ptop_y - offset_x[8:0]) > 119 || (ptop_y - offset_x[8:0]) < 0) begin
					vga_x = 0;
					vga_y = 0;
					vga_plot = 0;
				end
				else begin
					vga_x = (ptop_x - offset_y[8:0]);
					vga_y = (centre_y - offset_x[8:0]);
					vga_plot = 1;
				end 
			end


			c2o7: begin
				if((ptop_x + offset_y[8:0]) > 159 || (ptop_x + offset_y[8:0]) < 0 
					|| (ptop_y - offset_x[8:0]) > 119 || (ptop_y - offset_x[8:0]) < 0) begin
					vga_x = 0;
					vga_y = 0;
					vga_plot = 0;
				end
				else begin
					vga_x = (ptop_x + offset_y[8:0]);
					vga_y = (ptop_y - offset_x[8:0]);
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

