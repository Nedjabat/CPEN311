module scorehand(input [3:0] card1, input [3:0] card2, input [3:0] card3, output [3:0] total);
    reg [3:0] val1, val2, val3;
    assign val1 = (card1 < 4'b1010) ? card1 : 4'b0000;
    assign val2 = (card2 < 4'b1010) ? card2 : 4'b0000;
    assign val3 = (card3 < 4'b1010) ? card3 : 4'b0000;
        
    assign total = ((val1+val2+val3)%4'b1010);
    
// The code describing scorehand will go here.  Remember this is a combinational
// block. The function is described in the handout.  Be sure to review the section
// on representing numbers in the lecture notes.

endmodule

