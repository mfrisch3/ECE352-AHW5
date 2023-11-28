module AHW4(clk,SW,KEY,LEDR,HR10,HR,MIN10,MIN,SEC10,SEC,TEN,HUND);

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
  wire PB0, PB1, PB2, PB3;	// push button pulse outputs
  wire inc_min,inc_min10;
  wire inc_hr,inc_hr10;
  wire inc_alrm_min,inc_alrm_min10;
  wire inc_alrm_hr,inc_alrm_hr10;
  wire [3:0] hundreths, tenths, seconds, seconds10;
  wire [3:0] minutes, minutes10, hours, hours10;
  wire [3:0] hundrethsT, tenthsT, secondsT, seconds10T;
  wire [3:0] minutesT, minutes10T, hoursT, hours10T;
  wire [3:0] minutesA, minutes10A, hoursA, hours10A;
  wire [3:0] hundrethsS, tenthsS, secondsS, seconds10S;
  wire [3:0] minutesS, minutes10S, hoursS, hours10S;
  wire set_time, stop_watch, set_alarm;
  wire alarm_on;
  wire [4:0] state_dbg;
  
  /// SM controls ///
  wire enable_time, enable_sw;
  wire sel_sw, sel_alarm;		// select which time_reg displayed
  wire en_time_chng, en_alarm_chng;		// gates PB inputs

  
  assign RST_n = SW[17];
  assign accel_time = SW[16];
  assign alarm_on = SW[3];

  assign LEDR = {SW[17],SW[16],7'h00,state_dbg,SW[3:0]};
  
  assign inc_min = en_time_chng & PB0;
  assign inc_min10 = en_time_chng & PB1;
  assign inc_hr = en_time_chng & PB2;
  assign inc_hr10 = en_time_chng & PB3;

  assign inc_alrm_min = en_alarm_chng & PB0;
  assign inc_alrm_min10 = en_alarm_chng & PB1;
  assign inc_alrm_hr = en_alarm_chng & PB2;
  assign inc_alrm_hr10 = en_alarm_chng & PB3;
  
  ///////////////////////////////////////////////////
  // Instantiate rise_edge_detect as PB interface //
  /////////////////////////////////////////////////
  rise_edge_detect iKEY0(.clk(clk),.rst_n(RST_n),.sig(KEY[0]),.sig_rise(PB0));
  rise_edge_detect iKEY1(.clk(clk),.rst_n(RST_n),.sig(KEY[1]),.sig_rise(PB1));
  rise_edge_detect iKEY2(.clk(clk),.rst_n(RST_n),.sig(KEY[2]),.sig_rise(PB2));
  rise_edge_detect iKEY3(.clk(clk),.rst_n(RST_n),.sig(KEY[3]),.sig_rise(PB3));

  ///////////////////////////////////////////////////////////////
  // Instantiate rise_edge_detect as SWs that control SM mode //
  /////////////////////////////////////////////////////////////
  edge_detect iSW0(.clk(clk),.rst_n(RST_n),.sig(SW[0]),.sig_chng(set_time));
  edge_detect iSW1(.clk(clk),.rst_n(RST_n),.sig(SW[1]),.sig_chng(stop_watch));
  edge_detect iSW2(.clk(clk),.rst_n(RST_n),.sig(SW[2]),.sig_chng(set_alarm));
 
  ////////////////////////////////////
  // Instantiate time_reg for time //
  //////////////////////////////////
  time_reg iTR(.clk(clk),.rst_n(RST_n),.enable(enable_time),.accel_time(accel_time),
               .inc_min(inc_min),.inc_min10(inc_min10),.inc_hr(inc_hr),
			   .inc_hr10(inc_hr10),.hundreths(hundrethsT),.tenths(tenthsT),
			   .seconds(secondsT),.seconds10(seconds10T),.minutes(minutesT),
			   .minutes10(minutes10T),.hours(hoursT),.hours10(hours10T));

  /////////////////////////////////////
  // Instantiate time_reg for alarm //
  ///////////////////////////////////
  time_reg iALRM(.clk(clk),.rst_n(RST_n),.enable(1'b0),.accel_time(accel_time),
               .inc_min(inc_alrm_min),.inc_min10(inc_alrm_min10),.inc_hr(inc_alrm_hr),
			   .inc_hr10(inc_alrm_hr10),.hundreths(),.tenths(),
			   .seconds(),.seconds10(),.minutes(minutesA),
			   .minutes10(minutes10A),.hours(hoursA),.hours10(hours10A));

  //////////////////////////////////////////
  // Instantiate time_reg for stop watch //
  ////////////////////////////////////////
  time_reg iSW(.clk(clk),.rst_n(~PB3),.enable(enable_sw),.accel_time(accel_time),
               .inc_min(1'b0),.inc_min10(1'b0),.inc_hr(1'b0),
			   .inc_hr10(1'b0),.hundreths(hundrethsS),.tenths(tenthsS),
			   .seconds(secondsS),.seconds10(seconds10S),.minutes(minutesS),
			   .minutes10(minutes10S),.hours(hoursS),.hours10(hours10S));

  ////////////////////////////////////////////////////////////////
  // Infer muxes muxing time_reg outputs to 7-segment displays //
  //////////////////////////////////////////////////////////////  
  assign hundreths = (sel_alarm) ? 4'h0 :
                     (sel_sw) ? hundrethsS :
					 hundrethsT;
  assign tenths = (sel_alarm) ? 4'h0 :
                  (sel_sw) ? tenthsS :
				  tenthsT;					 
  assign seconds = (sel_alarm) ? 4'h0 :
                   (sel_sw) ? secondsS :
				   secondsT;  
  assign seconds10 = (sel_alarm) ? 4'h0 :
                     (sel_sw) ? seconds10S :
				     seconds10T;  
  assign minutes = (sel_alarm) ? minutesA :
                   (sel_sw) ? minutesS :
				   minutesT;
  assign minutes10 = (sel_alarm) ? minutes10A :
                     (sel_sw) ? minutes10S :
				     minutes10T;
  assign hours = (sel_alarm) ? hoursA :
                 (sel_sw) ? hoursS :
				 hoursT;
  assign hours10 = (sel_alarm) ? hours10A :
                   (sel_sw) ? hours10S :
				   hours10T;
				   
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
 
  /////////////////////////////
  // instantiate control SM //
  /////////////////////////// 
  clockSM iCNTRL(.clk(clk),.rst_n(RST_n),.set_time(set_time),.stop_watch(stop_watch),
                 .set_alarm(set_alarm),.strtStp(PB0),.enable_time(enable_time),
				 .enable_sw(enable_sw),.sel_sw(sel_sw),.sel_alarm(sel_alarm),
				 .en_time_chng(en_time_chng),.en_alarm_chng(en_alarm_chng),
				 .state(state_dbg));
  
endmodule
  
  