`timescale 1ns/100ps

// TODO : write testbench
module reg_file (DATA_IN, DATA_OUT1, DATA_OUT2, IN_ADDRESS, OUT1_ADDRESS, OUT2_ADDRESS, WRITE_EN, CLK, RESET,CLK_INC,INC,R_OUT);
    
    input [31:0]  DATA_IN;
    input [4:0] INC;                                  // 32-bit data input
    input [4:0] IN_ADDRESS, OUT1_ADDRESS, OUT2_ADDRESS;     // Address lines
    input WRITE_EN, CLK, RESET,CLK_INC;                             // Control signals
    output reg [31:0] DATA_OUT1, DATA_OUT2;  
    output  reg [39:0]R_OUT ;
    wire clk3_out;  
    reg [10:0]test;            // 32-bit data outputs

    // 32-bit x 32 register file
    reg [31:0] REGISTERS [31:0]; 

    initial test =10'd0;

    /*** Read on negative clock edge ***/
    always @ (negedge CLK)
    begin
        DATA_OUT1 <= #2 REGISTERS[OUT1_ADDRESS];
        DATA_OUT2 <= #2 REGISTERS[OUT2_ADDRESS];
    end

    /*** Write on positive clock edge ***/
    integer i;
    always @ (posedge CLK) 
    begin
        #0.2
        if (RESET == 1'b1)
        begin
              
            for (i = 0; i < 32; i = i + 1)
            begin
                REGISTERS[i] <= #2 0;       // Write zero to all registers
            end
        end
        else
        begin
            // on paper RAND_INPUT assigned to REG[31]
            // and PC to REG[30] for ISR
            
            if (WRITE_EN == 1'b1 && IN_ADDRESS != 5'b00000)     // x0 must always be zero
            begin
                test<=test+10'd1;
                #2
                REGISTERS[IN_ADDRESS] <=  DATA_IN;    
               
            end
            // TODO : check for interrupt
        end
    end


always @(posedge CLK_INC ) begin
    
    case (INC)
          2:  R_OUT <= {REGISTERS[1][31:0],8'b00000001};
		  3:  R_OUT <= {REGISTERS[2][31:0],8'b00000010};
		  4:  R_OUT <= {REGISTERS[3][31:0],8'b00000011};
		  5:  R_OUT <= {REGISTERS[4][31:0],8'b00000100};
		  6:  R_OUT <= {REGISTERS[5][31:0],8'b00000101};
		  12: R_OUT <= {REGISTERS[6][31:0],8'b00010101};
		  13: R_OUT <= {REGISTERS[7][31:0],8'b00010110};
		  14: R_OUT <= {REGISTERS[8][31:0],8'b00010111};
		  15: R_OUT <= {REGISTERS[9][31:0],8'b00011000};
		  16: R_OUT <= {REGISTERS[10][31:0],8'b0011001};
	
    
        default: R_OUT <= {REGISTERS[1][31:0],8'b00000001};
    endcase
	 
	 
	
end





endmodule
