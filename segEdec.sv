module segEdec
(
	input [3:0] D,
	output segE
);

 //////////////////////////////////////////
  // Declare any needed internal signals //
  ////////////////////////////////////////
  logic n1,not1;
  
  //////////////////////////////////////////////////////
  // Write STRUCTURAL verilog to implement segment B //
  ////////////////////////////////////////////////////
  not iINV1(not1,D[1]);
  and iAND1(n1,D[2],not1);
  or iOR1(segE,n1,D[0]);
  
endmodule
