module statemachine(input slow_clock, input resetb,
                    input [3:0] dscore, input [3:0] pscore, input [3:0] pcard3,
                    output logic load_pcard1, output logic load_pcard2,output logic load_pcard3,
                    output logic load_dcard1, output logic load_dcard2, output logic load_dcard3,
                    output logic player_win_light, output logic dealer_win_light);

reg gameover;


enum reg [4:0] {S0, S1, S2, S3, S4A, S4B, S5, S6, S7, sleep} state, next_state;


always_comb
begin
    case(state)
        	S0: next_state <= S1;
        	S1: next_state <= S2;
        	S2: next_state <= S3;
        	S3:
            begin
			    if (pscore < 6) next_state <= S4A;
            		else next_state <= S4B;
		     end
        	S4A:
            begin
                if (gameover == 1) next_state <= S7;
                else next_state <= S5;
            end
        	S4B:
            begin
                if (gameover == 1) next_state <= S7;
                    else next_state <= S6;
            end
            S5: next_state <= S7;
            S6: next_state <= S7;
            S7: next_state <= S7;
            sleep: next_state <= sleep;
            default: next_state <= sleep;
    		endcase 
end

always_comb 
begin : output_logic
    load_pcard1 = 0;
    load_pcard2 = 0;
    load_pcard3 = 0;
    load_dcard1 = 0;
    load_dcard2 = 0;
    load_dcard3 = 0;
    player_win_light = 0;
    dealer_win_light = 0;
    gameover = 0;
    case(state)
        S0:  //P card 1
        begin 
            load_pcard1 = 1;
            load_pcard2 = 0;
            load_pcard3 = 0;
            load_dcard1 = 0;
            load_dcard2 = 0;
            load_dcard3 = 0;
            player_win_light = 0;
            dealer_win_light = 0;
		    gameover = 0;
        end
        S1: //D card 1
        begin
            load_pcard1 = 0;
            load_dcard1 = 1;
        end
        S2: //P card 2
        begin
            load_pcard2 = 1;
            load_dcard1 = 0;
        end
        S3: //D card 2
        begin
            load_pcard2 = 0;
            load_dcard2 = 1;
        end
        S4A: 
        begin
            load_dcard2 = 0;

            if ((pscore == 8) || (pscore == 9) || (dscore == 8) || (dscore == 9)) gameover = 1;

            else load_pcard3 = 1; // go to s5 
        end
        S4B: 
        begin
            load_dcard2 = 0;

            if ((pscore == 8) || (pscore == 9) || (dscore == 8) || (dscore == 9)) gameover = 1;

            else load_pcard3 = 0; // go to s6
            
        end
        S5: 
        begin
	    if (dscore == 6 && (pcard3 == 6 || pcard3 == 7))
            	begin
                	load_pcard3 = 0;
                    load_dcard3 = 1;
            	end
            else if (dscore == 5 && (pcard3 > 3 || pcard3 < 8))
            	begin
                    load_pcard3 = 0;
                	load_dcard3 = 1;
         	end
            else if (dscore == 4 && (pcard3 > 1 || pcard3 < 8))
            begin
                load_pcard3 = 0;
                load_dcard3 = 1;
            end
            else if (dscore == 3 && pcard3 !== 8)
            begin
                load_pcard3 = 0;
                load_dcard3 = 1;
            end
            else if (dscore < 3)
            begin
                load_pcard3 = 0;
                load_dcard3 = 1;
            end 
	    else
            begin
                load_pcard3 = 0;
                load_dcard3 = 0;
            end 
        end
        S6:
        begin
            if (pscore < 8) //pscore between 6-7 = no pcard
            	begin
                	if (dscore < 6) //dscore between 0-5 = dcard 3
            		load_pcard3 = 0;        	
			    load_dcard3 = 1; 
            	end
            else
            	begin
                	load_pcard3 = 0;
                	load_dcard3 = 0; 
            	end
        end
        S7:
            begin
                load_pcard3 = 0;
               	load_dcard3 = 0; 
                if(pscore > dscore)
                    player_win_light = 1;
                else if (dscore > pscore)
                    dealer_win_light = 1;
                else
                begin 
                    player_win_light = 1; 
                    dealer_win_light = 1;
                end
            end

	sleep: 
	    begin
            load_pcard1 = 0;
            load_pcard2 = 0;
            load_pcard3 = 0;
            load_dcard1 = 0;
            load_dcard2 = 0;
            load_dcard3 = 0;
		    gameover = 0;
	    end

        default: 
                begin
                load_pcard1 = 0;
                load_pcard2 = 0;
                load_pcard3 = 0;
                load_dcard1 = 0;
                load_dcard2 = 0;
                load_dcard3 = 0;
                player_win_light = 0;
                dealer_win_light = 0;
                gameover = 0;
                end 

    endcase
end

always_ff @(negedge resetb, posedge slow_clock ) 
begin
	if(~resetb) begin
		state <= S0;
	end else begin
        state <= next_state;
	end
end


// The code describing your state machine will go here.  Remember that
// a state machine consists of next state logic, output logic, and the 
// registers that hold the state.  You will want to review your notes from
// CPEN 211 or equivalent if you have forgotten how to write a state machine.

endmodule

