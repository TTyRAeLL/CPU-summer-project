`timescale 1ns / 1ps

module EX_forward(
    MEM_WB_RegWrite, EX_MEM_RegWrite, ID_EX_Rs, MEM_WB_Rd, EX_MEM_Rd, forward
    );
    input MEM_WB_RegWrite;
    input EX_MEM_RegWrite;
    input [4:0] ID_EX_Rs;
    input [4:0] MEM_WB_Rd;
    input [4:0] EX_MEM_Rd;
    output [1:0] forward;
    
    assign forward = (MEM_WB_RegWrite && MEM_WB_Rd != 5'b00000 && MEM_WB_Rd == ID_EX_Rs) && (EX_MEM_Rd != ID_EX_Rs || ~EX_MEM_RegWrite) ? 2'b01:
    /*&& (EX_MEM_Rd != ID_EX_Rs || ~EX_MEM_RegWrite))*/
                        EX_MEM_RegWrite && EX_MEM_Rd != 5'b00000 && EX_MEM_Rd == ID_EX_Rs ? 2'b10:
                        2'b00;
    
    
endmodule
