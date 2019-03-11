//========== 3-to-1 Multiplexer ==========//
module mux3to1(
	input [1:0] sel,	//input select
	input [31:0] i00,	//input 0
	input [31:0] i01,	//input 1
	input [31:0] i10,	//input 2
	output reg [31:0] out	//output
	);

always @* begin
	case (sel)
		2'b00 : out = i00;	//select input 0
		2'b01 : out = i01;	//select input 1
		2'b10 : out = i10;	//select input 2
		default : out = 'bx;
	endcase
end

endmodule
