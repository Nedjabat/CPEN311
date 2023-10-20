`timescale 1ps / 1ps

module tb_rtl_task1();


    // Your testbench goes here.
    wire [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
    wire [9:0] LEDR;

    logic CLOCK_50;
    logic [3:0] KEY;
    logic [9:0] SW; 


    task1 task1_tb(CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR); 

    initial 
    begin
        CLOCK_50 = 0;
        forever
        #1 CLOCK_50 =~CLOCK_50; 
    end

    initial
    begin 
        KEY[3] = 1; 
        #5;
        KEY[3] = 0; 
        #5;
        KEY[3] = 1; 
        #1000; 
        KEY[3] = 0;
        #5;
        KEY[3] = 1;

    end 

endmodule: tb_rtl_task1
