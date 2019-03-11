//========== Arithmetic and Logic Unit ==========//
//inputs at fetch stage, outputs at decode stage
module ALU(
	input signed [31:0] srcA,	//ALU input A
	input signed [31:0] srcB,	//ALU input B
	input [2:0] aluControl,	//specifies ALU operation
	output reg signed [31:0] aluResult		//result of operation
	);

always @* begin
	case (aluControl)
		3'b000 : aluResult = srcA & srcB;	//and
		3'b001 : aluResult = srcA | srcB;	//or
		3'b010 : aluResult = srcA + srcB;	//add
		//011 is not an aluControl code
		3'b100 : aluResult = srcA & ~srcB;	//nand
		3'b101 : aluResult = srcA | ~srcB;	//nor
		3'b110 : aluResult = srcA - srcB;	//sub
		3'b111 : aluResult = (srcA < srcB) ? 1: 0;	//slt
		default : aluResult = 32'bx;
	endcase
end

endmodule
