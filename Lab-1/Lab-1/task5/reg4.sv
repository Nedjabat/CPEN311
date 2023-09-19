module reg4(D,clk,reset,Q);
    input D; // Data input 
    input clk; // clock input 
    input reset; // asynchronous reset high level
    output reg Q; // output Q 
    always @(posedge clk or negedge reset) 
    begin
        if(reset==1'b0)
        Q <= 1'b0; 
        else 
        Q <= D; 
    end 
endmodule 