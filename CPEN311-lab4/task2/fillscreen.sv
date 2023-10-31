`timescale 1ns / 1ns
module fillscreen(input logic clk, input logic rst_n, input logic [2:0] colour,
                  input logic start, output logic done = 0,
                  output logic [7:0] vga_x, output logic [6:0] vga_y,
                  output logic [2:0] vga_colour, output logic vga_plot);
     
     enum reg [4:0] {state_rest, state_start, state_fillx, state_filly} state;

     always_ff @(posedge clk, negedge clk, negedge rst_n) 
     begin : ahh
          if ((rst_n == 0 || start == 1) && state == state_rest && done == 0)
          begin
               state = state_start;
          end

          casez(state) 
               state_rest: 
               begin
                    state <= state_rest;
               end
               state_start: 
               begin
                    vga_x <= 0;
                    vga_y <= 0;
                    state <= state_fillx;
               end
               state_fillx: 
               begin
                    if(vga_x == 159)
                    begin 
                         done = 1;
                         state <= state_rest;
                    end
                    else 
                         state <= state_filly;
                    vga_x <= vga_x + 1;
               end
               state_filly: 
               begin
                    if(vga_y == 119) 
                         state <= state_fillx;
                    else 
                         state <= state_filly;
                    vga_y <= vga_y + 1;
               end
               default: state <= state_rest;
	     endcase
     end

     always_comb  
     begin

          casez(state)
               state_rest: 
               begin
                    vga_colour = 0;
               end
               state_start: 
               begin
                    vga_colour = 0;
               end
               state_fillx: 
               begin
                    vga_colour = vga_x % 8;
               end
               state_filly: 
               begin
                    vga_colour = vga_x % 8;
               end
               default: 
               begin
                    vga_colour = 0;
               end
          endcase
     end


     
endmodule

