`timescale 1ps / 1ps

module fillscreen(input logic clk, input logic rst_n, input logic [2:0] colour,
                  input logic start, output logic done,
                  output logic [7:0] vga_x, output logic [6:0] vga_y,
                  output logic [2:0] vga_colour, output logic vga_plot);
     
     enum reg [4:0] {state_rest, state_start, state_fillx, state_filly} state;

     always_ff @(posedge clk, negedge rst_n) 
     begin

          if (rst_n == 0)
          begin
               state <= state_rest;
		done <= 0;
          end

          else if (start == 1 && state == state_rest)
          begin
               state <= state_start;
          end
	
	else begin
          casez(state) 

               state_rest: 
               begin
                    state <= state_rest;
		    done <= 0;
               end

               state_start: 
               begin
                    vga_x <= 0;
                    vga_y <= 0;
                    state <= state_fillx;
               end

               state_fillx: 
               begin
                    if(vga_x == 160)
                    begin 
                         done <= 1;
                         vga_x <= 0;
                         state <= state_rest;
                    end

                    else begin
                    	vga_y <= vga_y + 1;
                        state <= state_filly;
		    end
               end

               state_filly: 
               begin
                    if(vga_y == 119) begin
                    	vga_x <= vga_x + 1;
                    	vga_y <= 0;
                        state <= state_fillx;
			end
                    else begin
                    	vga_y <= vga_y + 1;
                        state <= state_filly;
		    end
               end

               default: state <= state_rest;
	     endcase
	end
     end

     always_comb  
     begin

          casez(state)

               state_rest: 
               begin
                    vga_plot = 0;
                    vga_colour = 0;
               end

               state_start: 
               begin
                    vga_plot = 0;
                    vga_colour = 0;
               end

               state_fillx: 
               begin
                    vga_plot = 1;
                    vga_colour = vga_x % 8;
               end

               state_filly: 
               begin
                    vga_plot = 1;
                    vga_colour = vga_x % 8;
               end

               default: 
               begin
                    vga_plot = 0;
                    vga_colour = 0;
               end
          endcase
     end


     
endmodule


