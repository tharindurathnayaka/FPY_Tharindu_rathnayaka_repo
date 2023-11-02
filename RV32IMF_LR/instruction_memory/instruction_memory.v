`timescale 1ns/100ps

module instruction_memory (CLK,RESET, READ_ADDRESS, READ_DATA, BUSYWAIT,PC_OUT,CLK_OUT,INS_OUT);
    input CLK, RESET;
    input [31:0] READ_ADDRESS;
    output reg BUSYWAIT;
    output reg [31:0] READ_DATA;
	 output [39:0]PC_OUT,INS_OUT,CLK_OUT;


    reg [7:0] memory_array [85:0];    // 1024 x 8-bits memory array

    assign PC_OUT ={READ_ADDRESS[31:0],8'b00011110};
	 assign INS_OUT =  {14'd0,READ_DATA[31:25],READ_DATA[14:12],READ_DATA[6:0],8'b00011111};
	 assign CLK_OUT={7'd0,24'd0,CLK,8'b00100000};

    always 
    begin
        BUSYWAIT <= 0;
        #1

        // Sample program given below. You may hardcode your software program here, or load it from a file:
        {memory_array[10'd3],  memory_array[10'd2],  memory_array[10'd1],  memory_array[10'd0]}  <= 32'b00000000100100000000000010010011; 
        {memory_array[10'd7],  memory_array[10'd6],  memory_array[10'd5],  memory_array[10'd4]}  <= 32'b00000000010100000000000100010011;
        {memory_array[10'd11], memory_array[10'd10], memory_array[10'd9],  memory_array[10'd8]}  <= 32'b00000000001000001000001100110011;
        {memory_array[10'd15], memory_array[10'd14], memory_array[10'd13], memory_array[10'd12]} <= 32'b01000000001000001000001110110011;
        {memory_array[10'd19], memory_array[10'd18], memory_array[10'd17], memory_array[10'd16]} <= 32'b00000000011000000010000000100011;
        {memory_array[10'd23], memory_array[10'd22], memory_array[10'd21], memory_array[10'd20]} <= 32'b00000000011100000010010000100011; 
        {memory_array[10'd27], memory_array[10'd26], memory_array[10'd25], memory_array[10'd24]} <= 32'b00000000000000000010010000000011;   
        {memory_array[10'd31], memory_array[10'd30], memory_array[10'd29], memory_array[10'd28]} <= 32'b00000000100000000010010010000011; 

         //Floating points instructions

		{memory_array[10'd35], memory_array[10'd34], memory_array[10'd33], memory_array[10'd32]} <= 32'b00000000100000000010000110000111;
        /*
        {memory_array[10'd39], memory_array[10'd38], memory_array[10'd37], memory_array[10'd36]} <= 32'b00000000000000000000000000000000; 
        
        
        
        {memory_array[10'd43], memory_array[10'd42], memory_array[10'd41], memory_array[10'd40]} <= 32'b00000000000000000000000000000000; 
		  {memory_array[10'd47], memory_array[10'd46], memory_array[10'd45], memory_array[10'd44]} <= 32'b00000000000000000000000000000000;
       
        {memory_array[10'd51], memory_array[10'd50], memory_array[10'd49], memory_array[10'd48]} <= 32'b00000000000000000000000000000000; 
        
        {memory_array[10'd55], memory_array[10'd54], memory_array[10'd53], memory_array[10'd52]} <= 32'b00000000000000000000000000000000; 
		  {memory_array[10'd59], memory_array[10'd58], memory_array[10'd57], memory_array[10'd56]} <= 32'b00000000000000000000000000000000; 
		  {memory_array[10'd63], memory_array[10'd62], memory_array[10'd61], memory_array[10'd60]} <= 32'b00000000000000000000000000000000; 
		  {memory_array[10'd67], memory_array[10'd66], memory_array[10'd65], memory_array[10'd64]} <= 32'b00000000000000000000000000000000;
		  {memory_array[10'd71], memory_array[10'd70], memory_array[10'd69], memory_array[10'd68]} <= 32'b00000000000000000000000000000000;


		  {memory_array[10'd75], memory_array[10'd74], memory_array[10'd73], memory_array[10'd72]} <= 32'b00000000000000000000000000000000; 

          
		  {memory_array[10'd79], memory_array[10'd78], memory_array[10'd77], memory_array[10'd76]} <= 32'b00000000100000000010000110000111;
		  {memory_array[10'd83], memory_array[10'd82], memory_array[10'd81], memory_array[10'd80]} <= 32'b00000000000000000010001000000111;
		  
		*/
		  
		  
    end
	 

    always @ (posedge CLK)
    begin
        #0.1
        READ_DATA[7:0]      <= memory_array[{READ_ADDRESS[31:2],2'b00}];
        READ_DATA[15:8]     <= memory_array[{READ_ADDRESS[31:2],2'b01}];
        READ_DATA[23:16]    <= memory_array[{READ_ADDRESS[31:2],2'b10}];
        READ_DATA[31:24]    <= memory_array[{READ_ADDRESS[31:2],2'b11}];
    end
	
	

	 

	 
	 
	 
	 
	 
	 

endmodule




