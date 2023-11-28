/////////////////////////////////////////////////////////
// clkdiv4096.sv is used for testing.  Produces pulse //
// every 0.01/4096 seconds.  Used to speed up time.  // 
//////////////////////////////////////////////////////
module clkdiv4096(
  input clk,				// 50MHz
  input rst_n,				// asynch active low reset
  output hundrethSec4096	// pulses high 1 clk every 1/100/4096 sec
);

  ///////////////////////////////////////////
  // Declare any needed internal signals. //
  /////////////////////////////////////////
  reg [6:0] divcnt;
  
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n)
	  divcnt <= 7'h00;
	else if (hundrethSec4096)
	  divcnt <= 7'h00;
	else
	  divcnt <= divcnt + 1;
	  
  assign hundrethSec4096 = (divcnt==7'h79) ? 1'b1 : 1'b0;
  
endmodule
  