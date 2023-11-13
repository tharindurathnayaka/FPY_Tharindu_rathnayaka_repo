`timescale 1ns/100ps
module data_memory(
	clock,
	CLK_50,
    reset,
    read,
    write,
    address,
    writedata,
    readdata,
    busywait,
	 CLK_INC,
	 INC,
	 M_OUT
);
input           clock,CLK_50,CLK_INC;
input [4:0]INC;
input           reset;
input          [3:0] read;
input          [2:0] write;
input[31:0]      address;
input[31:0]      writedata;
output reg [31:0]readdata;
output       busywait;
output reg [39:0]M_OUT;
wire clk4_out;
integer i;




assign busywait=0;
//Declare memory array 256x8-bits 
reg [7:0] memory_array [40:0];

//Detecting an incoming memory access
reg readaccess, writeaccess;
always @(read, write)
begin
	//busywait = (read[3] || write[2])? 1 : 0;
	readaccess = (read[3] && !write[2])? 1 : 0;
	writeaccess = (!read[3] && write[2])? 1 : 0;
end


always @(address,read[3])
begin

 if(read[3])
    begin
        

        readdata[7:0]      <= memory_array[{address[31:2],2'b00}];
        readdata[15:8]     <= memory_array[{address[31:2],2'b01}];
        readdata[23:16]    <= memory_array[{address[31:2],2'b10}];
        readdata[31:24]    <= memory_array[{address[31:2],2'b11}];
       // busywait = 0;
		  //reade_done = 0;
    end

end


//Reading & writing

always @(posedge clock)
begin
  //
    if(write[2])
	begin
        memory_array[{address[31:2],2'b00}] <=writedata[7:0]  ;
        memory_array[{address[31:2],2'b01}]<=writedata[15:8]  ;
        memory_array[{address[31:2],2'b10}]<=writedata[23:16]  ;
        memory_array[{address[31:2],2'b11}]<=writedata[31:24]  ;
       // busywait = 0;
		  //write_done = 0;

		
		
    end 

   // {memory_array[3],memory_array[2],memory_array[1],memory_array[0]} <=32'b01000000111100000000000000000000; //7.5
   // {memory_array[7],memory_array[6],memory_array[5],memory_array[4]}  <=32'b01000000001011001100110011001101; // 5.1
   // {memory_array[11],memory_array[10],memory_array[9],memory_array[8]}<=32'b01000000101000110011001100110011; // 5.1

	 
	 if (reset)
    begin
        for (i=0;i<40; i=i+1)
            memory_array[i] = 0;
        
        //busywait = 0;
		readaccess = 0;
		writeaccess = 0;
    end
end

always @(posedge CLK_INC ) begin
    
    case (INC)
          12 :  M_OUT = {memory_array[3],memory_array[2],memory_array[1],memory_array[0],8'b00001100};
		  13 :  M_OUT = {memory_array[7],memory_array[6],memory_array[5],memory_array[4],8'b00001101};
		  14 :  M_OUT = {memory_array[11],memory_array[10],memory_array[9],memory_array[8],8'b00001110};
		  15 :  M_OUT = {memory_array[15],memory_array[14],memory_array[13],memory_array[12],8'b00001111};
		  16 :  M_OUT = {memory_array[19],memory_array[18],memory_array[17],memory_array[16],8'b00010000};
		  
    
        default: M_OUT = {36'd0,INC};
		    
    endcase
	 
	 end

endmodule


