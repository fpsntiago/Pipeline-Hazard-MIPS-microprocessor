//========== Branch Adder ==========//
//adds branch offset to PC input
module branchAdder(
	input [31:0] signImm,	//branch offset
	input [31:0] pcPlus4,	//PC address output
	output [31:0] pcBranch	//branch address
	);
				 
assign pcBranch = signImm + pcPlus4; //calculating next instruction

endmodule
