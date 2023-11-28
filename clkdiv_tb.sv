module clkdiv_tb();

  reg clk,rst_n;
  integer indx;
  
  wire hundrethSec;
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  clkdiv iDUT(.clk(clk), .rst_n(rst_n), .hundrethSec(hundrethSec));
  
  initial begin
    rst_n = 0;
	clk = 0;
	@(negedge clk);
	rst_n = 1;
	
	$display("INFO: running loop to 499998");
	for (indx=0; indx<499998; indx++) begin
	  @(negedge clk);
	  if (hundrethSec!==1'b0) begin
	    $display("ERR: at time %t hundrethSec should be 0",$time);
		$stop();
	  end
	end
	$display("GOOD: Loop check passed");
	@(negedge clk);
	if (hundrethSec!==1'b1) begin
	  $display("ERR: at time %t hundrethSec should be 1",$time);
	  $stop();
	end
	$display("GOOD: one last check");

	@(negedge clk);
	if (hundrethSec!==1'b0) begin
	  $display("ERR: at time %t hundrethSec should return to 0",$time);
	  $stop();
	end
	$display("YAHOO! all tests pass");	
	$stop();
  end
  
  always
    #5 clk = ~ clk;		// keep clock toggling
  
endmodule
  