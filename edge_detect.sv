/////////////////////////////////////////////////////////
// rise_edge_detect.sv:  This design implements a     //
// circuit that interfaces to a PB swtich and  	     //
// gives a 1 clk wide puse on a rise of the signal. //
//                                                 //
// Student 1 Name: << Enter you name here >>      //
// Student 2 Name: << Enter name if applicable >>//
//////////////////////////////////////////////////
module edge_detect(
  input clk,			// hook to CLK of flops
  input rst_n,			// hook to PRN
  input sig,			// signal we are detecting a rising edge on
  output sig_chng		// high for 1 clock cycle on rise of sig
);

	//////////////////////////////////////////
	// Declare any needed internal signals //
	////////////////////////////////////////
	logic ff1_output;
	logic ff2_output;
	logic last_sig;
	
	
	///////////////////////////////////////////////////////
	// Instantiate flops to synchronize and edge detect //
	/////////////////////////////////////////////////////
	d_ff flipflop1(.clk(clk), .D(sig), .CLRN(rst_n), .PRN(1'b1), .Q(ff1_output));
	d_ff flipflop2(.clk(clk), .D(ff1_output), .CLRN(rst_n), .PRN(1'b1), .Q(ff2_output));
	d_ff flipflop3(.clk(clk), .D(ff2_output), .CLRN(rst_n), .PRN(1'b1), .Q(last_sig));
	
	xor lastsigXOR(sig_chng, last_sig, ff2_output);
	
    
	//////////////////////////////////////////////////////////
	// Infer any needed logic (data flow) to form sig_rise //
	////////////////////////////////////////////////////////
    	
	
endmodule