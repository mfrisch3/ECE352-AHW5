module piezoSM_tb();

  reg clk,rst_n;		// system clock and asynch active low reset
  reg error;			// not stimulus...used to keep track of if error occurred
  reg start;			// start alarm
  reg stop;				// stop alarm
  reg note_over;		// enter set_alarm state

  
  wire clr;				// should be asserted in IDLE
  wire [7:0] note_dur;	// note duration in 1/100th
  wire [14:0] note_per;	// note period in clks
  wire [4:0] state;		// state for monitoring

  ///////////////////////////
  // instantiate piezo SM //
  /////////////////////////
  piezoSM iDUT(.clk(clk),.rst_n(rst_n),.start(start),.stop(stop),
          .note_over(note_over),.clr(clr),.note_per(note_per),
		  .note_dur(note_dur),.state(state));	
	
  initial begin
    error = 0;		// innocent till proven guilty
    clk = 0;
	rst_n = 0;
	start = 0;
	stop = 0;
	note_over = 0;
	
	@(posedge clk);
	@(negedge clk);
	rst_n = 1;		// deassert reset
	
	@(negedge clk);
	if ((clr!==1) || (state!==5'h01)) begin
	  $display("ERR: Machine should be in IDLE and clr should be asserted");
	  error = 1;
	end	else $display("Check 0 passed");
	
	start = 1;
	@(negedge clk);
	if ((clr!==0) || (state!==5'h02)) begin
	  $display("ERR: Machine should be in NOTE1 and clr should be 0");
	  error = 1;
	end	else $display("Check 1 passed");
	@(negedge clk);
	if ((note_per!==15'h7C90) || (note_dur!==8'h40)) begin
	  $display("ERR: note_per should be 0x7C90 and note_dur should be 0x40");
	  error = 1;
	end	else $display("Check 2 passed");	
	
	note_over = 1;
	@(negedge clk);
	if (state!==5'h04) begin
	  $display("ERR: Machine should be in NOTE2");
	  error = 1;
	end	else $display("Check 3 passed");	
	if ((note_per!==15'h6Ef9) || (note_dur!==8'h20)) begin
	  $display("ERR: note_per should be 0x6EF9 and note_dur should be 0x20");
	  error = 1;
	end	else $display("Check 4 passed");
	
	@(negedge clk);
	if (state!==5'h08) begin
	  $display("ERR: Machine should be in NOTE3");
	  error = 1;
	end	else $display("Check 5 passed");	
	if ((note_per!==15'h62E4) || (note_dur!==8'h10)) begin
	  $display("ERR: note_per should be 0x62E4 and note_dur should be 0x10");
	  error = 1;
	end	else $display("Check 6 passed");
	
	/// check that it does not advance if note_over=0 ////
	note_over = 0;
	@(negedge clk);
	if (state!==5'h08) begin
	  $display("ERR: Machine should still be in NOTE3");
	  error = 1;
	end	else $display("Check 7 passed");

    /// Now check that stop takes us back to IDLE ///
    stop = 1;	
	@(negedge clk);
	if (state!==5'h01) begin
	  $display("ERR: All states should return to IDLE if stop asserted");
	  error = 1;
	end	else $display("Check 8 passed");	
	
	/// Now check pause "note" ///
	stop = 0;
	note_over = 1;
	repeat (4) @(negedge clk);
	if (state!==5'h10) begin
	  $display("ERR: state should be PAUSE at this time");
	  error = 1;
	end	else $display("Check 9 passed");
    if (note_dur[14]) begin
	  $display("ERR: state MSB of note_dur has to be 0 for piezo to be quiet");
	  error = 1;
	end	else $display("Check 10 passed");	
	
	@(negedge clk);
	if (state!==5'h02) begin
	  $display("ERR: state should return to NOTE1 after PAUSE");
	  error = 1;
	end	else $display("Check 11 passed");
	
	if (!error)
	  $display("YAHOO!! test of piezoSM passed!");
	$stop();
	
  end
  
  always
    #10 clk = ~clk;
	
endmodule