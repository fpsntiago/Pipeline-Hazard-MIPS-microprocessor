//========== Writeback Register ==========//
//inputs at memory stage, outputs at writeback stage
module regWriteback(
	input clk, 
	input rst,
	input regWriteM, 
	input memToRegM, 
	input [31:0] aluOutM, 
	input [31:0] readDataM, 
	input [4:0] writeRegM,
	output reg regWriteW, 
	output reg memToRegW, 
	output reg [31:0] aluOutW, 
	output reg [31:0] readDataW, 
	output reg [4:0] writeRegW);

always @(posedge clk) begin
	if (rst) begin
		regWriteW <= 0;
		memToRegW <= 0;
		aluOutW <= 0;
		readDataW <= 0;
		writeRegW <= 0;
	end
	else begin
		regWriteW <= regWriteM;
		memToRegW <= memToRegM;
		aluOutW <= aluOutM;
		readDataW <= readDataM;
		writeRegW <= writeRegM;
	end
end

endmodule
