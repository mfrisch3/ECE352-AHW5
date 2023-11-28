////////////////////////////////////////////////////////////
// state5_reg.sv:  This design implements state register //
//                                                      //
// Student 1 Name: << Enter you name here >>           //
// Student 2 Name: << Enter name if applicable >>     //
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
// Forms a 5-bit state register that will be one hot.   //
// Meaning it needs to aynchronously reset to 5'b00001 //
////////////////////////////////////////////////////////
module state5_reg(
  input clk,				// clock
  input rst_n,				// asynchronous active low system reset
  input [4:0] nxt_state,	// forms next state (i.e. goes to D input of FFs)
  output [4:0] state		// output (current state)
);
  
  ////////////////////////////////////////////////////
  // Declare any needed internal signals.  Due to  //
  // all bits except LSB needed to reset, and the //
  // LSB needing to preset you will need to form //
  // two 5-bit vectors to hook to CLRN and PRN  //
  ///////////////////////////////////////////////
  logic [4:0]  CLRN ;   // Active low clear
  logic [4:0]  PRN ;    // Active high preset
  
  ///////////////////////////////////////////////////////////
  // The two 5-bit vectors for CLRN & PRN are formed with //
  // vector concatenation of a mix of rst_n and 1'b1     //
  ////////////////////////////////////////////////////////
 assign CLRN[4:0] =  {rst_n,rst_n, rst_n, rst_n, 1'b1};
 assign PRN[4:0] = {1'b1, 1'b1, 1'b1, 1'b1, rst_n};
  ////////////////////////////////////////////////////////
  // instantiate 5 d_ff as a vector to implement state //
  //////////////////////////////////////////////////////
  d_ff d_ff5[4:0](.clk(clk), .D(nxt_state), .CLRN(CLRN), .PRN(PRN), .Q(state));

 

endmodule