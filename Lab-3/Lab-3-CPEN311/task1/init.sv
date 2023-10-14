module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

// your code here
    logic [7:0] S = 0;
    logic [1:0] state = 2'b00;

    assign wrdata = S;
	assign addr = S;

    always_ff @(posedge clk, negedge rst_n)
    begin
        if (rst_n == 0) // active low reset
            state = 0;
    
        case(state)
            2'b00:
            begin
            if (en == 1)
                begin
                    state <= 2'b01;
                    rdy <= 0;
                    S <= 0;
                end
            else 
                begin
                    state <= 2'b00;
                    rdy <= 1;
                    S <= 0;
                end
            end

            2'b01:
            begin
                state <= 2'b10;
            end
            
            2'b10:
            begin
                if (S < 255)
                    begin
                        S <= S + 1;
                        state = 2'b10
                    end
                else
                    begin
                        state <= 2'b11
                    end
            end
            
            2'b11:
            begin
                rdy <= 1;
                state <= 2'b00;
            end
        endcase
    end

    always_comb
    begin
        case(state)
        2'b00:  wren = 0;

        2'b01:  wren = 1;

        2'b10:  wren = 0;

        2'b11:  wren = 0;
        endcase
    end
endmodule: init