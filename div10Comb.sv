/////////////////////////////////////////////////////////
// div10Comb.sv:  This design implements a 4-bit      //
// incrementor and logic to divide by 10 	         //
//                                                  //
// Student 1 Name: << Enter you name here >>       //
// Student 2 Name: << Enter name if applicable >> //
///////////////////////////////////////////////////
module div10Comb(cnt, nxt_cnt, ten);

  input [3:0] cnt;			// div10 requires a 4-bit counter
  output [3:0] nxt_cnt;  	// incremented version of cnt
  output ten;				// assert when cnt = 0x9
  
  ////////////////////////////////////////////////////////
  // Declare any needed internal signals of type logic //
  //////////////////////////////////////////////////////
  
  logic [3:0] outputOfCareAdder;
  wire [3:0] Carries;
  
  ///////////////////////////////////////////////////////
  // Use vectored instantiation to place the 4 AND    //
  // gates that knock the count down to zero when we //
  // hit 1/100th of a second                        //
  ///////////////////////////////////////////////////
                           // just add to zero         // inject a 1 into Cin
  FA iFA[3:0](.A(cnt), .B(4'b0000), .Cin({Carries[2:0], 1'b1}), .S(outputOfCareAdder), .Cout(Carries));
  
  and iAND0[3:0](nxt_cnt, ~ten, outputOfCareAdder);

  
  ////////////////////////////////////////////////////
  // Implement logic (ANDs/ORs used to detect when //
  // cnt == 0x9 (only need to detect the 1's)     //
  /////////////////////////////////////////////////
  
 // 0x9 in binary = 1001

  // first check the LSB

 
  // and the checks together

  and iAND3(ten, cnt[0], cnt[3]);
 
 
endmodule