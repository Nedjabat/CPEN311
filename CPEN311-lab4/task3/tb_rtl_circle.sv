`timescale 1ns / 1ns
module tb_rtl_circle();

reg clk;
reg rst_n;
reg [2:0] colour;
reg start;
reg [7:0] centre_x, radius;
reg [6:0] centre_y;

reg [6:0] counter;


wire done;
wire [7:0] vga_x;
wire [6:0] vga_y;
wire [2:0] vga_colour;
wire vga_plot;

circle DUT(.clk, .rst_n, .colour, .centre_x, .centre_y, .radius, .start, .done, .vga_x, .vga_y, .vga_colour, .vga_plot);

initial 
begin

counter = 0;
clk = 0;
rst_n = 1;
start = 0;
centre_x = 80;
centre_y = 60;
radius = 40;
#5;

rst_n = 0;
start = 1;
#10;

rst_n = 1;

#15;

	if(vga_x == 120)begin
		counter = counter + 1'b1;
		$display ("PASSED x1 test");
	end else begin
		$error ("FAILED x1 test");
	end

	if(vga_y == 60)begin
		counter = counter + 1'b1;
		$display ("PASSED y1 test");
	end else begin
		$error ("FAILED y1 test");
	end

	if(vga_plot == 1)begin
		counter = counter + 1'b1;
		$display ("PASSED plot1 test");
	end else begin
		$error ("FAILED plot1 test");
	end

#40;

	if(vga_x == 40)begin
		counter = counter + 1'b1;
		$display ("PASSED x2 test");
	end else begin
		$error ("FAILED x2 test");
	end

	if(vga_y == 60)begin
		counter = counter + 1'b1;
		$display ("PASSED y2 test");
	end else begin
		$error ("FAILED y2 test");
	end

	if(vga_plot == 1)begin
		counter = counter + 1'b1;
		$display ("PASSED plot2 test");
	end else begin
		$error ("FAILED plot2 test");
	end



#7445;

	if(done == 1)begin
		counter = counter + 1'b1;
		$display ("PASSED done test");
	end else begin
		$error ("FAILED done test");
	end

    
	$display("%d tests passed out of %d tests.", counter, 6'd7);

end

initial forever #5 clk = ~clk;


endmodule: tb_rtl_circle
