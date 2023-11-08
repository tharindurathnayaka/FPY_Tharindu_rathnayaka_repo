`timescale 1ns/100ps

module f_reg_file (DATA_IN, DATA_OUT1, DATA_OUT2, DATA_OUT3, IN_ADDRESS, OUT1_ADDRESS, OUT2_ADDRESS, OUT3_ADDRESS, WRITE_EN, CLK, RESET,CLK_INC,INC,FR_OUT);
    
    input [31:0]  DATA_IN;                                                // 32-bit data input
    input [4:0] IN_ADDRESS, OUT1_ADDRESS, OUT2_ADDRESS, OUT3_ADDRESS;     // Address lines
    input WRITE_EN, CLK, RESET,CLK_INC;                                     // Control signals
    input[4:0]INC;
    output [31:0] DATA_OUT1, DATA_OUT2, DATA_OUT3;                 // 32-bit data outputs
    output reg[39:0]FR_OUT;

    // 32-bit x 32 register file
    reg [31:0] REGISTERS [31:0]; 

    /*** Read asynchronously ***/
    assign #2 DATA_OUT1 = REGISTERS[OUT1_ADDRESS];
    assign #2 DATA_OUT2 = REGISTERS[OUT2_ADDRESS];
    assign #2 DATA_OUT3 = REGISTERS[OUT3_ADDRESS];

    /*** Write on negative clock edge ***/
    integer i;
    always @ (negedge CLK) 
    begin
        if (RESET == 1'b1)
        begin
            for (i = 0; i < 32; i = i + 1)
            begin
                REGISTERS[i] <= #2 0;       // Write zero to all registers
            end
        end
        else
        begin
            if (WRITE_EN == 1'b1)
            begin
                REGISTERS[IN_ADDRESS] <= #2 DATA_IN;    
            end
        end
    end




always @(posedge CLK_INC ) begin
    
    case (INC)
        2:  FR_OUT <= {REGISTERS[1][7:0],24'd0,8'b00000001};
		  3:  FR_OUT <= {REGISTERS[2][7:0],24'd0,8'b00000010};
		  4:  FR_OUT <= {REGISTERS[3][7:0],24'd0,8'b00000011};
		  5:  FR_OUT <= {REGISTERS[4][7:0],24'd0,8'b00000100};
		  6:  FR_OUT <= {REGISTERS[5][7:0],24'd0,8'b00000101};
		  12: FR_OUT <= {REGISTERS[6][7:0],24'd0,8'b00010101};
		  13: FR_OUT <= {REGISTERS[7][7:0],24'd0,8'b00010110};
		  14: FR_OUT <= {REGISTERS[8][7:0],24'd0,8'b00010111};
		  15: FR_OUT <= {REGISTERS[9][7:0],24'd0,8'b00011000};
		  16: FR_OUT <= {REGISTERS[10][7:0],24'd0,8'b0011001};
	
    
        default: FR_OUT <= {REGISTERS[1][7:0],24'd0,8'b00000001};
    endcase
	 
	 
	
end

/*
always @(posedge CLK ) begin


   REGISTERS[1] <= 32'd1;  
   REGISTERS[2] <= 32'd2;    
   REGISTERS[3] <= 32'd3;    


end

*/

endmodule
