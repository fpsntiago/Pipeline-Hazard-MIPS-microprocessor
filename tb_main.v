`timescale 1ns / 1ps

//========== Testbench ==========//
module tb_main;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire [31:0] resultW;

	// Instantiate the Unit Under Test (UUT)
	main uut (
		.clk(clk), 
		.rst(rst), 
		.resultW(resultW)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Add stimulus here
		@(posedge clk) rst = 0;
	end
	
	always #5 clk = ~clk;	//clock input
      
endmodule

