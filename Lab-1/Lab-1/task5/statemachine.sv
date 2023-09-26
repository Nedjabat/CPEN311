module statemachine(input slow_clock, input resetb,
                    input [3:0] dscore, input [3:0] pscore, input [3:0] pcard3,
                    output logic load_pcard1, output logic load_pcard2,output logic load_pcard3,
                    output logic load_dcard1, output logic load_dcard2, output logic load_dcard3,
                    output logic player_win_light, output logic dealer_win_light);

int state, S0, S1, S2, S3, S4, S5, S6, S7, SStart, gameover, next_state;

always_comb 
begin : next_state_logic
    case (state)
        S0: next_state = S1;
        S1: next_state = S2;
        S2: next_state = S3;
        S3: next_state = S4;
        S4: if (gameover == 1)
                next_state = S7;
            else
            begin 
            if (pcard3 !== 4'bxxxx)
                next_state = S5;
            else
                next_state = S6;                    
            end
        S5: next_state = S7;
        S6: next_state = S7;
        default: next_state = S0;
    endcase 
end

always_comb 
begin : changes_within_State
    case (state)
        /*SStart: //Start
            load_pcard1 = 0;
            load_pcard2 = 0;
            load_pcard3 = 0;
            load_dcard1 = 0;
            load_dcard2 = 0;
            load_dcard3 = 0;
            player_win_light = 0;
            dealer_win_light = 0;
            */
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
        S4: 
        begin
            if ((pscore == 8) || (pscore == 9) || (dscore == 8) || (dscore == 9)) //Check for natural
            begin
                if(pscore > dscore)
                    player_win_light = 1;
                else if (dscore > pscore)
                    dealer_win_light = 1;
                else
                begin 
                    player_win_light = 1; 
                    dealer_win_light = 1;
                end
                gameover = 1;
            end
            else if (pscore < 6) //pscore between 0-5 = pcard 3
            begin
                load_pcard3 = 1;
                load_dcard2 = 0;  // go to s5
            end
            else
            begin
                load_pcard3 = 0;
                load_dcard2 = 0; // go to s6
            end
            
        end
        S5: 
        begin
            if (dscore == 7)
            begin
                load_pcard3 = 0;
                load_dcard3 = 1;
            end
            else if (dscore == 6 && (pcard3 == 6 || pcard3 == 7))
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
        end
        S6:
        begin
            if (pscore < 8) //pscore between 6-7 = no pcard
            begin
                if (dscore < 6) //dscore between 0-5 = dcard 3
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
        default: player_win_light = 1; 
    endcase
end

always_ff @(negedge resetb, posedge slow_clock ) 
begin
    if(~resetb)
		state <= SStart;
	else
		state <= next_state;
end


// The code describing your state machine will go here.  Remember that
// a state machine consists of next state logic, output logic, and the 
// registers that hold the state.  You will want to review your notes from
// CPEN 211 or equivalent if you have forgotten how to write a state machine.

endmodule

