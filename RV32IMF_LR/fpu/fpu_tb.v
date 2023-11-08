

 `include "fpu.v"
 `include "../support_modules/plus_4_adder.v"
`include "../support_modules/mux_4to1_32bit.v"
`include "../support_modules/mux_2to1_32bit.v"

 
 `timescale 1ns/100ps   

module fpu_tb;




reg[31:0]DATA1,DATA2,DATA3;
wire[31:0]RESULT;
reg[4:0]SELECT;



fpu fpu1 (DATA1, DATA2, DATA3, RESULT, SELECT);

initial begin

    DATA1= 32'b01000000111100000000000000000000; //7.5
    DATA2 =32'b01000000100001100110011001100110; //4.2
    DATA3=32'b01000000101000110011001100110011 ; //5.1
    SELECT= 5'b00001;
    #5
    $display("FPU result = %b", RESULT)    ;



    SELECT= 5'b00010;
    #5
    $display("FPU result = %b", RESULT)  ;


    SELECT= 5'b00011;
    #5
    $display("FPU result = %b", RESULT)  ;


    SELECT= 5'b00100;
    #5
    $display("FPU result = %b", RESULT)  ;

    
    SELECT= 5'b01110;
    #5
    $display("FPU result = %b", RESULT)  ;









end



endmodule