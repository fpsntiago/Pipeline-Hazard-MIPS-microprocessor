//========== Decode Register ==========//
//inputs at fetch stage, outputs at decode stage
module regDecode(
	input clk,
	input rst, 
	input clr,	//flush signal
	input en,	//enable signal for stall
	input [31:0] instrF, 
	input [31:0] pcPlus4F,
	output reg [31:0] instrD, 
	output reg [31:0] pcPlus4D);
							
always @(posedge clk) begin
	if (rst || clr) begin	//reset or flush
		instrD <= 0;
		pcPlus4D <= 0;
	end
	else begin
		if (~en) begin		//stall when enable is low
			instrD <= instrF;
			pcPlus4D <= pcPlus4F;
		end
	end
end

endmodule
