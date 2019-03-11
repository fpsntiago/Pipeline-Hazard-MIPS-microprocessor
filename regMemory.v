//========== Memory Register ==========//
//inputs at execute stage, outputs at memory stage
module regMemory(
	input clk, 
	input rst,
	input regWriteE, 
	input memToRegE, 
	input memWriteE, 
	input [31:0] aluOutE, 
	input [31:0] writeDataE, 
	input [4:0] writeRegE,
	output reg regWriteM, 
	output reg memToRegM, 
	output reg memWriteM, 
	output reg [31:0] aluOutM, 
	output reg [31:0] writeDataM, 
	output reg [4:0] writeRegM
	);

always @(posedge clk) begin
	if (rst) begin
		regWriteM <= 0;
		memToRegM <= 0;
		memWriteM <= 0;
		aluOutM <= 0;
		writeDataM <= 0;
		writeRegM <= 0;
	end
	else begin
		regWriteM <= regWriteE;
		memToRegM <= memToRegE;
		memWriteM <= memWriteE;
		aluOutM <= aluOutE;
		writeDataM <= writeDataE;
		writeRegM <= writeRegE;
	end
end

endmodule
