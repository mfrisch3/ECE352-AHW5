module div3_tb();

  reg clk,rst_n;
  reg [4:0] indx;
  reg en;
  
  wire inc_nxt;
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  div3 iDUT(.clk(clk), .rst_n(rst_n), .en(en), .cnt(), .inc_nxt(inc_nxt));
  
  initial begin
    rst_n = 0;
	clk = 0;
	en = 1;	
	@(negedge clk);
	rst_n = 1;
	
    @(negedge clk);
	if (inc_nxt!==1'b0) begin
	  $display("ERR: at time %t inc_nxt should be 0",$time);
	  $stop();
	end	
	$display("GOOD: test1 passed");
	
	@(negedge clk);
	if (inc_nxt!==1'b1) begin
	  $display("ERR: at time %t inc_nxt should be 1",$time);
	  $stop();
	end
	$display("GOOD: test2 passed");

	@(negedge clk);
	if (inc_nxt!==1'b0) begin
	  $display("ERR: at time %t inc_nxt should return to 0",$time);
	  $stop();
	end
	$display("YAHOO! all tests pass");	
	$stop();
  end
  
  always
    #5 clk = ~ clk;		// keep clock toggling
  
endmodule
  