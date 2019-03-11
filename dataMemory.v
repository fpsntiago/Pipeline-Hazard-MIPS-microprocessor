//========== Data Memory ==========//
//stores data
module dataMemory(
	input clk, //clock
	input WE,	//write enable
	input [31:0] A,	//input address
	input [31:0] WD,	//write data
	output [31:0] RD	//read data output
	);
						  
reg [31:0] dMem [0:63];	//32-bit by 64-elemtns

//initialize data memory contents
initial begin
	$readmemb ("dMem.txt", dMem);
end

//write at rising edge of clock
always @(posedge clk) begin
	if (WE) dMem[A] <= WD;	//write WD to address A
end

assign RD = dMem[A];	//read address A

endmodule
