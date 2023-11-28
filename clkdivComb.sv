//////////////////////////////////////////////////////////
// clkdivComb.sv:  This design implements a 19-bit     //
// incrementor and logic to detect 1/100th sec 	      //
// assuming 50MHz clk                                //
// Count needs to reset when it hits 1/100th		//
//                                                 //
// Student 1 Name: << Enter you name here >>      //
// Student 2 Name: << Enter name if applicable >>//
//////////////////////////////////////////////////
module clkdivComb(divcnt, nxt_divcnt, hundrethSec);

  input [18:0] divcnt;	// with a 50MHz clk you need 19-bits for 0.01 sec
  output [18:0] nxt_divcnt;  	// incremented version of divcnt
  output hundrethSec;				// assert when divcnt = 0x7A11F
  
  ////////////////////////////////////////////////////////
  // Declare any needed internal signals of type logic //
  //////////////////////////////////////////////////////
  
  logic [18:0] outputOfCareAdder;
  wire [18:0] Carries;

  
  logic [4:0] checkNum_and1;
  logic checkNum_and2;
  logic checkNum_and3;
  logic [3:0] checkNum_and4;

  
  ///////////////////////////////////////////////////////
  // Use vectored instantiation to place the 18 AND   //
  // gates that knock the count down to zero when we //
  // hit 1/100th of a second                        //
  ///////////////////////////////////////////////////
                             // just add to zero         // inject a 1 into Cin
  FA iFA[18:0](.A(divcnt), .B(19'b0000000000000000000), .Cin({Carries[17:0], 1'b1}), .S(outputOfCareAdder), .Cout(Carries));


  and iAND[18:0](nxt_divcnt, ~hundrethSec, outputOfCareAdder);

  
  ///////////////////////////////////////////////////////
  // Implement logic (ANDs/ORs used to detect when    //
  // divcnt == 0x7A11F (only need to detect the 1's) //
  ////////////////////////////////////////////////////
  
  // to check if a number is the same, and all the ones in that number with one and then and all the outputs of those ands together
  // basically make a mask of ones and check that you got all ones when anding the mask and the input together
  
  // 0x7A11F in binary = 1111010000100011111 

  // first and checks the first 5 zeros [4:0]

  and iAND1[4:0](checkNum_and1, divcnt[4:0], 5'b11111);

  // second and checks the 1 in the 9th place [8]

  and iAND2(checkNum_and2, divcnt[8], 1'b1);

  // third and checks the 1 in the 14th place [13]

  and iAND3(checkNum_and3, divcnt[13], 1'b1);

  // fourth and checks the last 4 ones [15:18]

  and iAND4[18:15](checkNum_and4, divcnt[18:15], 4'b1111);

  // fifth and that ands all the other ands together, if all of their bits are 1, then all the 1 bits must be the same in each number,
  // therefore the numbers are equal and the output will be one
 
  and iAND5(hundrethSec, checkNum_and1[0], checkNum_and1[1], checkNum_and1[2], checkNum_and1[3], checkNum_and1[4], checkNum_and2, checkNum_and3, checkNum_and4[0], checkNum_and4[1], checkNum_and4[2], checkNum_and4[3]);


 
endmodule