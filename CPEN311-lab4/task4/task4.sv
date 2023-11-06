`timescale 1ps / 1ps
module task4(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);


logic [9:0] VGA_R_10;
logic [9:0] VGA_G_10;
logic [9:0] VGA_B_10;
logic VGA_BLANK, VGA_SYNC;
logic rst_n;

logic startb, startc;

logic [7:0] vga_x;
logic [6:0] vga_y;
logic vga_plot;
logic [2:0] vga_colour;

logic [7:0] vga_xb;
logic [6:0] vga_yb;
logic vga_plotb;
logic [2:0] vga_colourb;

logic [7:0] vga_xc;
logic [6:0] vga_yc;
logic vga_plotc;
logic [2:0] vga_colourc;

logic blackscreen_done, circle_done;

assign vga_x = (blackscreen_done)? vga_xc : vga_xb;
assign vga_y = (blackscreen_done)? vga_yc : vga_yb;
assign vga_plot = (blackscreen_done)? vga_plotc : vga_plotb;
assign vga_colour = (blackscreen_done)? vga_colourc : vga_colourb;

assign VGA_X = vga_x;
assign VGA_Y = vga_y;
assign VGA_PLOT = vga_plot; 
assign VGA_COLOUR = vga_colour;

assign VGA_R = VGA_R_10[9:2];
assign VGA_G = VGA_G_10[9:2];
assign VGA_B = VGA_B_10[9:2];

vga_adapter#(.RESOLUTION("160x120")) vga_u0(.resetn(KEY[3]), .clock(CLOCK_50), .colour(vga_colour),
                                            .x(vga_x), .y(vga_y), .plot(vga_plot),
                                            .VGA_R(VGA_R_10), .VGA_G(VGA_G_10), .VGA_B(VGA_B_10), 
						.VGA_HS, .VGA_VS, .VGA_BLANK, .VGA_SYNC, .VGA_CLK);

reuleaux c (.clk(CLOCK_50), .rst_n, .colour(3'b010), .centre_x(8'd80), .centre_y(7'd60), .diameter(8'd80), .start(startc), .done(circle_done), .vga_x(vga_xc), .vga_y(vga_yc), .vga_colour(vga_colourc), .vga_plot(vga_plotc));
blackscreen b (.clk(CLOCK_50), .rst_n, .start(startb), .done(blackscreen_done), .vga_x(vga_xb), .vga_y(vga_yb), .vga_colour(vga_colourb), .vga_plot(vga_plotb));

enum reg [2:0] {state_b, state_c, state_rest, state_done} state;

//this should go to blackscreen on rest, and then go to circle when blackscreen is done, then rest forever
always_ff @(posedge CLOCK_50, negedge KEY[3]) 
begin

	if(KEY[3] == 0) begin

		rst_n <= 0;
		startb <= 1;
		state <= state_b;
	end

	else begin

		case(state)
			state_b: begin
				rst_n <= 1;
				if (blackscreen_done) begin
					startb <= 0;
					startc <= 1;
					state <= state_c;
				end
				else state <= state_b;
			end
			
			state_c: begin
				if (circle_done) begin
					startc <= 0;
					state <= state_done;
				end
				else state <= state_c;
			end

			state_rest: state <= state_rest;
			state_done: state <= state_done;
			default: state <= state_rest;

		endcase

	end
end

endmodule: task4
