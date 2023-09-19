module statemachine(input slow_clock, input resetb,
                    input [3:0] dscore, input [3:0] pscore, input [3:0] pcard3,
                    output load_pcard1, output load_pcard2,output load_pcard3,
                    output load_dcard1, output load_dcard2, output load_dcard3,
                    output player_win_light, output dealer_win_light);

int state, S0, S1, S2, S3, next_state

always_comb 
begin : next_state_logic
    case (state)
        S0: next_state = S1
        S1: next_state = S2
        S2: next_state = S3
        S3: next_state = 
        default: 
    endcase
    
end

always_comb begin : blockName
    case (state)
        S0:
        begin 
             
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
        end
        end`
        S1: 
        begin
            load_pcard1 = 0;
            load_pcard2 = 0;
            load_pcard3 = 0;
            load_dcard1 = 1;
            load_dcard2 = 0;
            load_dcard3 = 0;
            player_win_light = 0;
            dealer_win_light = 0;
        end
        S2: 
        begin
            load_pcard1 = 0;
            load_pcard2 = 1;
            load_pcard3 = 0;
            load_dcard1 = 0;
            load_dcard2 = 0;
            load_dcard3 = 0;
            player_win_light = 0;
            dealer_win_light = 0;
        end
        S3: 
        begin
            load_pcard1 = 0;
            load_pcard2 = 0;
            load_pcard3 = 0;
            load_dcard1 = 0;
            load_dcard2 = 1;
            load_dcard3 = 0;
            player_win_light = 0;
            dealer_win_light = 0;
        end
        S4: 
        begin
            if ((pscore == 8) || (pscore == 9) || (dscore == 8) || (dscore == 9))
                begin
                    if(pscore > dscore)
                        player_win_light == 1:
                    else if (dscore > pscore)
                        dealer_win_light == 1:
                    else
                    begin 
                        player_win_light == 1; 
                        dealer_win_light == 1;
                    end
                end
            else
            load_pcard1 = 0;
            load_pcard2 = 0;
            load_pcard3 = 1;
            load_dcard1 = 0;
            load_dcard2 = 0;
            load_dcard3 = 0;
            player_win_light = 0;
            dealer_win_light = 0;
        end
        default: 
    endcase
end

always_ff @(negedge rst, posedge slow_clock ) 
begin
    if(~reset)
		state <= S0;
	else
		state <= next_state;
end


// The code describing your state machine will go here.  Remember that
// a state machine consists of next state logic, output logic, and the 
// registers that hold the state.  You will want to review your notes from
// CPEN 211 or equivalent if you have forgotten how to write a state machine.

endmodule

