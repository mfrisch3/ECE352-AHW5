// note that this is NOT a program - it is a hardware description that gets turned into logic!

module segCdec
(
	input [3:0] D,
	output segC
);
  

  
  //////////////////////////////////////////////////////
  // Write STRUCTURAL verilog to implement segment C //
  ////////////////////////////////////////////////////
  
  and D1_notD0_notD2(segC,D[1],~D[0],~D[2]);
  
  
endmodule
