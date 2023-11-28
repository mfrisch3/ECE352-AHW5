//////////////////////////////////////////////////////////
// div10.sv:  This design implements a 4-bit counter   //
// to assert inc_nxt signal every 10 clks if enabled  //
//                                                   //
// Student 1 Name: << Enter you name here >>        //
// Student 2 Name: << Enter name if applicable >>  //
////////////////////////////////////////////////////
module div10(
  input clk,			// 50MHz
  input rst_n,			// asynch active low reset
  input en,				// only increment when enabled
  output [3:0] cnt,		// BCD digit for this divider
  output inc_nxt		// if count full and enable then increment
						// next counter up the food chain
);

  ///////////////////////////////////////////
  // Declare any needed internal signals. //
  /////////////////////////////////////////
  
  logic [3:0]nxt_cnt_to_D;
  logic ten;
  
  
  ////////////////////////////////////////////////////////////////
  // Instantiate div10Comb and feedback nxt_cnt to flop inputs //
  //////////////////////////////////////////////////////////////
  div10Comb  div10_comb(.cnt(cnt), .nxt_cnt(nxt_cnt_to_D), .ten(ten));
 
 


  
  /////////////////////////////////////////////////////////////
  // Instantiate 4 d_en_ff as a vector to implement counter //
  // Should be reset with rst_n.  Tie PRN inactive.  Only  //
  // enabled when enable signal high.                     //
  /////////////////////////////////////////////////////////
  d_en_ff ENflipflop1[3:0](.clk(clk), .D(nxt_cnt_to_D), .CLRN(rst_n), .EN(en), .Q(cnt));
  
				  
  //////////////////////////////////////////////////////
  // When this counter full and enabled we increment //
  // the next counter up the food chain.            //
  ///////////////////////////////////////////////////
  and AND0(inc_nxt, en, ten);
  
endmodule
  