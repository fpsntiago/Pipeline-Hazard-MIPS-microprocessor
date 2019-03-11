//========== Register File ==========//
//holds operands
module registerFile(
	input clk,	//clock
	input WE3,	//write enable
	input [4:0] A1, //read address input
	input [4:0] A2,	//read address input
	input [4:0] A3,	//write address input
	input [31:0] WD3,	//write data
	output reg [31:0] RD1,	//read data output for address A1
	output reg [31:0] RD2);	//read data output for address A2
	  
reg [31:0] rFile [0:31];	//32-bit by 32-element

//initialize register file contents
initial begin
	$readmemb ("rFile.txt", rFile);
end

//register file is in write-first mode
//data can be written first and read back in a single cycle

//write at rising edge of the clock
always @(posedge clk) begin
	if (WE3) rFile[A3] <= WD3;	//write WD3 to address A3
end

//read at falling edge of the clock
always @(negedge clk) begin
	if (WE3) begin
		if (A3 == A1)	//if write address is A1
			RD1 = (A1 != 0) ? WD3 : 0;	//read WD3 at RD1
		else 
			RD1 = (A1 != 0) ? rFile[A1] : 0;	//read address A1 at RD1
		if (A3 == A2)	//if write address is A2
			RD2 = (A2 != 0) ? WD3 : 0;	//read WD3 at RD2
		else
			RD2 = (A2 != 0) ? rFile[A2] : 0; //read address A2 at RD2
	end
	else begin
		RD1 = (A1 != 0) ? rFile[A1] : 0; //read address A1 at RD1
		RD2 = (A2 != 0) ? rFile[A2] : 0;	//read address A2 at RD2
	end
end

endmodule
