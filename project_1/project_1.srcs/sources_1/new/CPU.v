`timescale 1ns / 1ps

module CPU(clk, reset, cathodes, ans, LEDs);
    input clk;
    input reset;
    output [7:0] cathodes;
    output [3:0] ans;
    output reg [7:0] LEDs;
    
    reg [31:0] SysTick;
    reg [31:0] TH, TH_next, TL, TL_next;
    reg [2:0] TCON, TCON_next;
    reg [15:0] clk_num;
    reg bcd_en, write_en;
    
    reg [31:0] PC;
    always @(posedge reset or posedge clk)
    if(reset)
    begin
        SysTick <= 32'h00000000;
        TL <= 32'h00000000;
        TCON <= 3'b000;
        TH <= 32'h00000000;
        TL_next <= 32'h00000000;
        TCON_next <= 3'b000;
    end
    else
    begin
        SysTick <= SysTick + 1'b1;
        if(TCON[0])
        begin
            if(TL==32'hffffffff)
            begin
                TL <= TH;
                if(TCON[1]) 
                begin
                TCON[2] <= 1'b1;
                //PC[31] <= 1'b0;
                end
            end
            else
                TL <= TL + 1;
        end
        /*
        if(TCON[0])
        begin
            if(TL == 32'hffffffff)
            begin
                TL_next <= TH;
                if(TCON[1])
                    TCON_next <= {1'b1, TCON[1:0]};
                else
                    TCON_next <= TCON;  
            end
            else
            begin
                TL_next <= TL + 1'b1;
                TCON_next <= TCON;
            end
        end
        else
        begin
            TL_next <= TL;
            TCON_next <= TCON;
        end*/
    end    
    reg [11:0] digits;
    //assign cathodes = digits[7:0];
    //assign an = digits[11:8];
    
    
    wire [31:0] PC_next;
    wire [31:0] PC_plus_4;
    wire [31:0] jump_addr;
    wire [31:0] jr_addr;
    
    wire IRQ;
    wire ExceptionOrInterrupt;
    wire JumpHazard;
    wire BranchHazard;
    wire Stall;
    wire [2:0] PCSrc;
    wire [31:0] Branch_tar;
    wire [2:0] ID_PCSrc;
    
    assign IRQ = 1'b0;
    //IF stage
    assign PC_plus_4 = PC + 32'd4;//有问题？
    assign PC_next = BranchHazard ? Branch_tar:
                     (ID_PCSrc == 3'b001)? jump_addr://jump to a certain address
                     (ID_PCSrc == 3'b010)? jr_addr: //take register data as address
                     (ID_PCSrc == 3'b100)? 32'h80000008://exception
                     (ID_PCSrc == 3'b011)? 32'h80000004://IRQ
                     
                     //(PCSrc == 3'b101)? branch_addr:
                      PC_plus_4;
    
    always @(posedge reset or posedge clk)
        if(reset)
          PC <= 32'h80000000;
        else if(~Stall)
          PC <= PC_next;
        
    
    wire [31:0] instruction;
    
    InstructionMemory instruction_memory(.Address(PC), .Instruction(instruction));
    //assign IF_Instruction = (PCSrc == 3'b000)? instruction:32'h00000000;
    //valid??
    reg [31:0] IF_ID_Instruction;
    reg [31:0] IF_ID_PC;
    reg [31:0] IF_ID_PC_plus_4;
    reg [31:0] IF_ID_PC_next;
    wire flush;
    assign flush = PCSrc == 3'b001 || PCSrc == 3'b010 || BranchHazard;
    always @(posedge reset or posedge clk)
    if(reset || flush)
    begin
        IF_ID_Instruction <= 32'h00000000;
        IF_ID_PC <= 32'h00000000;
        IF_ID_PC_plus_4 <= 32'h00000000;
        IF_ID_PC_next <= 32'h00000000;
    end
    else if(~Stall)
    begin
        IF_ID_Instruction <= instruction;
        IF_ID_PC <= PC;
        IF_ID_PC_plus_4 <= PC_plus_4;
        IF_ID_PC_next <= PC_next;
    end
    
    
    //ID stage
    //control signals
    wire [1:0] RegDst;
    wire Branch;
    wire MemRead;
    wire [1:0] MemToReg;
    wire [3:0] ALUOp;
    wire ExtOp;
    wire LuOp;
    wire MemWrite;
    wire ALUSrc1;
    wire ALUSrc2;
    wire RegWrite;
    wire [2:0] BranchOp;
    
    //addresses
    wire [4:0] Rs;
    wire [4:0] Rt;
    wire [4:0] Rd;
    wire [4:0] EX_Rd;
    wire [5:0] OpCode, funct;
    wire [15:0] imm;
    wire [31:0] ID_Rs_data, ID_Rt_data;
    wire [4:0] shamt;
    
    reg [4:0] ID_EX_Rd;
    reg [4:0] EX_MEM_Rd;
    reg [4:0] MEM_WB_Rd;
    //reg [4:0] ID_EX_R
    
    assign OpCode = IF_ID_Instruction[31:26];//直接用instructionJ不会出错
    assign funct = IF_ID_Instruction[5:0];
    assign Rs = IF_ID_Instruction[25:21];
    assign Rt = IF_ID_Instruction[20:16];
    assign Rd = IF_ID_Instruction[15:11];
    assign imm = IF_ID_Instruction[15:0];
    assign shamt = IF_ID_Instruction[10:6];
    
    
    assign IRQ = TCON[2] && (~PC[31]);/* && (~BranchHazard)*/
    
    Control control(.OpCode(OpCode), .Funct(funct), .PCSrc(PCSrc), .RegDst(RegDst), .ExtOp(ExtOp),
                    .LuOp(LuOp), .Branch(Branch), .BranchOp(BranchOp),
                    .ALUOp(ALUOp), .ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2),
                    .MemRead(MemRead), .MemWrite(MemWrite), .MemToReg(MemToReg),
                    .RegWrite(RegWrite), .IRQ(TCON[2] && (~PC[31])), .Exception(Exception)
                    );
    //determine regdst             


    reg MEM_WB_RegWrite;
    reg [31:0] MEM_Data_out;
    //read reg A and B

    RegisterFile rf(//get data from register file or write
                .clk(clk), .reset(reset), .RegWrite(MEM_WB_RegWrite),
                .Write_register(MEM_WB_Rd), .Write_data(MEM_Data_out),
                .Read_register1(Rs), .Read_register2(Rt),
                .Read_data1(ID_Rs_data), .Read_data2(ID_Rt_data)
                );
                
    wire [1:0] idforwardA;
    wire [1:0] idforwardB;
    wire [31:0] WBforward;
    wire [31:0] MEMforward;
    wire [31:0] ID_Rs_Out;
    wire [31:0] ID_Rt_Out;
    reg ID_EX_RegWrite;
    reg EX_MEM_RegWrite;
    
    
    assign ID_Rs_Out = (idforwardA == 2'b11) ? MEMforward:
                        (idforwardA == 2'b10) ? WBforward:
                        ID_Rs_data;
    assign ID_Rt_Out = (idforwardB == 2'b11) ? MEMforward:
                        (idforwardB == 2'b10) ? WBforward:
                        ID_Rt_data;
                        
    IDforward idforwarda(.IF_ID_Rs(Rs), .ID_EX_Rd(EX_MEM_Rd), .EX_MEM_Rd(MEM_WB_Rd), 
                    .EX_MEM_RegWrite(MEM_WB_RegWrite), .ID_EX_RegWrite(EX_MEM_RegWrite), 
                    .forward(idforwardA));
    IDforward idforwardb(.IF_ID_Rs(Rt), .ID_EX_Rd(EX_MEM_Rd), .EX_MEM_Rd(MEM_WB_Rd), 
                    .EX_MEM_RegWrite(MEM_WB_RegWrite), .ID_EX_RegWrite(EX_MEM_RegWrite), 
                    .forward(idforwardB));
    
    assign jump_addr = {IF_ID_PC[31:28], IF_ID_Instruction[25:0], 2'b00};
    assign jr_addr = {1'b0, ID_Rs_Out[30:0]};
    
    assign ID_PCSrc = BranchHazard ? 3'b011:PCSrc;
    
    wire [31:0] ID_Ext_Out;
    assign ID_Ext_Out = {ExtOp? {16{imm[15]}}: 16'h0000, imm};
    
    wire [31:0] ID_Lu_Result;
    assign ID_Lu_Result = LuOp? {imm, 16'h0000}: ID_Ext_Out;
    
    //update ID/EX register
    reg [1:0] ID_EX_RegDst;
    reg [4:0] ID_EX_shamt;
    reg [5:0] ID_EX_funct;
    reg [4:0] ID_EX_Rs;
    reg [4:0] ID_EX_Rt;
    reg [31:0] ID_EX_Rs_Data;
    reg [31:0] ID_EX_Rt_Data;
    reg [31:0] ID_EX_imm;
    reg ID_EX_Branch;
    reg [2:0] ID_EX_BranchOp;
    reg [3:0] ID_EX_ALUOp;
    reg ID_EX_ALUSrc1;
    reg ID_EX_ALUSrc2;
    reg ID_EX_MemRead;
    reg ID_EX_MemWrite;
    reg [1:0] ID_EX_MemToReg;
    reg [31:0] ID_EX_Offset;
    reg [31:0] ID_EX_PC;
    reg [31:0] ID_EX_PC_plus_4;
    reg [31:0] ID_EX_PC_next;
    reg ID_EX_OpCode;
    
    always @ (posedge reset or posedge clk)
    begin
        
        if(reset || BranchHazard)
        begin
            ID_EX_shamt <= 5'b00000;
            ID_EX_funct <= 6'b000000;
            ID_EX_Rs <= 5'b00000;
            ID_EX_Rt <= 5'b00000;
            ID_EX_Rd <= 5'b00000;
            ID_EX_Rs_Data <= 32'h00000000;
            ID_EX_Rt_Data <= 32'h00000000;
            ID_EX_imm <= 32'h00000000;
            ID_EX_Branch <= 0;
            ID_EX_BranchOp <= 3'b000;
            ID_EX_ALUOp <= 4'b0000;
            ID_EX_ALUSrc1 <= 0;
            ID_EX_ALUSrc2 <= 0;
            ID_EX_MemRead <= 0;
            ID_EX_MemWrite <= 0;
            ID_EX_MemToReg <= 2'b00;
            ID_EX_RegWrite <= 0; 
            ID_EX_OpCode <= 6'h00;
            ID_EX_Rd <= 5'b00000;
            ID_EX_Offset <= 32'h00000000;
            ID_EX_PC_next <= 32'h00000000;
            ID_EX_RegDst <= 2'b00;
            ID_EX_PC <= 32'h00000000;
            ID_EX_PC_plus_4 <= 32'h00000000;
        end
        else
        begin
            ID_EX_shamt <= shamt;
            ID_EX_funct <= funct;
            ID_EX_Rs <= Rs;
            ID_EX_Rt <= Rt;
            ID_EX_Rd <= Rd;
            ID_EX_Rs_Data <= ID_Rs_Out;
            ID_EX_Rt_Data <= ID_Rt_Out;
            ID_EX_imm <= imm;
            ID_EX_Branch <= Branch;
            ID_EX_BranchOp <= BranchOp;
            ID_EX_ALUOp <= ALUOp;
            ID_EX_ALUSrc1 <= ALUSrc1;
            ID_EX_ALUSrc2 <= ALUSrc2;
            ID_EX_MemRead <= MemRead;
            ID_EX_MemWrite <= MemWrite;
            ID_EX_MemToReg <= MemToReg;
            ID_EX_RegWrite <= RegWrite; 
            ID_EX_OpCode <= Exception ? 6'h00 : OpCode;
            ID_EX_Offset <= ID_Lu_Result;    
            ID_EX_PC_next <= IF_ID_PC_next;
            ID_EX_RegDst <= RegDst;   
            ID_EX_PC <= IF_ID_PC;
            ID_EX_PC_plus_4 <= IF_ID_PC_plus_4;  
        end
    end
        
    //EX stage
    wire [4:0] ALUCtl;
    wire Sign;
    
    assign EX_Rd = (ID_EX_RegDst == 2'b00)? ID_EX_Rt: 
                (ID_EX_RegDst == 2'b01)? ID_EX_Rd: 
                (ID_EX_RegDst == 2'b11)? 5'd26:
                5'b11111;
    
    
    
    ALUControl alu_ctl(.ALUOp(ID_EX_ALUOp), .Funct(ID_EX_funct), .ALUCtl(ALUCtl), .Sign(Sign));
    
    wire [31:0] ALU_in_1;//add later
    wire [31:0] ALU_in_2;
    wire [31:0] A_forwarded;
    wire [31:0] B_forwarded;
    wire [31:0] ALUOut;
    wire [31:0] EX_Rs_Data, EX_Rt_Data;
    
    wire [1:0] EXforwardA;
    wire [1:0] EXforwardB;
    //wire [31:0] WBforward;
    //wire [31:0] MEMforward; //not define
    
    reg [31:0] EX_MEM_ALUOut;
    
    EX_forward EX_forwardA(.MEM_WB_RegWrite(MEM_WB_RegWrite), .EX_MEM_RegWrite(EX_MEM_RegWrite), .ID_EX_Rs(ID_EX_Rs), 
            .MEM_WB_Rd(MEM_WB_Rd),  .EX_MEM_Rd(EX_MEM_Rd), .forward(EXforwardA));
    EX_forward EX_forwardB(.MEM_WB_RegWrite(MEM_WB_RegWrite), .EX_MEM_RegWrite(EX_MEM_RegWrite), .ID_EX_Rs(ID_EX_Rt), 
            .MEM_WB_Rd(MEM_WB_Rd),  .EX_MEM_Rd(EX_MEM_Rd), .forward(EXforwardB));
    
    assign A_forwarded = (EXforwardA == 2'b01)? WBforward:
                       (EXforwardA == 2'b10)? MEMforward:
                       ID_EX_Rs_Data;
                       
    assign B_forwarded = (EXforwardB == 2'b01)? WBforward:
                       (EXforwardB == 2'b10)? MEMforward:
                       ID_EX_Rt_Data;
    assign ALU_in_1 = ID_EX_ALUSrc1 ? {27'h0000000, ID_EX_shamt}: A_forwarded;
    assign ALU_in_2 = ID_EX_ALUSrc2 ? ID_EX_Offset : B_forwarded;
    

    ALU alu1(.in1(ALU_in_1), .in2(ALU_in_2), .ALUCtl(ALUCtl), .Sign(Sign), .out(ALUOut));
    
    BranchCtrl branch_ctrl(.Branch(ID_EX_Branch), .BranchOp(ID_EX_BranchOp), .i_1(A_forwarded), .i_2(B_forwarded), .ctrl(BranchHazard));
    
    assign Branch_tar = ID_EX_PC_next + {ID_EX_imm[29:0], 2'b00};
    
    assign EXForward = EX_MEM_ALUOut;
    
    
    reg EX_MEM_MemRead;
    reg EX_MEM_MemWrite;
    reg [1:0] EX_MEM_MemToReg;
    reg [1:0] EX_MEM_PCToReg;
    reg [31:0] EX_MEM_Data_In;
    reg [31:0] EX_MEM_PC_reg;
    
    always @(posedge reset or posedge clk)
        if(reset) 
        begin
            EX_MEM_ALUOut <= 32'h00000000;
            EX_MEM_MemRead <= 0;
            EX_MEM_MemWrite <= 0;
            EX_MEM_MemToReg <= 2'b00;
            EX_MEM_RegWrite <= 0;
            EX_MEM_Data_In <= 32'h00000000;
            EX_MEM_PC_reg <= 32'h00000000;
            EX_MEM_Rd <= 5'b00000;
            write_en <= 1'b0;
        end
        else
        begin
            EX_MEM_ALUOut <= ALUOut;
            EX_MEM_MemRead <= ID_EX_MemRead;
            EX_MEM_MemWrite <= ID_EX_MemWrite;
            EX_MEM_MemToReg <= ID_EX_MemToReg;
            EX_MEM_RegWrite <= ID_EX_RegWrite;
            EX_MEM_Data_In <= B_forwarded;
            //EX_MEM_PC_reg <= PC_next;//???
            EX_MEM_Rd <= EX_Rd;
            EX_MEM_PC_reg <=  (ID_EX_RegDst == 2'b11)?ID_EX_PC : ID_EX_PC_plus_4;
            if(EX_MEM_ALUOut[30] == 1'b1)//disable DM when using Peripherals
                write_en <= 1'b0;
            else 
                write_en <= 1'b1;
        end
    //MEM
    wire [31:0] MEM_Data_Read;//data read from memory
    wire [31:0] DM_Data;
    reg [31:0] Out_Data;
    DataMemory data_memory(.reset(reset), .clk(clk), .Address(EX_MEM_ALUOut), 
                           .Write_data(EX_MEM_Data_In), .Read_data(DM_Data),
                           .MemRead(EX_MEM_MemRead), .MemWrite(EX_MEM_MemWrite), .write_en(write_en)
                           );
    
    assign MEM_Data_Read = (EX_MEM_ALUOut[30])? Out_Data : DM_Data;
    
    always @(*)
    if(EX_MEM_MemRead)
    begin
        case(EX_MEM_ALUOut)
        32'h40000000:Out_Data <= TH;
        32'h40000004:Out_Data <= TL;
        32'h40000008:Out_Data <= {29'b0, TCON};
        32'h4000000C:Out_Data <= {24'b0, LEDs};
        32'h40000010:Out_Data <= {16'b0, clk_num};
        32'h40000014:Out_Data <= SysTick;
        default: Out_Data <= 32'h00000000;
        endcase
    end
    else
        Out_Data <= 32'h00000000;
    
    always @(posedge reset or posedge clk)
    if(reset)
    begin
        TH <= 32'h00000000;
        TL <= 32'h00000000;
        TCON <= 3'b000;
        digits <= 11'h000;
        clk_num <= 16'b000000;
        LEDs <= 8'b00000000;
        bcd_en <= 1'b0;
    end
    else
    begin
        if(EX_MEM_MemWrite && EX_MEM_ALUOut == 32'h40000000) TH <= EX_MEM_Data_In;
        if(EX_MEM_MemWrite && EX_MEM_ALUOut == 32'h40000004) TL <= EX_MEM_Data_In;
        //else TL <= TL_next;
        if(EX_MEM_MemWrite && EX_MEM_ALUOut == 32'h40000008) TCON <= EX_MEM_Data_In[2:0];
        //else TCON <= TCON_next;
        if(EX_MEM_MemWrite && EX_MEM_ALUOut == 32'h4000000C) LEDs <= EX_MEM_Data_In[7:0];
        if(EX_MEM_MemWrite && EX_MEM_ALUOut == 32'h40000010) 
        begin
            bcd_en <= 1'b1;
            clk_num <= EX_MEM_Data_In[15:0];
        end
    end
    
    BCD7 bcd7(.scan_clk(clk), .din0(clk_num[15:12]), .din1(clk_num[11:8]), .din2(clk_num[7:4]), .din3(clk_num[3:0]), .dout(cathodes), .AN(ans), .bcd_en(bcd_en));
    
    wire [31:0] MEM_Out;
    reg [31:0] WB_Out;
    
    assign MEM_Out = (EX_MEM_MemToReg == 2'b01) ? MEM_Data_Read:MEMforward;//mainly for a period delay
    assign MEMforward = (EX_MEM_MemToReg == 2'b10 || EX_MEM_MemToReg == 2'b11)? EX_MEM_PC_reg:EX_MEM_ALUOut;
    
    assign WBforward = WB_Out;
    
    reg [31:0] MEM_WB_Data;
    always @(posedge reset or posedge clk)
    begin
        if(reset)
        begin
        MEM_WB_RegWrite <= 0;
        MEM_WB_Data <= 32'h00000000;
        MEM_WB_Rd <= 5'b00000;
        MEM_Data_out <= 32'h00000000;
        WB_Out <= 32'h00000000;
        end
        else
        begin
        MEM_WB_RegWrite <= EX_MEM_RegWrite;
        MEM_Data_out <= MEM_Out;
        MEM_WB_Rd <= EX_MEM_Rd;
        WB_Out <= MEM_Out;
        end
    end
    
    LoadAndUse loaduse(.ID_EX_MemRead(ID_EX_MemRead), .EX_MEM_MemRead(EX_MEM_MemRead),
                       .EX_Rd(EX_Rd), .ID_Rs(Rs), .ID_Rt(Rt), 
                       .EX_MEM_Rd(EX_MEM_Rd),.PCSrc(ID_PCSrc), .Stall(Stall));
                        

endmodule
