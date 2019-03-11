//========== Equality Comparator ==========//
//compares the values of two registers
module comparator(
	input [31:0] a,	//register 1 value
	input [31:0] b,	//register 2 value
	output out	//equal-or-not output
    );

assign out = (a == b);	//returns 1 if equal

endmodule
