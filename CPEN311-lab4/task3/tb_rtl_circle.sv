`timescale 1ns / 1ns
module tb_rtl_circle();

reg clk;
reg rst_n;
reg [2:0] colour;
reg start;
reg [7:0] centre_x, radius;
reg [6:0] centre_y;


wire done;
wire [7:0] vga_x;
wire [6:0] vga_y;
wire [2:0] vga_colour;
wire vga_plot;

circle DUT(.clk, .rst_n, .colour, .centre_x, .centre_y, .radius, .start, .done, .vga_x, .vga_y, .vga_colour, .vga_plot);

initial 
begin

clk = 0;
rst_n = 1;
start = 0;
centre_x = 80;
centre_y = 60;
radius = 4;
#5;

rst_n = 0;
start = 1;
#10;

rst_n = 1;

end

initial forever #5 clk = ~clk;


endmodule: tb_rtl_circle
