//========== Hazard Unit ==========//
//handles control and data hazards
module hazardUnit(
	input jumpD,	//jump instruction
	input pcSrcD,	//selects PC adder or branch adder to update PC
	input branchD, //branch instruction
	
	//rs and rt operands
	input [4:0] rsD, 
	input [4:0] rtD, 
	input [4:0] rsE, 
	input [4:0] rtE,
	
	//control signals
	input memToRegE,
	input regWriteE, 
	input memToRegM, 
	input regWriteM,
	input regWriteW,
	
	//write address
	input [4:0] writeRegE,
	input [4:0] writeRegM,
	input [4:0]  writeRegW,
	
	output stallF, //stalls PC
	output flushD,	//clears decode register
	output stallD,	//stalls decode register
	output flushE,	//clears execute register
	
	//forward ALU result from memory stage to equality comparator
	output forwardAD,
	output forwardBD,
	
	//select ALU operands from register file, memory stage, or writeback stage
	output reg [1:0] forwardAE, 
	output reg [1:0] forwardBE
	);

wire lwStall;	//stall for lw instruction
wire branchStall;	 //stall for branch instruction

//		for the branch instruction, if either rsD or rtD depends on an ALU instruction in 
//		the execute stage or on the result of an lw instruction in the memory stage, the 
//		pipeline must be stalled in the decode stage until the result is ready
assign branchStall = (branchD && regWriteE && ((writeRegE == rsD) || (writeRegE == rtD))) 
							| (branchD && memToRegM && ((writeRegM == rsD) || (writeRegM == rtD))); 

//		for the lw instruction, if rtE matches either rsD or rtD, the instruction in the
//		decode stage must be stalled until the source operand is ready
assign lwStall = ((rsD == rtE) || (rtD == rtE)) & memToRegE;

//flushes incorrectly fetched instruction when jump or branch is taken
assign flushD = jumpD | pcSrcD;

//		when an lw stall or branch stall occurs, StallD and StallF are asserted to
//		force the decode stage pipeline register and the PC to hold their old values
assign stallF = lwStall | branchStall;
assign stallD = lwStall | branchStall;

//		when an lw stall or branch stall occurs, the contents of the execute stage
//		pipeline register is cleared, introducing a bubble
assign flushE = lwStall | branchStall;

//		for the branch instruction, if either rsD or rtD depend on the result of
//		an ALU instruction in the memory stage, the result is forwarded to the 
//		equality comparator in the decode stage
assign forwardAD = ((rsD != 0) && (rsD == writeRegM) && regWriteM);
assign forwardBD = ((rtD != 0) && (rtD == writeRegM) && regWriteM);

//		forwarding is necessary when an instruction in the execute stage has a source
//		register (rsE or rtE) that matches the destination register of an instruction
//		in the memory or writeback stage (writeRegM or writeRegW)
always @* begin
	if ((rsE != 0) && (rsE == writeRegM) && regWriteM) 
		forwardAE = 2'b10;	//select ALU operand from memory stage
	else if ((rsE != 0) && (rsE == writeRegW) && regWriteW) 
		forwardAE = 2'b01;	//select ALU operand from writeback stage
	else forwardAE = 2'b00;	//select ALU operand from register file
end

//		same logic as forwardAE, rsE is replaced by rtE
always @* begin
	if ((rtE != 0) && (rtE == writeRegM) && regWriteM) 
		forwardBE = 2'b10;	//select ALU operand from memory stage
	else if ((rtE != 0) && (rtE == writeRegW) && regWriteW) 
		forwardBE = 2'b01;	//select ALU operand from writeback stage
	else forwardBE = 2'b00;	//select ALU operand from register file
end

endmodule
