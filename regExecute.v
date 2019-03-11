//========== Execute Register ==========//
//inputs at decode stage, outputs at execute stage
module regExecute(
	input clk, 
	input rst, 
	input clr,	//flush signal
	input regWriteD, 
	input memToRegD, 
	input memWriteD, 
	input aluSrcD, 
	input regDstD,
	input [2:0] aluControlD,
	input [31:0] rd1D, 
	input [31:0] rd2D, 
	input [31:0] signImmD, 
	input [4:0] rsD,
	input [4:0] rtD,
	input [4:0] rdD,
	output reg regWriteE, 
	output reg memToRegE, 
	output reg memWriteE, 
	output reg aluSrcE, 
	output reg regDstE,
	output reg [2:0] aluControlE,
	output reg [31:0] rd1E, 
	output reg [31:0] rd2E, 
	output reg [31:0] signImmE, 
	output reg [4:0] rsE,
	output reg [4:0] rtE, 
	output reg [4:0] rdE);

always @(posedge clk) begin
	if (rst || clr) begin	//reset or flush
		regWriteE <= 0;
		memToRegE <= 0;
		memWriteE <= 0;
		aluSrcE <= 0;
		regDstE <= 0;
		aluControlE <= 0;
		rd1E <= 0;
		rd2E <= 0;
		signImmE <= 0;
		rsE <= 0;
		rtE <= 0;
		rdE <= 0;
	end
	else begin
		regWriteE <= regWriteD;
		memToRegE <= memToRegD;
		memWriteE <= memWriteD;
		aluSrcE <= aluSrcD;
		regDstE <= regDstD;
		aluControlE <= aluControlD;
		rsE <= rsD;
		rd1E <= rd1D;
		rd2E <= rd2D;
		signImmE <= signImmD;
		rtE <= rtD;
		rdE <= rdD;
	end
end

endmodule
