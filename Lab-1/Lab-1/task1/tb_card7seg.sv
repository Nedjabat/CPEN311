`timescale 1 ps / 1 ps

module tb_card7seg;
    reg  [3:0] TB_SW;
    wire [6:0] TB_HEX0;
    integer i;
    
    card7seg DUT (.SW(TB_SW), .HEX0(TB_HEX0));

    initial 
    begin
        for (i = 0;i < 16;i = i + 1 ) 
        begin
            TB_SW = i;
            #10;    
        end
    end
// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").
						
endmodule

