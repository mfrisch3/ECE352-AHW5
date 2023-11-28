///////////////////////////////////////////////////
// FA.sv  This design will take in 3 bits       //
// and add them to produce a sum and carry out //
////////////////////////////////////////////////
module FA(
  input 	A,B,Cin,	// three input bits to be added
  output	S,Cout		// Sum and carry out
);

	/////////////////////////////////////////////////
	// Declare any internal signals as type logic //
	///////////////////////////////////////////////
	logic axorb, aandb, and2;
	
	/////////////////////////////////////////////////
	// Implement Full Adder as structural verilog //
	///////////////////////////////////////////////
	xor inst7 (axorb, A,B)	;
	and inst (aandb, A,B);
	xor inst8 (S,axorb, Cin);
	and inst6 (and2,axorb, Cin);
	or OR2(Cout, and2,aandb);
	
endmodule