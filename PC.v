//========== Program Counter ==========//
//determines address of current and next instructions
module PC(
	input clk,	//clock
	input rst,	//reset
	input en,	//enable signal for stall
	input [31:0] in,	//indicates address of next instruction
	output reg [31:0] out	//points to the current instruction
	);

//counter
always @(posedge clk) begin
	if (rst) out <= 32'd0;
	else if (~en) out <= in;	//stall when enable is low
end

endmodule
