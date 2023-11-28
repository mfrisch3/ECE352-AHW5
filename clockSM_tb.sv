module clockSM_tb();

  reg clk,rst_n;		// system clock and asynch active low reset
  reg error;			// not stimulus...used to keep track of if error occurred
  reg set_time;			// enter SET_TM state
  reg stop_watch;		// enter SWx states
  reg set_alarm;		// enter set_alarm state
  reg PB0;				// used to start/stop stop watch
  
  wire enable_time;		// enables clock reg
  wire enable_sw;		// enables SW timer
  wire sel_sw;			// selects stop watch to be displayed
  wire sel_alarm;		// enables alarm set to be displayed
  wire en_time_chng;	// enables PBs to adjust time setting
  wire en_alarm_chng;	// enables PBs to adjust alarm setting
  wire [5:0] out_vec;	// output vector of SM
  
  assign out_vec = {enable_time,enable_sw,sel_sw,sel_alarm,
                    en_time_chng,en_alarm_chng};
						   
  //////////////////////
  // Instantiate DUT //
  //////////////////// 
  clockSM iCNTRL(.clk(clk),.rst_n(rst_n),.set_time(set_time),.stop_watch(stop_watch),
                 .set_alarm(set_alarm),.strtStp(PB0),.enable_time(enable_time),
				 .enable_sw(enable_sw),.sel_sw(sel_sw),.sel_alarm(sel_alarm),
				 .en_time_chng(en_time_chng),.en_alarm_chng(en_alarm_chng),
				 .state());	
	
  initial begin
    error = 0;		// innocent till proven guilty
    clk = 0;
	rst_n = 0;
	set_time = 0;
	stop_watch = 0;
	set_alarm = 0;
	PB0 = 0;
	
	@(posedge clk);
	@(negedge clk);
	rst_n = 1;		// deassert reset
	if (out_vec!==6'b100000) begin
	  $display("ERR: Only enable_time should be asserted from SM");
	  error = 1;
	end	else $display("Check 0 passed");
	
	////////////////////////////////////////////////////////////
	// At first we will just check state does not transition //
	//////////////////////////////////////////////////////////
	@(negedge clk);
	if (out_vec!==6'b100000) begin
	  $display("ERR: Only enable_time should be asserted from SM");
	  error = 1;
	end	else $display("Check 1 passed");
	
	/////////////////////////
	// Now check set_time //
	///////////////////////	
	set_time = 1;		// enter SET_TM
	@(negedge clk);
	if (out_vec!==6'b000010) begin
	  $display("ERR: at time %t enable_time should be low and",$time);
	  $display("     en_time_chng should be high");
	  error = 1;
	end	else $display("Check 2 passed");
	
	set_time = 0;		// see that we stay in this state
	@(negedge clk);
	if (out_vec!==6'b000010) begin
	  $display("ERR: at time %t enable_time should be low and",$time);
	  $display("     en_time_chng should be high");
	  error = 1;
	end	else $display("Check 3 passed");	
	
	set_time = 1;		// should toggle us back to CLOCK state
	@(negedge clk);
	if (out_vec!==6'b100000) begin
	  $display("ERR: At time %t only enable_time should be asserted from SM",$time);
	  error = 1;
	end	else $display("Check 4 passed");	

	//////////////////////////
	// Now check set_alarm //
	////////////////////////		
	set_time = 0;
	set_alarm = 1;
	@(negedge clk);
	if (out_vec!==6'b100101) begin
	  $display("ERR: at time %t enable_time should be high and",$time);
	  $display("     sel_alarm & en_alarm_chng should be high");
	  error = 1;
	end	else $display("Check 5 passed");
	
	set_alarm = 0;		// see that we stay in this state
	@(negedge clk);
	if (out_vec!==6'b100101) begin
	  $display("ERR: at time %t enable_time should be high and",$time);
	  $display("     sel_alarm & en_alarm_chng should be high");
	  error = 1;
	end	else $display("Check 6 passed");

	set_alarm = 1;		// should toggle us back to CLOCK state
	@(negedge clk);
	if (out_vec!==6'b100000) begin
	  $display("ERR: At time %t only enable_time should be asserted from SM",$time);
	  error = 1;
	end	else $display("Check 7 passed");	
	
	///////////////////////////
	// Now check stop_watch //
	/////////////////////////
    set_alarm = 0;	
	stop_watch = 1;
	@(negedge clk);
	if (out_vec!==6'b101000) begin
	  $display("ERR: at time %t enable_time should be high and",$time);
	  $display("     sel_sw should be high");
	  error = 1;
	end	else $display("Check 8 passed");
	
	stop_watch = 0;		// see that we stay in this state
	@(negedge clk);
	if (out_vec!==6'b101000) begin
	  $display("ERR: at time %t enable_time should be high and",$time);
	  $display("     sel_sw should be high");
	  error = 1;
	end	else $display("Check 9 passed");
	
	///////////////////
	// Now start SW //
	/////////////////
	PB0 = 1;
	@(negedge clk);
	if (out_vec!==6'b111000) begin
	  $display("ERR: at time %t enable_time should be high and",$time);
	  $display("     enable_sw & sel_sw should be high");
	  error = 1;
	end	else $display("Check 10 passed");

	PB0 = 0;		// see that we stay in this state
	@(negedge clk);
	if (out_vec!==6'b111000) begin
	  $display("ERR: at time %t enable_time should be high and",$time);
	  $display("     enable_sw & sel_sw should be high");
	  error = 1;
	end	else $display("Check 11 passed");	

	PB0 = 1;		// stop stop watch and return to SW1
	@(negedge clk);	
	if (out_vec!==6'b101000) begin
	  $display("ERR: at time %t enable_time should be high and",$time);
	  $display("     sel_sw should be high");
	  error = 1;
	end	else $display("Check 12 passed");
	
	PB0 = 0;
	stop_watch = 1;		// should toggle us back to CLOCK state
	@(negedge clk);
	if (out_vec!==6'b100000) begin
	  $display("ERR: At time %t only enable_time should be asserted from SM",$time);
	  error = 1;
	end	else $display("Check 13 passed");	
	
	//////////////////////////////////////////////////////////////////////////
	// Finally ensure we can return to CLOCK state from stop watch running //
	////////////////////////////////////////////////////////////////////////
	stop_watch = 1;
	@(negedge clk);
	stop_watch = 0;
	PB0 = 1;
	@(negedge clk);
	PB0 = 0;
	stop_watch = 1;
	@(negedge clk);
	if (out_vec!==6'b100000) begin
	  $display("ERR: At time %t only enable_time should be asserted from SM",$time);
	  error = 1;
	end	else $display("Check 14 passed");	
	
	if (!error)
	  $display("YAHOO!! test of clockSM passed!");
	$stop();
	
  end
  
  always
    #10 clk = ~clk;
	
endmodule