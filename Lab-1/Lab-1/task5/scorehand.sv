module scorehand(input [3:0] card1, input [3:0] card2, input [3:0] card3, output [3:0] total);
    reg [3:0] val1, val2, val3;
    assign val1 = (card1 < 10) ? card1 : 0;
    assign val2 = (card2 < 10) ? card2 : 0;
    assign val3 = (card3 < 10) ? card3 : 0;
        
    assign total = ((val1+val2+val3)%10);
    
// The code describing scorehand will go here.  Remember this is a combinational
// block. The function is described in the handout.  Be sure to review the section
// on representing numbers in the lecture notes.

endmodule

