/////////////////////////////////////////////////////////
// piezo_dur_cnt.sv:  This design implements a period //
// counter to control duration of piezo note         //
//                                                  //
// Student 1 Name: << Matt Frisch >>       //
// Student 2 Name: << Enter name if applicable >> //
///////////////////////////////////////////////////
module piezo_dur_cnt(
  input clk,				// 50MHz clock
  input rst_n,				// asynch active low reset
  input clr,				// clear dur_cnt
  input en,					// enable pulsed high at 0.01 period
  input [7:0] note_dur,		// duration of note in 1/100th of sec
  output note_over
);

  ///////////////////////////////////////
  // Declare any needed internal nets //
  /////////////////////////////////////
  logic [7:0] next_state;

  logic [7:0] duration_cnt;
  logic [7:0] note_over_sig; 


  ////////////////////////////////////////////////////
  // Implement comb logic that increments dur_cnt  //
  // or clears it if clr or freq_cnt==note_per.   //
  // Use dataflow (assign statement) verilog     //
  ////////////////////////////////////////////////
  	always_comb begin
	
	  note_over_sig = 1'b0; //Defualt Values
	  next_state = 15'h0000;
	  
	  if (clr)
		next_state = 15'h0000;
	  else if (duration_cnt == note_dur)begin 
		note_over_sig = 1'b1;
		end
	  else 
		next_state = duration_cnt + 1;
	  
	end
  
  
  ////////////////////////////////////////////////////////////////////
  // instantiate 8 d_en_ff as a vector to realize dur_cnt register //
  //////////////////////////////////////////////////////////////////
  
  d_en_ff durationReg[7:0](.clk(clk), .D(next_state), .CLRN(rst_n), .EN(en), .Q(duration_cnt));
  

  //////////////////////////////////////////
  // note_over is when dur_cnt==note_dur //
  ////////////////////////////////////////
  assign note_over =note_over_sig;
  
endmodule
	  