`timescale 1ps / 1ps

module tb_rtl_task2();
logic CLOCK_50;
logic [3:0] KEY;
logic [9:0] SW;

logic [9:0] LEDR;
logic [6:0] HEX0; 
logic [6:0] HEX1;
logic [6:0] HEX2;
logic [6:0] HEX3; 
logic [6:0] HEX4;
logic [6:0] HEX5;
logic [7:0] VGA_R;
logic [7:0] VGA_G;
logic [7:0] VGA_B;
logic VGA_HS;
logic VGA_VS;
logic VGA_CLK;
logic [7:0] VGA_X;
logic [6:0] VGA_Y;
logic [2:0] VGA_COLOUR;
logic VGA_PLOT;

logic [9:0] VGA_R_10;
logic [9:0] VGA_G_10;
logic [9:0] VGA_B_10;
logic VGA_BLANK, VGA_SYNC;

assign VGA_R = VGA_R_10[9:2];
assign VGA_G = VGA_G_10[9:2];
assign VGA_B = VGA_B_10[9:2];

vga_adapter#(.RESOLUTION("160x120")) vga_u0(.resetn(KEY[3]), .clock(CLOCK_50), .colour(VGA_COLOUR),
                                            .x(VGA_X), .y(VGA_Y), .plot(VGA_PLOT),
                                            .VGA_R(VGA_R_10), .VGA_G(VGA_G_10), .VGA_B(VGA_B_10), 
						.VGA_HS, .VGA_VS, .VGA_BLANK, .VGA_SYNC, .VGA_CLK);
                        
task2 DUT (.CLOCK_50, .KEY,
             .SW, .LEDR, .HEX0, .HEX1, .HEX2,
             .HEX3, .HEX4, .HEX5, .VGA_R, .VGA_G, .VGA_B,
             .VGA_HS, .VGA_VS, .VGA_CLK, .VGA_X, .VGA_Y,
             .VGA_COLOUR, .VGA_PLOT);



initial 
begin

CLOCK_50 = 0;
#5;
KEY[3] = 1;
#20000;
KEY[3] = 0;
#20000;
KEY[3] = 1;



end

initial forever #10000 CLOCK_50 = ~CLOCK_50;





endmodule: tb_rtl_task2
