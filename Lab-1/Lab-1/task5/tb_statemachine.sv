module tb_statemachine();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").

reg slow_clock, resetb;
reg [3:0] dscore, pscore, pcard3;

wire sim_load_pcard1, sim_load_pcard2, sim_load_pcard3, sim_load_dcard1, sim_load_dcard2, sim_load_dcard3, sim_player_win_light, sim_dealer_win_light;

statemachine DUT(.slow_clock(slow_clock),
                .resetb(resetb),
                .dscore(dscore),
                .pscore(pscore),
                .pcard3(pcard3),
                .load_pcard1(sim_load_pcard1),
                .load_pcard2(sim_load_pcard2),
                .load_pcard3(sim_load_pcard3),						  
                .load_dcard1(sim_load_dcard1),
                .load_dcard2(sim_load_dcard2),
                .load_dcard3(sim_load_dcard3),	
                .player_win_light(sim_player_win_light), 
                .dealer_win_light(sim_dealer_win_light));


reg [9:0] counter = 0;

initial begin
	
	resetb = 1;
	slow_clock = 0;
	dscore = 0;
	pscore = 0;
	pcard3 = 0;
	#5;
	resetb = 0;

	#5;

	if(sim_load_pcard1)begin
		counter = counter + 1'b1;
		$display ("PASSED reset test");
	end else begin
		$error ("FAILED reset test");
	end

	resetb = 1;
	#5;
	pscore = 4;


	slow_clock = 1;
	#5;

	if(sim_load_dcard1)begin
		counter = counter + 1'b1;
		$display ("PASSED phase 2 test");
	end else begin
		$error ("FAILED phase 2 test");
	end

	slow_clock = 0;
	#5;

	dscore = 5;


	slow_clock = 1;
	#5;

	if(sim_load_pcard2)begin
		counter = counter + 1'b1;
		$display ("PASSED phase 3 test");
	end else begin
		$error ("FAILED phase 3 test");
	end

	slow_clock = 0;
	#5;
	pscore = 0;


	slow_clock = 1;
	#5;

	if(sim_load_dcard2)begin
		counter = counter + 1'b1;
		$display ("PASSED phase 4 test");
	end else begin
		$error ("FAILED phase 4 test");
	end

	slow_clock = 0;
	#5;
	dscore = 6;


	slow_clock = 1;
	#5;

	if(sim_load_pcard3)begin
		counter = counter + 1'b1;
		$display ("PASSED phase 5 test");
	end else begin
		$error ("FAILED phase 5 test");
	end

	slow_clock = 0;
	#5;

	pscore = 7;
	pcard3 = 7;

	slow_clock = 1;
	#5;

	if(sim_load_dcard3)begin
		counter = counter + 1'b1;
		$display ("PASSED phase 6 test");
	end else begin
		$error ("FAILED phase 6 test");
	end

	slow_clock = 0;
	#5;

	dscore = 1;

	slow_clock = 1;
	#5;

	if(sim_player_win_light == 1 && sim_dealer_win_light == 0)begin
		counter = counter + 1'b1;
		$display ("PASSED player win test");
	end else begin
		$error ("FAILED player win test");
	end

	slow_clock = 0;
	#5;

	slow_clock = 1;
	#5;
	slow_clock = 0;
	#5;

	slow_clock = 1;
	#5;
	slow_clock = 0;
	#5;

	#5;
	resetb = 0;

	#5;

	if(sim_load_pcard1)begin
		counter = counter + 1'b1;
		$display ("PASSED reset test");
	end else begin
		$error ("FAILED reset test");
	end

	resetb = 1;
	#5;
	pscore = 4;


	slow_clock = 1;
	#5;
	slow_clock = 0;
	#5;

	dscore = 5;


	slow_clock = 1;
	#5;
	slow_clock = 0;
	#5;
	pscore = 8;


	slow_clock = 1;
	#5;
	slow_clock = 0;
	#5;
	dscore = 6;

	slow_clock = 1;
	#5;
	slow_clock = 0;
	#5;

	pscore = 7;
	pcard3 = 7;

	slow_clock = 1;
	#5;
	slow_clock = 0;
	#5;

	if(sim_player_win_light == 1 && sim_dealer_win_light == 0)begin
		counter = counter + 1'b1;
		$display ("PASSED autowin test");
	end else begin
		$error ("FAILED autowin test");
	end

	slow_clock = 1;
	#5;
	slow_clock = 0;
	#5;


	#5;
	resetb = 0;

	#5;
	resetb = 1;
	#5;
	pscore = 4;


	slow_clock = 1;
	#5;
	slow_clock = 0;
	#5;

	dscore = 5;


	slow_clock = 1;
	#5;
	slow_clock = 0;
	#5;
	pscore = 2;


	slow_clock = 1;
	#5;

	slow_clock = 0;
	#5;
	dscore = 9;

	slow_clock = 1;
	#5;

	if(!sim_load_pcard3)begin
		counter = counter + 1'b1;
		$display ("PASSED third card test");
	end else begin
		$error ("FAILED third card test");
	end

	slow_clock = 0;
	#5;

	slow_clock = 1;
	#5;

	if(sim_player_win_light == 0 && sim_dealer_win_light == 1)begin
		counter = counter + 1'b1;
		$display ("PASSED dealer autowin test");
	end else begin
		$error ("FAILED dealer autowin test");
	end

	slow_clock = 0;
	#5;

	#5;
	resetb = 0;

	#5;
	resetb = 1;
	#5;
	pscore = 4;


	slow_clock = 1;
	#5;
	slow_clock = 0;
	#5;

	dscore = 5;


	slow_clock = 1;
	#5;
	slow_clock = 0;
	#5;
	pscore = 7;


	slow_clock = 1;
	#5;
	slow_clock = 0;
	#5;
	dscore = 3;

	slow_clock = 1;
	#5;

	if(!sim_load_pcard3)begin
		counter = counter + 1'b1;
		$display ("PASSED no third card test");
	end else begin
		$error ("FAILED no third card test");
	end

	slow_clock = 0;
	#5;

	pscore = 7;

	slow_clock = 1;
	#5;

	if(sim_load_dcard3)begin
		counter = counter + 1'b1;
		$display ("PASSED third card test");
	end else begin
		$error ("FAILED third card test");
	end

	slow_clock = 0;
	#5;

	dscore = 7;

	slow_clock = 1;
	#5;
	slow_clock = 0;
	#5;
	
	if(sim_player_win_light == 1 && sim_dealer_win_light == 1)begin
		counter = counter + 1'b1;
		$display ("PASSED draw test");
	end else begin
		$error ("FAILED draw test");
	end

	$display("%d tests passed out of %d tests.", counter, 6'd14);

end

						
endmodule

