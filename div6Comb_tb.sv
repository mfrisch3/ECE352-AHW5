module div6Comb_tb();

  reg [3:0] cnt;
  
  wire [3:0] nxt_cnt;
  wire six;
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  div6Comb iDUT(.cnt(cnt), .nxt_cnt(nxt_cnt), .six(six));
  
  initial begin
    cnt = 4'h0;
	#5;
	if (nxt_cnt!==4'h1) begin
	  $display("ERR: Increment of 0x0 should be 0x1");
	  $stop();
	end
	if (six!==1'b0) begin
	  $display("ERR: six should be 0");
	  $stop();
	end
	$display("GOOD: passed first test");
	
	cnt = 4'h4;
	#5;
	if (nxt_cnt!==4'h5) begin
	  $display("ERR: Increment of 0x4 should be 0x5");
	  $stop();
	end
	if (six!==1'b0) begin
	  $display("ERR: six should be 0");
	  $stop();
	end
	$display("GOOD: passed second test");
	
	cnt = 4'h5;
	#5;
	if (nxt_cnt!==4'h0) begin
	  $display("ERR: Count shoud reset at 0x5");
	  $stop();
	end
	if (six!==1'b1) begin
	  $display("ERR: six should be 1");
	  $stop();
	end
	$display("Yahoo! all tests passed!");
	$stop();
  end
  
endmodule
  