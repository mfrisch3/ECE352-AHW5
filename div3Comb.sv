/////////////////////////////////////////////////////////
// div3Comb.sv:  This design implements a 4-bit       //
// incrementor and logic to divide by 3 	         //
//                                                  //
// Student 1 Name: << Enter you name here >>       //
// Student 2 Name: << Enter name if applicable >> //
///////////////////////////////////////////////////
module div3Comb(cnt, nxt_cnt, three);

  input [3:0] cnt;			// div6 requires a 2-bit counter but we use 4-bit
  output [3:0] nxt_cnt;  	// incremented version of cnt
  output three;				// assert when cnt = 0x2

  ////////////////////////////////////////////////////////
  // Declare any needed internal signals of type logic //
  //////////////////////////////////////////////////////
  wire[3:0] Carries;
  wire Cout;
  wire [3:0] incFAtoincAND;
  
  ///////////////////////////////////////////////////////
  // Use vectored instantiation to place the 4 AND   //
  // gates that knock the count down to zero when we //
  // hit 1/100th of a second                        //
  ///////////////////////////////////////////////////
  FA incFA[3:0](.A(cnt), .B(1'b0), .Cin({Carries[2:0], 1'b1}),.Cout(Carries),.S(incFAtoincAND[3:0]));
  and incAND[3:0](nxt_cnt, incFAtoincAND, !three);
  
  
  ////////////////////////////////////////////////////
  // Implement logic (ANDs/ORs used to detect when //
  // cnt == 0x2 (only need to detect the 1's)     //
  /////////////////////////////////////////////////
  and detect(three,1'b1,cnt[1]);

 
 
endmodule