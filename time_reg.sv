/////////////////////////////////////////
// Forms a full time register for AHW //
// This is a provided file.          //
//////////////////////////////////////
module time_reg(
  input clk,				// 50MHz
  input rst_n,				// asynch active low
  input enable,				// enable increment of time register
  input accel_time,			// for testing...time runs 4096x faster
  input inc_min,			// increment min of alarm
  input inc_min10,			// increment 10min of alarm
  input inc_hr,				// increment hour of alarm
  input inc_hr10,			// increment 10hour of alarm
  output hundrethSec,		// pulses 1 clk every 1/100th sec
  output [3:0] hundreths,	// hundreth seconds digit value
  output [3:0] tenths,		// tenth seconds digit value
  output [3:0] seconds,		// seconds digit value
  output [3:0] seconds10,	// 10 second digit value
  output [3:0] minutes,		// minute digit value
  output [3:0] minutes10,	// 10 minute digit value
  output reg [3:0] hours,	// hour digit value
  output [3:0] hours10		// 10 hour digit value
);
  
  wire hundrethSec4096,hundreth,inc_hundreth;
  wire inc_tenth,inc_sec,inc_sec10;
  wire inc_min_auto,inc_min10_auto,inc_hr_auto,inc_hr10_auto;
  wire inc_min_qual,inc_min10_qual,inc_hr_qual,inc_hr10_qual;
  
  /////////////////////////////////////////////
  // Instantiate clkdiv that produces pulse //
  // every 1/100th second from 50MHz clock //
  //////////////////////////////////////////
  clkdiv iTB(.clk(clk), .rst_n(rst_n), .hundrethSec(hundrethSec));
  
  /////////////////////////////////////////////////////
  // Instantiate clkdiv4096 for accelerated testing //
  ///////////////////////////////////////////////////
  clkdiv4096 iTBf(.clk(clk), .rst_n(rst_n), .hundrethSec4096(hundrethSec4096));
  
  /// mux to choose timebase (accelerated or not) ///
  assign hundreth = (accel_time) ? hundrethSec4096 : hundrethSec;
  assign inc_hundreth = hundreth & enable;
  
  ///////////////////////////////////////////
  // Instantiate div10 for hundreth digit //
  /////////////////////////////////////////
  div10 iHUND(.clk(clk), .rst_n(rst_n), .en(inc_hundreth), .cnt(hundreths),
             .inc_nxt(inc_tenth));
			 
  /////////////////////////////////////////
  // Instantiate div10 for tenths digit //
  ///////////////////////////////////////
  div10 iTEN(.clk(clk), .rst_n(rst_n), .en(inc_tenth), .cnt(tenths),
            .inc_nxt(inc_sec));			 
 
  //////////////////////////////////////////
  // Instantiate div10 for seconds digit //
  ////////////////////////////////////////
  div10 iSEC(.clk(clk), .rst_n(rst_n), .en(inc_sec), .cnt(seconds),
            .inc_nxt(inc_sec10)); 
 
  ////////////////////////////////////////////
  // Instantiate div6 for 10 seconds digit //
  //////////////////////////////////////////
  div6 iSEC10(.clk(clk), .rst_n(rst_n), .en(inc_sec10), .cnt(seconds10),
              .inc_nxt(inc_min_auto));

  assign inc_min_qual = inc_min | inc_min_auto;
  //////////////////////////////////////////
  // Instantiate div10 for minutes digit //
  ////////////////////////////////////////
  div10 iMIN(.clk(clk), .rst_n(rst_n), .en(inc_min_qual), .cnt(minutes),
             .inc_nxt(inc_min10_auto));			  

  assign inc_min10_qual = inc_min10 | inc_min10_auto;
  ////////////////////////////////////////////
  // Instantiate div6 for 10 minutes digit //
  //////////////////////////////////////////
  div6 iMIN10(.clk(clk), .rst_n(rst_n), .en(inc_min10_qual), .cnt(minutes10),
              .inc_nxt(inc_hr_auto));			  
  
  assign inc_hr_qual = inc_hr | inc_hr_auto;
  /////////////////////////////////////////////////////////////////////
  // Hours digit handled separate just to avoid yet another divider //
  ///////////////////////////////////////////////////////////////////
  always_ff @(posedge clk, negedge rst_n)
    if (!rst_n)
	  hours <= 4'h0;
	else if ((hours10==4'h2) && (hours==4'h3) && inc_hr_qual)
	  hours <= 4'h0;	// wrap to midnight
	else if (inc_hr_qual && (hours==4'h9))
	  hours <= 4'h0;
	else if (inc_hr_qual)
	  hours <= hours + 1;
	
  assign inc_hr10_auto = ((hours10==4'h2) && (hours==4'h3) && inc_hr_qual) ? 1'b1 :
                         (inc_hr_qual && (hours==4'h9)) ? 1'b1 : 1'b0;  
  assign inc_hr10_qual = inc_hr10 | inc_hr10_auto;
  //////////////////////////////////////////
  // Instantiate div3 for 10 hours digit //
  ////////////////////////////////////////
  div3 iHR10(.clk(clk), .rst_n(rst_n), .en(inc_hr10_qual), .cnt(hours10),
             .inc_nxt());
			 
endmodule
  
  