module reg4(D,clk,reset,Q,EN);
    input [3:0] D; // Data input 
    input clk, EN, reset; // clock input 
    output reg [3:0] Q; // output Q 
    always @(posedge clk or negedge reset) 
    begin
        if(reset == 1'b0)
        Q <= 0; 
        else if (EN == 1)
        Q <= D; 
    end 
endmodule 