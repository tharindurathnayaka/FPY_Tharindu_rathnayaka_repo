module signals(PC,INC,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

input [31:0]PC;
input [4:0]INC;
output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;

wire [7:0]PC_1,PC_3;
wire [3:0]PC_2,PC_4;

wire [7:0]INC_1;
wire [3:0]INC_2;


//pc------------------------ 
lpm_devide1 lpm_devide11(4'd10,PC[7:0],PC_1,PC_2);
bcd bcd2(PC_2,HEX0);

lpm_devide1 lpm_devide12(4'd10,PC_1,PC_3,PC_4);
bcd bcd1(PC_4,HEX1);
bcd bcd3(PC_3[3:0],HEX2);
bcd bcd4(8'b0000,HEX3);

//INC--------------------------------

lpm_devide1 lpm_devide13(4'd10,{3'b000,INC},INC_1,INC_2);
bcd bcd5(INC_1[3:0],HEX5);
bcd bcd6(INC_2,HEX4);




endmodule




module two_digit_bcd (in, hex0, hex1);
    input [3:0] in;
    output [6:0] hex0;
    output [6:0] hex1;
	 
	 wire [3:0] data1;
	 wire [3:0] data2;
	 
	 lpm_devide lpe_devide1(4'd10,in,data1,data2);
	 
	 bcd bcd1(data1,hex1);
	 bcd bcd2(data2,hex0);
	 


endmodule


module bcd(
     bcdin,
     seg
    );
     
     //Declare inputs,outputs and internal variables.
     input [3:0] bcdin;
     output [6:0] seg;
     reg [6:0] seg;

//always block for converting bcd digit into 7 segment format
    always @(bcdin)
    begin
        case (bcdin) //case statement
            0 : seg = 7'b1000000;
            1 : seg = 7'b1111001;
            2 : seg = 7'b0100100;
            3 : seg = 7'b0110000;
            4 : seg = 7'b0011001;
            5 : seg = 7'b0010010;
            6 : seg = 7'b0000010;
            7 : seg = 7'b1111000;
            8 : seg = 7'b0000000;
            9 : seg = 7'b0010000;
            //switch off 7 segment character when the bcd digit is not a decimal number.
            default : seg = 7'b1111111; 
        endcase
    end


endmodule
