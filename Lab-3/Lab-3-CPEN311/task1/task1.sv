module task1(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    // your code here
    logic [7:0] address;
    logic clock;
    logic [7:0] data;
    logic wren;
    logic [1:0] state = 0;
    s_mem s(.address(address), .clock(CLOCK_50), .data(data), .wren(wren), .q());
    init init(.clk(CLOCK_50), .rst_n(KEY[3]), .en(en), .rdy(rdy), .addr(address), .wrdata(data), .wren(wren)) 

    always_ff @(posedge CLOCK_50)
        begin
            case(state)
                2'b00:
                begin
                    if (KEY[3] == 0) 
                    begin
                        state = 1;    
                    end
                    else
                    begin
                        state = 0;
                    end
                end
                2'b01:
                begin
                    if (rdy == 0)
                        state = 1;
                    else
                        state = 2
                end
                2'b10:    state = 3;

                2'b11:
        end
    // your code here

endmodule: task1
