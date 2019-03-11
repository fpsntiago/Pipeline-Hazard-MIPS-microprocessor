//========== 2-to-1 Multiplexer ==========//
module mux2to1 
	#(parameter size = 32)
	 (input sel,	//input select
	  input [size-1:0] i0,	//input 0
	  input [size-1:0] i1,	//input 1
	  output reg [size-1:0] out	//output
	  );

always @* begin
	case (sel)
		0: out = i0;	//select input 0
		1: out = i1;	//select input 1
		default : out = 'bx;
	endcase
end

endmodule
