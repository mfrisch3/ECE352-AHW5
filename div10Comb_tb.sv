module div10Comb_tb();

  reg [3:0] cnt;
  
  wire [3:0] nxt_cnt;
  wire ten;
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  div10Comb iDUT(.cnt(cnt), .nxt_cnt(nxt_cnt), .ten(ten));
  
  initial begin
    cnt = 4'h0;
	#5;
	if (nxt_cnt!==4'h1) begin
	  $display("ERR: Increment of 0x0 should be 0x1");
	  $stop();
	end
	if (ten!==1'b0) begin
	  $display("ERR: ten should be 0");
	  $stop();
	end
	$display("GOOD: passed first test");
	
	cnt = 4'h8;
	#5;
	if (nxt_cnt!==4'h9) begin
	  $display("ERR: Increment of 0x8 should be 0x9");
	  $stop();
	end
	if (ten!==1'b0) begin
	  $display("ERR: ten should be 0");
	  $stop();
	end
	$display("GOOD: passed second test");
	
	cnt = 4'h9;
	#5;
	if (nxt_cnt!==4'h0) begin
	  $display("ERR: Count shoud reset at 0x9");
	  $stop();
	end
	if (ten!==1'b1) begin
	  $display("ERR: ten should be 1");
	  $stop();
	end
	$display("Yahoo! all tests passed!");
	$stop();
  end
  
endmodule
  