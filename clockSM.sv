///////////////////////////////////////////////////////////////
// clockSM.sv:  This design implements control SM for clock //
//                                                         //
// Student 1 Name: << Enter you name here >>              //
// Student 2 Name: << Enter name if applicable >>        //
//////////////////////////////////////////////////////////
module clockSM(
  input clk,					// 50MHz clock
  input rst_n,					// asynch active low reset
  input set_time,				// pulses high upon a rise of SW[0]
  input stop_watch,				// pulses high upon a rise of SW[1]
  input set_alarm, 				// pulses high upon a rise of SW[2]
  input strtStp,				// starts/stop stop watch
  output logic enable_time,		// enables time register to run
  output logic enable_sw,		// enables stop watch to run
  output logic sel_sw,			// selects stop watch to drive display
  output logic sel_alarm,		// select alarm set point to drive display
  output logic en_time_chng,	// enables PBs to allow time change
  output logic en_alarm_chng,	// enables PBs to allow alarm change
  output logic [4:0] state		// output for debug purposes
);

  typedef enum reg [4:0] {CLOCK=5'h01, SET_TM=5'h02, SET_ALRM=5'h04, 
                         SW1=5'h08, SW2=5'h10} state_t;
						 
	/////////////////////////////
	// declare state register //
	///////////////////////////
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
		/////////////////////////////////////////
		// Default all SM outputs & nxt_state //
		// (OK...nxt_state done for you)     //
		//////////////////////////////////////
		nxt_state = state_t'(state);
			//<< default all outputs of SM >>
			enable_time = 1'b1;
			enable_sw = 1'b0;
			en_time_chng =1'b0;
			en_alarm_chng = 1'b0;
			sel_alarm= 1'b0;
			sel_sw = 1'b0;
		case (state)
		  CLOCK : begin
            if(set_time)
				nxt_state = SET_TM;
			else if (set_alarm)
				nxt_state = SET_ALRM;
			else if(stop_watch)
				nxt_state = SW1;
			else if(rst_n)
				nxt_state = CLOCK;
		  end
		  SET_TM : begin
		    en_time_chng=1'b1;
			enable_time=1'b0;
			if(set_time)begin
				nxt_state = CLOCK;
			end
		  end
		  SET_ALRM : begin
		    en_alarm_chng =1'b1;
			sel_alarm = 1'b1;
			if(set_alarm)begin
				nxt_state = CLOCK;
			end
		  end
		  SW1 : begin
			sel_sw =1'b1;
			if(strtStp)
				nxt_state = SW2;
				else if (stop_watch)begin
					nxt_state = CLOCK;
				end
		  end
		  default : begin			// this is same as SW2
		    enable_sw = 1'b1;
			sel_sw = 1'b1;
			if(stop_watch)
				nxt_state =CLOCK;
			else if(strtStp)
				nxt_state = SW1;
		  end
		  
		endcase
		
	end	
endmodule