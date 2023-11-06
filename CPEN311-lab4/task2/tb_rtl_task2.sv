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
reg [6:0] counter;



                        
task2 DUT (.CLOCK_50, .KEY,
             .SW, .LEDR, .HEX0, .HEX1, .HEX2,
             .HEX3, .HEX4, .HEX5, .VGA_R, .VGA_G, .VGA_B,
             .VGA_HS, .VGA_VS, .VGA_CLK, .VGA_X, .VGA_Y,
             .VGA_COLOUR, .VGA_PLOT);



initial 
begin

CLOCK_50 = 0;
counter = 0;
#5;
KEY[3] = 1;
#20000;
KEY[3] = 0;
#20000;
KEY[3] = 1;

#35;

	if(VGA_PLOT == 1)begin
		counter = counter + 1'b1;
		$display ("PASSED plot on test");
	end else begin
		$error ("FAILED plot on test");
	end

	if(VGA_X == 0)begin
		counter = counter + 1'b1;
		$display ("PASSED x test");
	end else begin
		$error ("FAILED x test");
	end

	if(VGA_Y == 1)begin
		counter = counter + 1'b1;
		$display ("PASSED y test");
	end else begin
		$error ("FAILED y test");
	end

#35;

	if(VGA_PLOT == 1)begin
		counter = counter + 1'b1;
		$display ("PASSED plot on test");
	end else begin
		$error ("FAILED plot on test");
	end

	if(VGA_X == 0)begin
		counter = counter + 1'b1;
		$display ("PASSED x test");
	end else begin
		$error ("FAILED x test");
	end

	if(VGA_Y == 1)begin
		counter = counter + 1'b1;
		$display ("PASSED y test");
	end else begin
		$error ("FAILED y test");
	end

#192020;


	if(VGA_PLOT == 0)begin
		counter = counter + 1'b1;
		$display ("PASSED done test");
	end else begin
		$error ("FAILED done test");
	end


	$display("%d tests passed out of %d tests.", counter, 6'd7);


end

initial forever #10000 CLOCK_50 = ~CLOCK_50;


endmodule: tb_rtl_task2
