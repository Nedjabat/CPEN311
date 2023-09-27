module statemachine(input slow_clock, input resetb,
                    input [3:0] dscore, input [3:0] pscore, input [3:0] pcard3,
                    output load_pcard1, output load_pcard2,output load_pcard3,
                    output load_dcard1, output load_dcard2, output load_dcard3,
                    output player_win_light, output dealer_win_light);

reg gameover;


enum reg [4:0] {S0, S1, S2, S3, S4A, S4B, S5, S6, S7, sleep} state;

reg a_load_pcard1, a_load_pcard2, a_load_pcard3, a_load_dcard1, a_load_dcard2, a_load_dcard3, a_player_win_light, a_dealer_win_light;
assign load_pcard1 = a_load_pcard1;
assign load_pcard2 = a_load_pcard2;
assign load_pcard3 = a_load_pcard3;
assign load_dcard1 = a_load_dcard1;
assign load_dcard2 = a_load_dcard2;
assign load_dcard3 = a_load_dcard3;
assign player_win_light = a_player_win_light;
assign dealer_win_light = a_dealer_win_light;



always_comb 
begin
    case(state)
        S0:  //P card 1
        begin 
            a_load_pcard1 = 1;
            a_load_pcard2 = 0;
            a_load_pcard3 = 0;
            a_load_dcard1 = 0;
            a_load_dcard2 = 0;
            a_load_dcard3 = 0;
            a_player_win_light = 0;
            a_dealer_win_light = 0;
		    gameover = 0;
        end
        S1: //D card 1
        begin
            a_load_pcard1 = 0;
            a_load_dcard1 = 1;
        end
        S2: //P card 2
        begin
            a_load_pcard2 = 1;
            a_load_dcard1 = 0;
        end
        S3: //D card 2
        begin
            a_load_pcard2 = 0;
            a_load_dcard2 = 1;
        end
        S4A: 
        begin
            a_load_dcard2 = 0;

            if ((pscore == 8) || (pscore == 9) || (dscore == 8) || (dscore == 9)) gameover = 1;

            else a_load_pcard3 = 1; // go to s5
            
        end
        S4B: 
        begin
            a_load_dcard2 = 0;

            if ((pscore == 8) || (pscore == 9) || (dscore == 8) || (dscore == 9)) gameover = 1;

            else a_load_pcard3 = 0; // go to s6
            
        end
        S5: 
        begin
	    if (dscore == 6 && (pcard3 == 6 || pcard3 == 7))
            	begin
                	a_load_pcard3 = 0;
                	a_load_dcard3 = 1;
            	end
            else if (dscore == 5 && (pcard3 > 3 || pcard3 < 8))
            	begin
                	a_load_pcard3 = 0;
                	a_load_dcard3 = 1;
         	end
            else if (dscore == 4 && (pcard3 > 1 || pcard3 < 8))
            begin
                a_load_pcard3 = 0;
                a_load_dcard3 = 1;
            end
            else if (dscore == 3 && pcard3 !== 8)
            begin
                a_load_pcard3 = 0;
                a_load_dcard3 = 1;
            end
            else if (dscore < 3)
            begin
                a_load_pcard3 = 0;
                a_load_dcard3 = 1;
            end 
	    else
            begin
                a_load_pcard3 = 0;
                a_load_dcard3 = 0;
            end 
        end
        S6:
        begin
            if (pscore < 8) //pscore between 6-7 = no pcard
            	begin
                	if (dscore < 6) //dscore between 0-5 = dcard 3
            		a_load_pcard3 = 0;        	
			a_load_dcard3 = 1; 
            	end
            else
            	begin
                	a_load_pcard3 = 0;
                	a_load_dcard3 = 0; 
            	end
        end
        S7:
            begin
                a_load_pcard3 = 0;
               	a_load_dcard3 = 0; 
                if(pscore > dscore)
                    a_player_win_light = 1;
                else if (dscore > pscore)
                    a_dealer_win_light = 1;
                else
                begin 
                    a_player_win_light = 1; 
                    a_dealer_win_light = 1;
                end
            end

	sleep: 
	begin
            a_load_pcard1 = 0;
            a_load_pcard2 = 0;
            a_load_pcard3 = 0;
            a_load_dcard1 = 0;
            a_load_dcard2 = 0;
            a_load_dcard3 = 0;
		gameover = 0;
	end

        default: 
                begin
                a_load_pcard1 = 0;
                a_load_pcard2 = 0;
                a_load_pcard3 = 0;
                a_load_dcard1 = 0;
                a_load_dcard2 = 0;
                a_load_dcard3 = 0;
                a_player_win_light = 0;
                a_dealer_win_light = 0;
                gameover = 0;
                a_player_win_light = 0; 
                end 

    endcase
end

always_ff @(negedge resetb, posedge slow_clock ) 
begin
	if(~resetb) begin
		state <= S0;
	end else begin
		case(state)
        	S0: state <= S1;
        	S1: state <= S2;
        	S2: state <= S3;
        	S3:
		begin
			if (pscore < 6) state <= S4A;
            		else state <= S4B;
		end
        	S4A:
		begin
			if (gameover == 1) state <= S7;
            		else state <= S5;
		end
        	S4B:
		begin
			if (gameover == 1) state <= S7;
            		else state <= S6;
		end
        	S5: state <= S7;
        	S6: state <= S7;
		sleep: state <= sleep;
        	default: state <= sleep;
    		endcase 

	end
end


// The code describing your state machine will go here.  Remember that
// a state machine consists of next state logic, output logic, and the 
// registers that hold the state.  You will want to review your notes from
// CPEN 211 or equivalent if you have forgotten how to write a state machine.

endmodule

