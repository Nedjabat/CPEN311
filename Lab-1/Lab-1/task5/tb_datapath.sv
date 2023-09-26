module tb_datapath();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();")

reg slow_clock, fast_clock, resetb;
reg load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3;
reg [6:0] counter;

wire [6:0] HEX1, HEX0, HEX2, HEX3, HEX4, HEX5;
wire [3:0] dscore, pscore, pcard3;

datapath DUT(.slow_clock(slow_clock),
            .fast_clock(fast_clock),
            .resetb(resetb),
            .load_pcard1(load_pcard1),
            .load_pcard2(load_pcard2),
            .load_pcard3(load_pcard3),
            .load_dcard1(load_dcard1),
            .load_dcard2(load_dcard2),
            .load_dcard3(load_dcard3),
            .dscore_out(dscore),
            .pscore_out(pscore),
            .pcard3_out(pcard3),
            .HEX5(HEX5),
            .HEX4(HEX4),
            .HEX3(HEX3),
            .HEX2(HEX2),
            .HEX1(HEX1),
            .HEX0(HEX0));


initial begin

counter = 0;
resetb = 1;
load_pcard1 = 0;
load_pcard2 = 0;
load_pcard3 = 0;
load_dcard1 = 0;
load_dcard2 = 0;
load_dcard3 = 0;
slow_clock = 0;
fast_clock = 0;


#5; 
resetb = 0;

#5; 
resetb = 1;


#10;
load_pcard1 = 1;

#10;

	if(HEX0 == 7'b0000000)begin
		counter = counter + 1'b1;
		$display ("PASSED pcard1 test");
	end else begin
		$error ("FAILED pcard1 test");
	end

	if(pscore == 8)begin
		counter = counter + 1'b1;
		$display ("PASSED pcard1 test");
	end else begin
		$error ("FAILED pcard1 test");
	end


load_pcard1 = 0;
load_dcard1 = 1;

#10;

	if(HEX3 == 7'b0001001)begin
		counter = counter + 1'b1;
		$display ("PASSED dcard1 test");
	end else begin
		$error ("FAILED dcard1 test");
	end

	if(dscore == 0)begin
		counter = counter + 1'b1;
		$display ("PASSED dcard1 test");
	end else begin
		$error ("FAILED dcard1 test");
	end

load_pcard2 = 1;
load_dcard1 = 0;

#10;

load_pcard2 = 0;
load_dcard2 = 1;

#10;

load_pcard3 = 1;
load_dcard2 = 0;

#10;

	if(pscore == 5)begin
		counter = counter + 1'b1;
		$display ("PASSED last pcard test");
	end else begin
		$error ("FAILED last pcard test");
	end


	if(pcard3 == 2)begin
		counter = counter + 1'b1;
		$display ("PASSED pcard3 test");
	end else begin
		$error ("FAILED pcard3 test");
	end

load_pcard3 = 0;
load_dcard3 = 1;

#10;

	if(HEX5 == 7'b1111000)begin
		counter = counter + 1'b1;
		$display ("PASSED last dcard test");
	end else begin
		$error ("FAILED last dcard test");
	end

	if(dscore == 7)begin
		counter = counter + 1'b1;
		$display ("PASSED last dcard test");
	end else begin
		$error ("FAILED last dcard test");
	end

load_dcard3 = 0;

#5; 
resetb = 0;

#5; 
resetb = 1;


	if(HEX1 == 7'b1111111)begin
		counter = counter + 1'b1;
		$display ("PASSED reset test");
	end else begin
		$error ("FAILED reset test");
	end


#5;
load_pcard1 = 1;

#10;

load_pcard1 = 0;
load_dcard1 = 1;

#10;

load_pcard2 = 1;
load_dcard1 = 0;

#10;

load_pcard2 = 0;
load_dcard2 = 1;

#10;

load_pcard3 = 1;
load_dcard2 = 0;

#10;
	if(pscore == 3)begin
		counter = counter + 1'b1;
		$display ("PASSED last pcard test");
	end else begin
		$error ("FAILED last pcard test");
	end


	if(pcard3 == 10)begin
		counter = counter + 1'b1;
		$display ("PASSED pcard3 test");
	end else begin
		$error ("FAILED pcard3 test");
	end

load_pcard3 = 0;
load_dcard3 = 1;

#10;

load_dcard3 = 0;

	$display("%d tests passed out of %d tests.", counter, 6'd11);

end

initial forever #5 slow_clock = ~slow_clock;
initial forever #1 fast_clock = ~fast_clock;
						
endmodule

