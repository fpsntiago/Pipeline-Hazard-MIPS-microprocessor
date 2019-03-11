//========== Instruction Memory ==========//
//reads instructions
module instructionMemory(
	input [31:0] A,	//address input
	output [31:0] RD	//read data output
	);

reg [31:0] iMem [0:63]; //32-bit by 64-element

//load intructions
initial begin
	$readmemh ("instructions.txt", iMem);
end

assign RD = iMem[A]; //read address A

endmodule
