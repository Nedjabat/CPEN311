`timescale 1ps / 1ps
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

reg [6:0] counter;

fillscreen DUT(	.clk, .rst_n, .colour, .start,.done,.vga_x,.vga_y,.vga_colour, .vga_plot);

initial 
begin

clk = 0;
counter = 0;
rst_n = 1;
start = 0;
#5;
rst_n = 0;
start = 1;
#10;
rst_n = 1;

#25;

	if(vga_plot == 1)begin
		counter = counter + 1'b1;
		$display ("PASSED plot on test");
	end else begin
		$error ("FAILED plot on test");
	end

	if(vga_x == 0)begin
		counter = counter + 1'b1;
		$display ("PASSED x test");
	end else begin
		$error ("FAILED x test");
	end

	if(vga_y == 1)begin
		counter = counter + 1'b1;
		$display ("PASSED y test");
	end else begin
		$error ("FAILED y test");
	end

#192020;


	if(done == 1)begin
		counter = counter + 1'b1;
		$display ("PASSED done test");
	end else begin
		$error ("FAILED done test");
	end


	$display("%d tests passed out of %d tests.", counter, 6'd4);


end

initial forever #5 clk = ~clk;

endmodule: tb_rtl_fillscreen

