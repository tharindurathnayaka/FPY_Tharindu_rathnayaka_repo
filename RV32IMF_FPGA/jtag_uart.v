 module jtag_intro(CLK_50,RESET,LEDR,R_IN,M_IN,PC_IN,INC,CLK_IN,INS_IN,CLK_INC);

input RESET,CLK_50;
input [39:0]R_IN,M_IN,PC_IN,INS_IN,CLK_IN;
output [7:0] LEDR;
output [4:0]INC;
output CLK_INC;
wire clk1_out,clk2_out, clk_so;
wire [7:0]readdata;
reg [7:0] jtag_write_data;
reg [39:0]jatg_data;
reg [4:0] INC1,INC2;
reg [7:0]LED;




reg [39:0]R;

Clock_divider1 Clock_divider1(CLK_50,clk_so);

ClockDivider_pp ClockDivider_pp1(clk_so,clk1_out,clk2_out);



assign LEDR[0]=CLK_50;
assign LEDR[1]=clk_so;
assign LEDR[2]=clk1_out;
assign LEDR[3]=clk2_out;

assign INC =INC2;
assign CLK_INC=clk2_out;


JTAG_UART_MODULE JTAG_UART_MODULE1(CLK_50 , 1'b0,~(clk1_out )  , readdata, jtag_write_data);

//-----------------------------------------

initial begin
    INC1=5'd0;
	  INC2=5'd0;
	 
	 R=         40'b0000000000000000000000000000000011111111;
   jatg_data =40'd45;
	  
	end
	
	

always @(posedge (clk1_out ) ) begin
    
    

    INC1 = INC1 + 5'd1;

    case (INC1)
        1: jtag_write_data <= jatg_data[7:0];
        2: jtag_write_data <= jatg_data[15:8];
        3: jtag_write_data <= jatg_data[23:16];
        4: jtag_write_data <= jatg_data[31:24];
     
        5: begin
            jtag_write_data <= jatg_data[39:32];
            INC1 <= 0;
        end
        default: jtag_write_data = 8'b00000011; 
    endcase
	 
	 
	
end




always @(posedge clk2_out) begin
   
    

    INC2 = INC2 + 5'd1;

    case (INC2)
      1:  jatg_data = R;
		  2:  jatg_data = R_IN;
      3:  jatg_data = R_IN;
      4:  jatg_data = R_IN;
		  5:  jatg_data = R_IN;
		  6:  jatg_data = R_IN;
		  7:  jatg_data = R_IN;
		  8:  jatg_data = R_IN;
		  9:  jatg_data = R_IN;
		  10: jatg_data = R_IN;
		  11: jatg_data = R_IN;
		  12: jatg_data = M_IN;
		  13: jatg_data = M_IN;
		  14: jatg_data = M_IN;
		  15: jatg_data = M_IN;
		  16: jatg_data = M_IN;
		  17: jatg_data = PC_IN;
		  18: jatg_data = INS_IN;
		 
      19: begin
            jatg_data =CLK_IN ;
            INC2 = 0;
        end
        default: jatg_data = R_IN; 
    endcase
	


	
end



endmodule





module Clock_divider1(clock_in,clock_out
    );
input clock_in; // input clock on FPGA
output reg clock_out; // output clock after dividing the input clock by divisor
reg[27:0] counter=28'd0;
parameter DIVISOR = 28'd9000000;

always @(posedge clock_in)
begin
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1))
  counter <= 28'd0;
 clock_out <= (counter<DIVISOR/2)?1'b1:1'b0;
end
endmodule






module ClockDivider_pp (
  input wire clk,        // Input clock
  output reg clk_out1,clk_out2    // Divided clock output
);


initial begin
clk_out1 =1'b0;
clk_out2 =1'b0;
end

reg [5:0] count = 0;     // 5-bit counter
reg [5:0] count2 = 0;  

always @(posedge clk  ) begin
  if (count >= 5'd3 && count < 5'd13) begin
 
    clk_out1 <= ~clk_out1; // Toggle the output clock
  end

  else if (count == 5'd15) begin
	count = 5'd0;
	count2 = 5'd0;

  end
 

  else if(count2 ==5'd2  || count2 ==5'd14) begin
    
	 clk_out2 <= ~clk_out2; // Toggle the output clock


  end

   else begin
    
  end

  count <= count + 1; 
  count2 <= count2 + 1; 
end

endmodule
