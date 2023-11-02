`timescale 1ns / 1ns

module task2(input logic CLOCK_50, input logic [3:0] KEY,
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
logic start, done, rst_n, vga_plot;
logic [2:0] vga_colour;
logic [7:0] vga_x;
logic [6:0] vga_y;

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

fillscreen dut (.clk(CLOCK_50), .rst_n, .colour(SW[2:0]), .start, .done, .vga_x, .vga_y, .vga_colour, .vga_plot);


always_ff @(posedge CLOCK_50, negedge KEY[3]) 
begin

	if(KEY[3] == 0) begin

		rst_n <= 0;
		start <= 1;
	end

	if(done) begin
		
		start <= 0;

	end

	else rst_n <= 1;
end




endmodule: task2

