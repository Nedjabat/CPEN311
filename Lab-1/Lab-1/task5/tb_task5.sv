module tb_task5();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 100,000 ticks (equivalent to "initial #100000 $finish();").

reg fast_clock, slow_clock, resetb;

reg [3:0] key; 
reg [6:0] counter;


wire [9:0] sledr;
wire [6:0] hex1, hex0, hex2, hex3, hex4, hex5;

task5 DUT (

	.CLOCK_50(fast_clock),
	.KEY(key),
	.LEDR(sledr),
	.HEX0(hex0),
	.HEX1(hex1),
	.HEX2(hex2),
	.HEX3(hex3),
	.HEX4(hex4),
	.HEX5(hex5)
);



initial begin 

	key = 0;
	counter = 0;
	fast_clock = 0;
	key[0] = 0;

	key[3] = 1;
	#5;
	key[3] = 0;
	#5;
	key[3] = 1;

	#100;

	if(sledr == 10'b1000110001)begin
		counter = counter + 1'b1;
		$display ("PASSED led test");
	end else begin
		$error ("FAILED led test");
	end

	#20;

	#5;
	key[3] = 0;
	#5;
	key[3] = 1;

	if(sledr == 10'b0000000000)begin
		counter = counter + 1'b1;
		$display ("PASSED reset test");
	end else begin
		$error ("FAILED reset test");
	end

	if(hex0 == 7'b1111111)begin
		counter = counter + 1'b1;
		$display ("PASSED reset test");
	end else begin
		$error ("FAILED reset test");
	end

	#100;

	if(sledr == 10'b0100001001)begin
		counter = counter + 1'b1;
		$display ("PASSED led test");
	end else begin
		$error ("FAILED led test");
	end

	#20;

	#5;
	key[3] = 0;
	#5;
	key[3] = 1;
	#100;

	#20;

	#5;
	key[3] = 0;
	#5;
	key[3] = 1;
	#100;

	$display("%d tests passed out of %d tests.", counter, 6'd4);

end

initial forever #7 key[0] = ~(key[0]);
initial forever #1 fast_clock = ~fast_clock;

						
endmodule

