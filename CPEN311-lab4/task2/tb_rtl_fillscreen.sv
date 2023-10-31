`timescale 1ns / 1ns
module tb_rtl_fillscreen();

reg clk;
reg rst_n;
reg [2:0] colour;
reg start;

wire done;
wire [7:0] vga_x;
wire [6:0] vga_y;
wire [2:0] vga_colour;
wire vga_plot;

fillscreen DUT(	.clk, .rst_n, .colour, .start,.done,.vga_x,.vga_y,.vga_colour, .vga_plot);

initial 
begin
clk = 0;
rst_n = 1;
start = 0;
#5;
rst_n = 0;
start = 1;
#5;
end

initial forever #10 clk = ~clk;

endmodule: tb_rtl_fillscreen
