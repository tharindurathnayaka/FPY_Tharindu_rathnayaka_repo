module clk_sel(CLK_50,CLK_IN,SEL,CLK_OUT);

input CLK_IN,SEL,CLK_50;
output reg CLK_OUT;
wire clk_out_d;

Clock_divider6 Clock_divider61(CLK_50,clk_out_d);

always @(posedge CLK_50) begin

if(SEL==0)
 begin
CLK_OUT<=CLK_IN;


end
else begin


CLK_OUT<=clk_out_d;


end

end

endmodule 



module Clock_divider6(clock_in,clock_out
    );
input clock_in; // input clock on FPGA
output reg clock_out; // output clock after dividing the input clock by divisor
reg[27:0] counter=28'd0;
parameter DIVISOR = 28'd4000000000;
// The frequency of the output clk_out
//  = The frequency of the input clk_in divided by DIVISOR
// For example: Fclk_in = 50Mhz, if you want to get 1Hz signal to blink LEDs
// You will modify the DIVISOR parameter value to 28'd50.000.000
// Then the frequency of the output clk_out = 50Mhz/50.000.000 = 1Hz
always @(posedge clock_in)
begin
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1))
  counter <= 28'd0;
 clock_out <= (counter<DIVISOR/2)?1'b1:1'b0;
end
endmodule