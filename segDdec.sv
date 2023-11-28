// note that this is NOT a program - it is a hardware description that gets turned into logic!

module segDdec
(
	input [3:0] D,
	output segD
);
  logic n1, n2, n3;

  //////////////////////////////////////////////////////
  // Write STRUCTURAL verilog to implement segment C //
  ////////////////////////////////////////////////////
  
  and notD1_notD0_D2(n1,~D[1],~D[0],D[2]);
  and notD1_D0_notD2(n2,~D[1],D[0],~D[2]);
  and D1_D0_D2(n3,D[1],D[0],D[2]);
  or n1_OR_n2_OR_n3(segD,n1,n2,n3);

endmodule
