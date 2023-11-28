module piezo_freq_cnt_tb();

  reg clk, rst_n;			// 50MHz clk and rst stimulus
  reg clr;					// synch clear stimulus
  reg [14:0] note_per;		// period of note's freq
  
  wire piezo, piezo_n;
  wire [14:0] pduty,pduty_n;		// piezo period high count
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  piezo_freq_cnt iDUT(.clk(clk),.rst_n(rst_n),.clr(clr),.note_per(note_per),
                      .piezo(piezo), .piezo_n(piezo_n));
  
  /////////////////////////////////////////////
  // Instantiate a monitor of piezo outputs //
  ///////////////////////////////////////////
  piezo_monitor iMON(.clk(clk), .rst_n(rst_n), .piezo(piezo),
                 .piezo_n(piezo_n), .pduty(pduty), .pduty_n(pduty_n));
  initial begin
    clk = 0;
	rst_n = 0;
	clr = 0;
	note_per = 15'h6000;
	
	@(negedge clk);
	rst_n = 1;			// deassert reset
	
	repeat (49152) @(negedge clk);
	if ((pduty>15'd8200) || (pduty<15'd8000)) begin
	  $display("ERR: piezo should be high for 8192 clks");
	  $stop();
	end	else $display("GOOD: 1st test check1 passed");
	if ((pduty_n>15'd16500) || (pduty_n<15'd16000)) begin
	  $display("ERR: piezo_n should be high for 16384 clks");
	  $stop();
	end	else $display("GOOD: 1st test check2 passed");
	
	clr = 1;							// piezo/piezo_n should stop toggling
	repeat (66000) @(negedge clk);
	if (pduty!==15'h0000) begin
	  $display("ERR: piezo should have stopped toggling");
	  $stop();
	end	else $display("GOOD: 2nd test passed");

    //// Test normal function again at different freq ////
    clr = 0;
	note_per = 15'h7000;
	repeat (49152) @(negedge clk);
	if ((pduty>15'd12300) || (pduty<15'd12200)) begin
	  $display("ERR: piezo should be high for 12288 clks");
	  $stop();
	end	else $display("GOOD: 3rd test check1 passed");
	if ((pduty_n>15'd16500) || (pduty_n<15'd16000)) begin
	  $display("ERR: piezo_n should be high for 16384 clks");
	  $stop();
	end	else $display("GOOD: 3rd test check2 passed");	
	
	$display("YAHOO! all tests passed!");
	$stop();
  end
  
  always
    #5 clk = ~clk;		// keep clk toggling
endmodule
				 
module piezo_monitor(clk,rst_n,piezo,piezo_n,pduty,pduty_n);

  input clk,rst_n;
  input piezo,piezo_n;	// signals being monitored
  output reg[14:0] pduty, pduty_n;
  
  ///////////////////////////////
  // declare needed registers //
  /////////////////////////////
  reg piezo_ff, piezo_n_ff;				// for edge detection
  reg [14:0] pduty_cnt, pduty_n_cnt;
  reg [15:0] timeout_cnt;
  
  //// Declare internal nets /////
  wire piezo_fall, piezo_n_fall;
  wire timeout;
  
  //// Edge detector on piezo /////
  always_ff @(posedge clk)
    piezo_ff <= piezo;
  assign piezo_fall = ~piezo & piezo_ff;

  //// Edge detector on piezo_n /////
  always_ff @(posedge clk)
    piezo_n_ff <= piezo_n;
  assign piezo_n_fall = ~piezo_n & piezo_n_ff;
  
  //// piezo duty counter ////
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n)
	  pduty_cnt <= 15'h0000;
	else if (timeout | piezo_fall)
	  pduty_cnt <= 15'h0000;
	else if (piezo)
	  pduty_cnt <= pduty_cnt + 1;

  //// piezo_n duty counter ////
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n)
	  pduty_n_cnt <= 15'h0000;
	else if (timeout | piezo_n_fall)
	  pduty_n_cnt <= 15'h0000;
	else if (piezo_n)
	  pduty_n_cnt <= pduty_n_cnt + 1;

  //// implement holding registers ////
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n)
      pduty <= 15'h0000;
    else if (timeout)
      pduty <= 15'h0000;
    else if (piezo_fall)
      pduty <= pduty_cnt;

  //// implement holding registers ////
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n)
      pduty_n <= 15'h0000;
    else if (timeout)
      pduty_n <= 15'h0000;
    else if (piezo_n_fall)
      pduty_n <= pduty_n_cnt;

  //// implement timeout in case no toggling ////
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n)
	  timeout_cnt <= 16'h0000;
	else if (piezo_fall | piezo_n_fall)
	  timeout_cnt <= 16'h0000;
	else timeout_cnt <= timeout_cnt + 1;
	
  assign timeout = &timeout_cnt; 
	  
endmodule