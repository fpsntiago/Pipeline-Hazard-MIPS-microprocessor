//========== Sign Extension Module ==========//
//
module signExtend(
	input [15:0] in,	//16-bit immediate
	output [31:0] out		//32-bit sign-extended immediate
	);
							
assign out = {{16{in[15]}} , in};	//uses replication to sign-extend

endmodule
