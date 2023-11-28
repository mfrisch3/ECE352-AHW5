module piezo_dur_cnt_tb();

  reg clk, rst_n;			// 50MHz clk and rst stimulus
  reg clr;					// synch clear stimulus
  reg en;					// enable
  reg [7:0] note_dur;		// note duration stimulus
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  piezo_dur_cnt iDUT(.clk(clk),.rst_n(rst_n),.clr(clr),.en(en),
                     .note_dur(note_dur),.note_over(note_over));
  
  initial begin
    clk = 0;
	rst_n = 0;
	clr = 0;
	en = 1;
	note_dur = 8'h08;
	
	@(negedge clk);
	rst_n = 1;			// deassert reset
	
	if (note_over!==1'b0) begin
	  $display("ERR: dur count should be zero now, note_over should be 0");
	  $stop();
	end	else $display("GOOD: 1st test passed");
	
	/////////////////////////////////////////
	// After 8 clks note_over should be 1 //
	///////////////////////////////////////
	repeat (8) @(negedge clk);
	if (note_over!==1'b1) begin
	  $display("ERR: dur count should be 8 now, note_over should be 1");
	  $stop();
	end	else $display("GOOD: 2nd test passed");
	
	//// test sync clr ////
	clr = 1;
	note_dur = 8'h01;
	@(negedge clk);		// dur_cnt at zero now
	if (note_over!==1'b0) begin
	  $display("ERR: dur count should be zero now, note_over should be 0");
	  $stop();
	end	else $display("GOOD: 3rd test passed");	
	clr = 0;
	
	@(negedge clk);		// dur_cnt at one now
	if (note_over!==1'b1) begin
	  $display("ERR: dur count should be one now, note_over should be 1");
	  $stop();
	end	else $display("GOOD: 4th test passed");

    //// test enable next ////
	en = 0;
	note_dur = 8'h06;
	repeat(3) @(negedge clk);
	if (note_over!==1'b0) begin
	  $display("ERR: dur count should be one now, note_over should be 0");
	  $stop();
	end	else $display("GOOD: 5th test passed");
	en = 1;
	
	repeat(5) @(negedge clk);
	if (note_over!==1'b1) begin
	  $display("ERR: note_over should be 1 now...is your enable working?");
	  $stop();
	end	else $display("GOOD: 6th test passed");
	
	//// test full count works ////
	note_dur = 8'hFF;
	repeat (249) @(negedge clk);
	if (note_over!==1'b1) begin
	  $display("ERR: note_over should be 255 now, and note_dur should be 1");
	  $stop();
	end	else $display("GOOD: 7th test passed");	
	
	  
	$display("YAHOO! all tests passed!");
	$stop();
  end
  
  always
    #5 clk = ~clk;		// keep clk toggling
endmodule