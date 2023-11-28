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
  

  ////////////////////////////////////////////////////
  // Implement comb logic that increments freq_cnt //
  // or clears it if clr or freq_cnt==note_per.   //
  // Use dataflow (assign statement) verilog     //
  ////////////////////////////////////////////////
  
  
  
  ///////////////////////////////////////////////////////////////////
  // instantiate 15 d_ff as a vector to realize freq_cnt register //
  /////////////////////////////////////////////////////////////////
  
  
  

  /////////////////////////////////////
  // piezo is simply freq_cnt[14] & //
  // piezo_n is inverse of that.   //
  //////////////////////////////////
  
  
endmodule
	  