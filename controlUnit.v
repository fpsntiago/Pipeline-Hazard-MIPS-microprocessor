//========== Control Unit ==========//
//outputs the appropriate control signals for each instruction
module controlUnit(
	input [5:0] op,	//opcode, specifies operation
	input [5:0] funct,	//function code for R-type
	output regWrite,	//enables register file write
	output memToReg,	//selects result from ALU or data memory
	output memWrite,	//enables data memory write
	output branch,		//beq instruction
	output [2:0] aluControl,	//specifies ALU operation
	output aluSrc,		//selects srcB input for ALU
	output regDst, 	//selects destination register
	output jump		//jump instruction
	);

wire [1:0] aluOp;	// together with funct code to compute aluControl

//main instruction decoder
mainDec md(op, memToReg, memWrite, branch, aluSrc, regDst, regWrite, jump, aluOp);

//ALU decoder
aluDec ad(funct, aluOp, aluControl);

endmodule


//========== Main Instruction Decoder ==========//
module mainDec(
	input [5:0] op,
	output memToReg,
	output memWrite,
	output branch,
	output aluSrc,
	output regDst,
	output regWrite,
	output jump,
	output [1:0] aluOp
	);
	
reg [8:0] controls;	//instruction-specific control signals

assign {regWrite, regDst, aluSrc,branch, memWrite, memToReg, jump, aluOp} = controls;
	
always @* begin
	case(op)
		6'b000000: controls = 9'b110000010; //R-type
		6'b100011: controls = 9'b101001000; //lw
		6'b101011: controls = 9'b001010000; //sw
		6'b000100: controls = 9'b000100001; //beq
		6'b001000: controls = 9'b101000000; //addi
		6'b000010: controls = 9'b000000100; //j
		default:  controls = 9'bxxxxxxxxx; //???
	endcase
end
	
endmodule


//========== ALU Operation Decoder ==========//
module aluDec(
	input [5:0] funct,
	input [1:0] aluOp,
	output reg [2:0] aluControl);
	
always @* begin
	case (aluOp)
		2'b00: aluControl = 3'b010; //add
		2'b01: aluControl = 3'b110; //sub
      default: begin
			case(funct) //R-type
				6'b100000: aluControl = 3'b010; //add
				6'b100010: aluControl = 3'b110; //sub
				6'b100100: aluControl = 3'b000; //and
				6'b100101: aluControl = 3'b001; //or
				6'b101010: aluControl = 3'b111; //slt
				default: aluControl  = 3'bxxx; //???
			endcase
		end
	endcase
end
	
endmodule
