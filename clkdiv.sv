//////////////////////////////////////////////////////////
// clkdiv.sv:  This design implements a 19-bit divider //
// to assert hundrethSec signal assuming 50MHz clk 	  //
//                                                   //
// Student 1 Name: << Matt Frisch>>        //
// Student 2 Name: << Enter name if applicable >>  //
////////////////////////////////////////////////////
module clkdiv(
  input clk,			// 50MHz
  input rst_n,			// asynch active low reset
  output hundrethSec	// pulses high 1 clk every 1/100 sec
);

  ///////////////////////////////////////////
  // Declare any needed internal signals. //
  /////////////////////////////////////////
  logic [18:0]nxt_divcnt_to_D; 
  logic [18:0]Qout;
  
  ////////////////////////////////////////////////////////////////////
  // Instantiate clkdivComb and feedback nxt_divcnt to flop inputs //
  //////////////////////////////////////////////////////////////////
  clkdivComb clkdivcloud(.divcnt(Qout), .nxt_divcnt(nxt_divcnt_to_D), .hundrethSec(hundrethSec));
  d_ff flipflop1[18:0](.clk(clk), .D(nxt_divcnt_to_D), .CLRN(rst_n), .PRN(1'b1), .Q(Qout));
  ///////////////////////////////////////////////////////////
  // Instantiate 19 d_ff as a vector to implement counter //
  // Should be reset with clk_n.  Tie PRN inactive       //
  ////////////////////////////////////////////////////////
 
 
  
endmodule
  