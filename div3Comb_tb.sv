module div3Comb_tb();

  reg [3:0] cnt;
  
  wire [3:0] nxt_cnt;
  wire three;
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  div3Comb iDUT(.cnt(cnt), .nxt_cnt(nxt_cnt), .three(three));
  
  initial begin
    cnt = 4'h0;
	#5;
	if (nxt_cnt!==4'h1) begin
	  $display("ERR: Increment of 0x0 should be 0x1");
	  $stop();
	end
	if (three!==1'b0) begin
	  $display("ERR: three should be 0");
	  $stop();
	end
	$display("GOOD: passed first test");
	
	cnt = 4'h1;
	#5;
	if (nxt_cnt!==4'h2) begin
	  $display("ERR: Increment of 0x1 should be 0x2");
	  $stop();
	end
	if (three!==1'b0) begin
	  $display("ERR: three should be 0");
	  $stop();
	end
	$display("GOOD: passed second test");
	
	cnt = 4'h2;
	#5;
	if (nxt_cnt!==4'h0) begin
	  $display("ERR: Count shoud reset at 0x2");
	  $stop();
	end
	if (three!==1'b1) begin
	  $display("ERR: three should be 1");
	  $stop();
	end
	$display("Yahoo! all tests passed!");
	$stop();
  end
  
endmodule
  