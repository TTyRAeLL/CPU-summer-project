`timescale 1ns / 1ps

module Control(
    OpCode, Funct, PCSrc, RegDst, ExtOp, LuOp, Branch, BranchOp, ALUOp, ALUSrc1, 
    ALUSrc2, MemRead, MemWrite, MemToReg, RegWrite, IRQ, Exception
    );
    input [5:0] OpCode;
    input [5:0] Funct;
    input IRQ;
    output [2:0] PCSrc;
    output [1:0] RegDst;
    output ExtOp;
    output LuOp;
    
    output Branch;
    output [2:0] BranchOp;
    output [3:0] ALUOp;
    output ALUSrc1;
    output ALUSrc2;
    
    output MemRead;
    output MemWrite;
    
    output [1:0] MemToReg;
    output RegWrite;
    output Exception;
    
    assign PCSrc = //IRQ, exception

       (OpCode == 6'h02 || OpCode == 6'h03)? 3'b001:
       ((OpCode == 0 && Funct == 6'h08) || (OpCode == 0 && Funct == 6'h09))? 3'b010:
        IRQ ? 3'b011:
        Exception ? 3'b100:
        3'b000;
    assign Branch = 
              ~IRQ && (OpCode == 6'h01 || (OpCode >= 6'h04 && OpCode <= 6'h07))? 1'b1:
              1'b0;
     assign BranchOp[2:0] = 
            (OpCode == 6'h01) ? 3'b001://bltz         
            (OpCode == 6'h05) ? 3'b010://bne
            (OpCode == 6'h06) ? 3'b011://blez
            (OpCode == 6'h07) ? 3'b100://bgtz
            3'b000;//beq
	assign ALUOp[2:0] = //???
            (OpCode == 6'h00)? 3'b010: //R, jr, jalr
            (OpCode == 6'h04)? 3'b001: //andi
            (OpCode == 6'h0c)? 3'b100: //ori
            (OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101://slti or sltiu 
            3'b000; //addi, addiu, ...
    assign ALUOp[3] = OpCode[0];
    
    assign ALUSrc1 = 
            (OpCode == 6'h00 && (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03))? 1'b1:
            1'b0;
    assign ALUSrc2 = ~(OpCode == 6'h00 || OpCode == 6'h04);
    assign MemRead = 
        (OpCode == 6'h23) && ~(IRQ || Exception);
    assign MemWrite = 
        (OpCode == 6'h2b) && ~(IRQ || Exception);
    assign MemToReg = 
            (IRQ || Exception) ? 2'b11:
            (OpCode == 6'h23)? 2'b01://mem out
            (OpCode == 6'h03 || (OpCode == 0 && Funct == 6'h09))? 2'b10://pc
            2'b00;//alu out
    assign ExtOp = 
        (OpCode == 6'h0c || OpCode == 6'h0d)? 1'b0://without ori
        1'b1;
    assign LuOp = 
        (OpCode == 6'h0f)? 1'b1:
        1'b0;
    assign RegDst[1:0] = //???
        (IRQ || Exception) ? 2'b11:
        (OpCode == 6'h03) ? 2'b10:
        (OpCode == 6'h23 || OpCode == 6'h0f || OpCode == 6'h08 || OpCode == 6'h09 || OpCode == 6'h0c || OpCode == 6'h0a || OpCode == 6'h0b)? 2'b00:
        2'b01;
    assign RegWrite = IRQ || Exception || 
           ~(OpCode == 6'h2b || Branch || OpCode == 6'h02 || (OpCode == 0 && Funct == 6'h08));
           
    assign Exception = ~((OpCode == 6'h00 && ((Funct >= 6'h20 && Funct <= 6'h27) || Funct == 6'h2a ||
                        Funct == 6'h2b || Funct == 6'h08||Funct == 6'h09 || Funct == 6'h00 ||
                        Funct == 6'h02 || Funct == 6'h03)) || ((OpCode >= 6'h01 && OpCode <= 6'h0d) ||
                        (OpCode == 6'h23 || OpCode == 6'h2b || OpCode == 6'h0f)));
    
           
endmodule
