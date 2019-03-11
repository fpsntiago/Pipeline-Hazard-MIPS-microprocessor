`timescale 1ns / 1ps

//========== Top Module ==========//
//connects all the processor modules
module main(
	input clk,	//clock
	input rst,	//reset
	output [31:0] resultW	//writeback result, main output
	);

//fetch stage wires
wire stallF;
wire [31:0] pc, pcF, pcPlus4F, instrF, muxPCsrcOut;

//decode stage wires
wire jumpD, regWriteD, memToRegD, memWriteD, branchD, aluSrcD, regDstD, equalD,
	pcSrcD, flushD, stallD, forwardAD, forwardBD;
wire [31:0] instrD, rd1D, rd2D, srcAD, writeDataD, signImmD, pcPlus4D, pcBranchD,
	muxForwardADout, muxForwardBDout;
wire [2:0] aluControlD;

//execute stage wires
wire regWriteE, memToRegE, memWriteE, branchE, aluSrcE, regDstE, flushE;
wire [31:0] rd1E, rd2E, srcAE, srcBE, signImmE, pcPlus4E, aluOutE, writeDataE, pcBranchE;
wire [4:0] rsE, rtE, rdE,  writeRegE;
wire [2:0] aluControlE;
wire [1:0] forwardAE, forwardBE;

//memory stage wires
wire pcSrcM, regWriteM, memToRegM, memWriteM, branchM;
wire [31:0] pcBranchM, aluOutM, writeDataM, readDataM;
wire [4:0]  writeRegM;

//writeback stage wires
wire regWriteW, memToRegW;
wire [31:0] aluOutW, readDataW; 
wire [4:0] writeRegW;

//hazard unit
hazardUnit hazard(
	.jumpD(jumpD), .pcSrcD(pcSrcD), .branchD(branchD), .rsD(instrD[25:21]),
	.rtD(instrD[20:16]), .rsE(rsE), .rtE(rtE), .memToRegE(memToRegE), 
	.regWriteE(regWriteE), .writeRegE(writeRegE), .memToRegM(memToRegM), 
	.regWriteM(regWriteM), .writeRegM(writeRegM), .regWriteW(regWriteW), 
	.writeRegW(writeRegW), .stallF(stallF), .forwardAD(forwardAD), 
	.forwardBD(forwardBD), .flushD(flushD), .stallD(stallD), .flushE(flushE), 
	.forwardAE(forwardAE), .forwardBE(forwardBE)
	);

//control unit
controlUnit ctrl(
	.op(instrD[31:26]), .funct(instrD[5:0]), .memToReg(memToRegD), .memWrite(memWriteD), 
	.branch(branchD), .aluSrc(aluSrcD), .regDst(regDstD), .regWrite(regWriteD), 
	.jump(jumpD), .aluControl(aluControlD)
	);

//PC source multiplexer
mux2to1 muxPCsrc(
	.sel(pcSrcD), .i0(pcPlus4F), .i1(pcBranchD), .out(muxPCsrcOut)
	);

//jump multiplexer
mux2to1 muxJump(
	.sel(jumpD), .i0(muxPCsrcOut), .i1({pcPlus4F[31:26] , instrD[25:0]}), .out(pc)
	);

//program counter
PC pc0(
	.clk(clk), .rst(rst), .en(stallF), .in(pc), .out(pcF)
	);

//instruction memory
instructionMemory iMem(
	.A(pcF), .RD(instrF)
	);

//PC adder
pcAdder pcAdd(
	.in(pcF), .out(pcPlus4F)
	);

//decode register
regDecode regD(
	.clr(flushD), .clk(clk), .rst(rst), .en(stallD), .instrF(instrF), .pcPlus4F(pcPlus4F), 
	.instrD(instrD), .pcPlus4D(pcPlus4D)
	);

//register file
registerFile rFile(
	.clk(clk), .WE3(regWriteW), .A1(instrD[25:21]), .A2(instrD[20:16]), .A3(writeRegW),
	.WD3(resultW), .RD1(rd1D), .RD2(rd2D)
	);

//sign extension module
signExtend signEx(
	.in(instrD[15:0]), .out(signImmD)
	);

//execute register
regExecute regE(
	.clr(flushE), .clk(clk), .rst(rst), .regWriteD(regWriteD), .memToRegD(memToRegD),
	.memWriteD(memWriteD), .aluSrcD(aluSrcD), .regDstD(regDstD), 
	.aluControlD(aluControlD), .rd1D(rd1D), .rd2D(rd2D), .signImmD(signImmD),
	.rtD(instrD[20:16]), .rdD(instrD[15:11]), .regWriteE(regWriteE), 
	.memToRegE(memToRegE), .memWriteE(memWriteE), .aluSrcE(aluSrcE), 
	.regDstE(regDstE), .aluControlE(aluControlE), .rd1E(rd1E), .rd2E(rd2E),
	.signImmE(signImmE), .rtE(rtE), .rdE(rdE), .rsD(instrD[25:21]),
	.rsE(rsE)
	);


//destination register multiplexer
mux2to1 #(.size(5)) muxRegDst(
	.sel(regDstE), .i0(rtE), .i1(rdE), .out(writeRegE)
	);

//ALU source multiplexer
mux2to1 muxALUsrc(
	.sel(aluSrcE), .i0(writeDataE), .i1(signImmE), .out(srcBE)
	);

//arithmetic and logic unit
ALU alu(
	.srcA(srcAE), .srcB(srcBE), .aluControl(aluControlE), .aluResult(aluOutE)
	);

//branch adder
branchAdder branchAdd(
	.signImm(signImmD), .pcPlus4(pcPlus4D), .pcBranch(pcBranchD)
	);

//memory register
regMemory regM(
	.clk(clk), .rst(rst), .regWriteE(regWriteE), .memToRegE(memToRegE), 
	.memWriteE(memWriteE), .aluOutE(aluOutE),
	.writeDataE(writeDataE), .writeRegE(writeRegE),
	.regWriteM(regWriteM), .memToRegM(memToRegM), .memWriteM(memWriteM),
	.aluOutM(aluOutM), .writeDataM(writeDataM),
	.writeRegM(writeRegM)
	);

//and gate
and and0(
	pcSrcD, branchD, equalD
	);

//data memory
dataMemory dMem(
	.clk(clk), .WE(memWriteM), .A(aluOutM), .WD(writeDataM), .RD(readDataM)
	);

//writeback register
regWriteback regW(
	.clk(clk), .rst(rst), .regWriteM(regWriteM), .memToRegM(memToRegM), .aluOutM(aluOutM), 
	.readDataM(readDataM), .writeRegM(writeRegM), .regWriteW(regWriteW), .memToRegW(memToRegW),
	.aluOutW(aluOutW), .readDataW(readDataW), .writeRegW(writeRegW)
	);

//memory to register multiplexer
mux2to1 muxMemToReg(
	.sel(memToRegW), .i0(aluOutW), .i1(readDataW), .out(resultW)
	);

//forward A to decode multiplexer
mux2to1 muxForwardAD(
	.sel(forwardAD), .i0(rd1D), .i1(aluOutM), .out(muxForwardADout)
	);
	
//forward B to decode multiplexer
mux2to1 muxForwardBD(
	.sel(forwardBD), .i0(rd2D), .i1(aluOutM), .out(muxForwardBDout)
	);

//equality comparator
comparator eqComp(
	.a(muxForwardADout), .b(muxForwardBDout), .out(equalD)
	);	
	
//forward A to execute multiplexer
mux3to1 muxForwardAE(
	.sel(forwardAE), .i00(rd1E), .i01(resultW), .i10(aluOutM), .out(srcAE)
	);
	
//forward B to execute multiplexer
mux3to1 muxForwardBE(
	.sel(forwardBE), .i00(rd2E), .i01(resultW), .i10(aluOutM), .out(writeDataE)
	);


endmodule
