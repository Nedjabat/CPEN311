`timescale 1 ps / 1 ps

module tb_reg4;
    reg tb_D;
    reg tb_clk;
    reg tb_reset;
    wire tb_Q;

    reg4 DUT (.D(tb_D), .clk(tb_clk), .reset(tb_reset), .Q(tb_Q));

    always begin
        tb_clk = 1;
        tb_D = 1;
        tb_reset = 1;
        #10;
        tb_clk = 0;
        #10;
        tb_clk = 1;
        tb_D = 0;
        tb_reset = 1;
        #10;
        tb_clk = 0;
        #10;
        tb_clk = 1;
        tb_D = 1;
        tb_reset = 0;
        #10;
        tb_clk = 0;
        #10;
        tb_clk = 1;
        tb_D = 1;
        tb_reset = 1;
        #10;
        tb_clk = 0;
        #10;
        tb_clk = 1;
        tb_D = 0;
        tb_reset = 1;
        #10;
        tb_clk = 0;
        #10;
        tb_clk = 1;
        tb_D = 1;
        tb_reset = 0;
        #10;
        tb_clk = 0;
        #10;
    end


endmodule  