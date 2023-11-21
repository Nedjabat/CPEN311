`timescale 1ps / 1ps
module tb_syn_task3();

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


reg [6:0] counter;


//de1_gui gui(.SW, .KEY, .LEDR, .HEX5, .HEX4, .HEX3, .HEX2, .HEX1, .HEX0);

task3 DUT (.CLOCK_50, .KEY,
             .SW, .LEDR, .HEX0, .HEX1, .HEX2,
             .HEX3, .HEX4, .HEX5, .VGA_R, .VGA_G, .VGA_B,
             .VGA_HS, .VGA_VS, .VGA_CLK, .VGA_X, .VGA_Y,
             .VGA_COLOUR, .VGA_PLOT);



initial 
begin

CLOCK_50 = 0;
counter = 0;
#20000;
KEY[3] = 1;
#20000;
KEY[3] = 0;
#20000;
KEY[3] = 1;

#60000;


	if(VGA_PLOT == 1)begin
		counter = counter + 1'b1;
		$display ("PASSED plot on test");
	end else begin
		$error ("FAILED plot on test");
	end

	if(VGA_X == 0)begin
		counter = counter + 1'b1;
		$display ("PASSED blackscreen x test");
	end else begin
		$error ("FAILED blackscreen x test");
	end

	if(VGA_Y == 0)begin
		counter = counter + 1'b1;
		$display ("PASSED blackscreen y test");
	end else begin
		$error ("FAILED blackscreen y test");
	end

	if(VGA_COLOUR == 3'b000)begin
		counter = counter + 1'b1;
		$display ("PASSED blackscreen colour test");
	end else begin
		$error ("FAILED blackscreen colour test");
	end

#384000000;
#500000;

	if(VGA_PLOT == 1)begin
		counter = counter + 1'b1;
		$display ("PASSED plot on test");
	end else begin
		$error ("FAILED plot on test");
	end

	if(VGA_X == 8'b01001110)begin
		counter = counter + 1'b1;
		$display ("PASSED circle x test");
	end else begin
		$error ("FAILED circle x test");
	end

	if(VGA_Y == 7'b0010100)begin
		counter = counter + 1'b1;
		$display ("PASSED circle y test");
	end else begin
		$error ("FAILED circle y test");
	end

	if(VGA_COLOUR == 3'b010)begin
		counter = counter + 1'b1;
		$display ("PASSED circle colour test");
	end else begin
		$error ("FAILED circle colour test");
	end

#38400000;


	if(VGA_PLOT == 0)begin
		counter = counter + 1'b1;
		$display ("PASSED done test");
	end else begin
		$error ("FAILED done test");
	end


	$display("%d tests passed out of %d tests.", counter, 6'd9);


end

initial forever #10000 CLOCK_50 = ~CLOCK_50;

endmodule: tb_syn_task3
