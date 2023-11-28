module AHW3(clk,SW,KEY,LEDR,HR10,HR,MIN10,MIN,SEC10,SEC,TEN,HUND);

  input clk;				// 50MHz clock
  input [17:0] SW;			// slide switches
  input [3:0] KEY;			// push buttons (inc hr10,hr,min10,min)
  output [17:0] LEDR;		// Red LEDs above swithes
  output [6:0] HR10,HR;		// used to display hours
  output [6:0] MIN10,MIN;	// used to display minutes
  output [6:0] SEC10,SEC;	// used to display seconds
  output [6:0] TEN,HUND;	// used for fractional seconds
  
  wire RST_n;				// global reset
  wire accel_time;			// speed up time by 4096X
  wire inc_min,inc_min10;
  wire inc_hr,inc_hr10;
  wire [3:0] hundreths, tenths, seconds, seconds10;
  wire [3:0] minutes, minutes10, hours, hours10;
  
  assign RST_n = SW[17];
  assign accel_time = SW[16];
  

  assign LEDR = {SW[17],SW[16],14'h0000,SW[1:0]};
  
  
  ///////////////////////////////////////////////////
  // Instantiate rise_edge_detect as PB interface //
  /////////////////////////////////////////////////
  rise_edge_detect iKEY0(.clk(clk),.rst_n(RST_n),.sig(KEY[0]),.sig_rise(inc_min));
  rise_edge_detect iKEY1(.clk(clk),.rst_n(RST_n),.sig(KEY[1]),.sig_rise(inc_min10));
  rise_edge_detect iKEY2(.clk(clk),.rst_n(RST_n),.sig(KEY[2]),.sig_rise(inc_hr));
  rise_edge_detect iKEY3(.clk(clk),.rst_n(RST_n),.sig(KEY[3]),.sig_rise(inc_hr10));
		
  ////////////////////////////////////////////
  // Instantiate time_reg to drive display //
  //////////////////////////////////////////
  time_reg iTR(.clk(clk),.rst_n(RST_n),.enable(1'b1),.accel_time(accel_time),
               .inc_min(inc_min),.inc_min10(inc_min10),.inc_hr(inc_hr),
			   .inc_hr10(inc_hr10),.hundreths(hundreths),.tenths(tenths),
			   .seconds(seconds),.seconds10(seconds10),.minutes(minutes),
			   .minutes10(minutes10),.hours(hours),.hours10(hours10));
				
  ///////////////////////////////////////////////////////////
  // instantiate 8 copies of bcd7seg to drive time digits //
  /////////////////////////////////////////////////////////
  bcd7seg iBCD7(.num(hours10),.seg(HR10));
  bcd7seg iBCD6(.num(hours),.seg(HR));
  bcd7seg iBCD5(.num(minutes10),.seg(MIN10));
  bcd7seg iBCD4(.num(minutes),.seg(MIN));
  bcd7seg iBCD3(.num(seconds10),.seg(SEC10));
  bcd7seg iBCD2(.num(seconds),.seg(SEC));  
  bcd7seg iBCD1(.num(tenths),.seg(TEN));
  bcd7seg iBCD0(.num(hundreths),.seg(HUND));
  
endmodule
  
  