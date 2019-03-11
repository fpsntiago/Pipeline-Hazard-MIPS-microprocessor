//========== PC Adder ==========//
//increments program counter
module pcAdder(
	input [31:0] in,	//current instruction address
	output [31:0] out //next instruction address
	);

assign out = in + 32'd1;	//address incremented by 1

endmodule
