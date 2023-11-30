/////////////////////////////////////////////////////////
// piezo_freq_cnt.sv:  This design implements count   //
// register that generates note frequency for piezo  //
//                                                  //
// Student 1 Name: << Enter you name here >>       //
// Student 2 Name: << Enter name if applicable >> //
///////////////////////////////////////////////////
module piezo_freq_cnt(
  input clk,				// 50MHz clock
  input rst_n,				// asynch active low reset
  input clr,				// clear freq_cnt
  input [14:0] note_per,	// period of note (15-bits)
  output piezo,piezo_n
);

  ///////////////////////////////////////
  // Declare any needed internal nets //
  /////////////////////////////////////
 logic [14:0] freq_cnt;
 logic [14:0] next_counter; 

  ////////////////////////////////////////////////////
  // Implement comb logic that increments freq_cnt //
  // or clears it if clr or freq_cnt==note_per.   //
  // Use dataflow (assign statement) verilog     //
  ////////////////////////////////////////////////
  // Internal counter variable

	always_comb begin
	  if (clr) 
		next_counter = 15'h0000;
	  else if (freq_cnt == note_per) 
		next_counter = 15'h0000;
	  else 
		next_counter = freq_cnt + 1;
	end
  ///////////////////////////////////////////////////////////////////
  // instantiate 15 d_ff as a vector to realize freq_cnt register //
  /////////////////////////////////////////////////////////////////
  d_ff freq_cntr[14:0 ] (.clk(clk),.D(next_counter),.CLRN(rst_n),.PRN(1'b1),.Q(freq_cnt));
  
  

  /////////////////////////////////////
  // piezo is simply freq_cnt[14] & //
  // piezo_n is inverse of that.   //
  //////////////////////////////////
  assign piezo = freq_cnt[14]; 
  assign piezo_n = ~piezo;


endmodule
	  