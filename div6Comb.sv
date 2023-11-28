/////////////////////////////////////////////////////////
// div6Comb.sv:  This design implements a 4-bit       //
// incrementor and logic to divide by 6 	         //
//                                                  //
// Student 1 Name: << Enter you name here >>       //
// Student 2 Name: << Enter name if applicable >> //
///////////////////////////////////////////////////
module div6Comb(cnt, nxt_cnt, six);

  input [3:0] cnt;			// div6 requires a 3-bit counter but we use 4-bit
  output [3:0] nxt_cnt;  		// incremented version of cnt
  output six;				// assert when cnt = 0x5

  ////////////////////////////////////////////////////////
  // Declare any needed internal signals of type logic //
  //////////////////////////////////////////////////////
  
  logic [3:0] outputOfCareAdder;
  wire [3:0] Carries;
  
  

  ///////////////////////////////////////////////////////
  // Use vectored instantiation to place the 4 AND   //
  // gates that knock the count down to zero when we //
  // hit 1/100th of a second                        //
  ///////////////////////////////////////////////////
  FA iFA[3:0](.A(cnt), .B(4'b0000), .Cin({Carries[2:0], 1'b1}), .S(outputOfCareAdder), .Cout(Carries));
  
  and iAND0[3:0](nxt_cnt, ~six, outputOfCareAdder);

  
  ////////////////////////////////////////////////////
  // Implement logic (ANDs/ORs used to detect when //
  // cnt == 0x5 (only need to detect the 1's)     //
  /////////////////////////////////////////////////
  // 0x5 in binary = 0101


  and iAND3(six, cnt[0], cnt[2]);

 
endmodule