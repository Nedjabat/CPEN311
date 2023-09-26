`timescale 1 ps / 1 ps

module tb_scorehand();
    reg [3:0] tb_card1;
    reg [3:0] tb_card2; 
    reg [3:0] tb_card3; 
    wire [3:0] tb_total;
    integer i;
    
    scorehand DUT (.card1(tb_card1), .card2(tb_card2), .card3(tb_card3), .total(tb_total));

    initial 
    begin
        for (i = 0;i < 10;i = i + 1 ) 
        begin
            tb_card1 = i;
            tb_card2 = i + 1;
            tb_card3 = i + 2;
            #5;
            if (i == 8)
            begin
                if(tb_total == ((tb_card1+tb_card2)%10))
                begin
		            $display ("PASSED phase 2 card test");
	            end else begin
		            $error ("FAILED third card test");
	            end
            end
            else if (i == 9)
            begin
                if(tb_total == ((tb_card1)%10))
                begin
		            $display ("PASSED phase 3 card test");
	            end else begin
		            $error ("FAILED third card test");
	            end
            end
            else if(tb_total == ((tb_card1+tb_card2+tb_card3)%10))
            begin
		        $display ("PASSED phase 1 card test");
	        end else begin
		        $error ("FAILED third card test");
	        end
            #5;    
        end
    end
// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").
						
endmodule

