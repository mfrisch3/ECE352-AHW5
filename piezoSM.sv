/////////////////////////////////////////////////////////////
// piezoSM.sv: SM to control length and duration of alarm //
// notes                                                 //
//                                                      //
// Student 1 Name: << Enter you name here >>           //
// Student 2 Name: << Enter name if applicable >>     //
///////////////////////////////////////////////////////
module piezoSM(
  input clk,					// 50MHz clock
  input rst_n,					// asynch active low reset
  input start,				  	// starts alarm notes
  input stop,					// stop alarm
  input note_over,				// note duration timer expired
  output logic clr,				// clear freq_cnt & dur_cnt
  output logic [14:0] note_per, // period (inverse freq) of note
  output logic [7:0] note_dur,	// duration of note in 1/100ths of sec
  output logic [4:0] state		// output for debug (see LEDG[15:11]
);

  typedef enum reg [4:0] {IDLE=5'h01, NOTE1=5'h02, NOTE2=5'h04,
                         NOTE3=5'h08, PAUSE=5'h10} state_t;
						 
	///////////////////////////////
	// declare nxt_state signal //
	/////////////////////////////
	state_t nxt_state;
	
    //////////////////////////////
	// Instantiate state flops //
	////////////////////////////
	state5_reg iST(.clk(clk),.rst_n(rst_n),.nxt_state(nxt_state),.state(state));								 

	//////////////////////////////////////////////
	// State transitions and outputs specified //
	// next as combinational logic with case  //
	///////////////////////////////////////////		
	always_comb begin
		////////////////////////////////////////////
		// Default all SM outputs & nxt_state    //
		// OK...nxt_state has been done already //
		/////////////////////////////////////////
		nxt_state = state_t'(state);
         <<defaults>>
		
		case (state)
		  IDLE : if(start) begin
            next_state = NOTE1;
			note_dur = 8'h40;
			
		  end
		  NOTE1 : begin
		    << your magic here >>
		  end
		  NOTE2 : begin
		    << your magic here >>
		  end
		  NOTE3 : begin
		    << your magic here >>
		  end
		  default : begin			// this is same as PAUSE
		    << your magic here >>
		  end
		  
		endcase
		
	end	
endmodule