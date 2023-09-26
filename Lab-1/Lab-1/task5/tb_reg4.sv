`timescale 1 ps / 1 ps

module tb_reg4;
    reg [3:0]tb_D;
    reg tb_clk;
    reg tb_reset;
    reg tb_EN;
    wire [3:0]tb_Q;

    reg4 DUT (.D(tb_D), .clk(tb_clk), .reset(tb_reset), .Q(tb_Q), .EN(tb_EN));


    always begin
        tb_clk = 1;
        tb_D = 1;
        tb_reset = 1;
        tb_EN = 1;
        #10;
        tb_clk = 0;
        #10;
        if(tb_Q )begin
		    $display ("PASSED phase 1 test");
	    end else begin
		    $error ("FAILED phase 1 test");
	    end
        #10;
        tb_clk = 0;
         #10;
        tb_clk = 1;
        #10;
        tb_clk = 0;
         #10;
        tb_clk = 1;
        tb_reset = 1;
        tb_EN = 0;
        tb_D = 0;
        if(tb_Q )begin
		    $display ("PASSED enable test");
	    end else begin
		    $error ("FAILED enable test");
	    end
        #10;
        tb_clk = 0;
        #10;
        tb_clk = 1;
        #10;
        tb_clk = 1;
        tb_D = 1;
        tb_reset = 1;
        tb_EN = 1;
        if(tb_Q)begin
		    $display ("PASSED phase 2 test");
	    end else begin
		    $error ("FAILED phase 2 test");
	    end
        #10;
        tb_clk = 0;
        #10;
        tb_clk = 1;
        #10;
        tb_clk = 0;
         #10;
        tb_clk = 1;
        tb_D = 1;
        tb_reset = 0;
        tb_EN = 1;
         #10;
        tb_clk = 0;
        #10;
        tb_clk = 1;
        if(tb_Q == 0 )begin
		    $display ("PASSED reset test");
	    end else begin
		    $error ("FAILED reset test");
	    end
        #10;
        tb_clk = 0;
        #10;
        tb_clk = 1;
        tb_D = 0;
        tb_reset = 1;
        tb_EN = 1;
        if(tb_Q == 0)begin
		    $display ("PASSED phase 3 test");
	    end else begin
		    $error ("FAILED phase 3 test");
	    end
        #10;
        tb_clk = 0;
        #10;
        break;
    end


endmodule  