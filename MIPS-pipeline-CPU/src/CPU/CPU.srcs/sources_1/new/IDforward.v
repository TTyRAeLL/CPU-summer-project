`timescale 1ns / 1ps

module IDforward(
        IF_ID_Rs, ID_EX_Rd, EX_MEM_Rd, EX_MEM_RegWrite, ID_EX_RegWrite, forward
    );
    input [4:0] IF_ID_Rs;
    input [4:0] ID_EX_Rd;
    input [4:0] EX_MEM_Rd;
    input EX_MEM_RegWrite;
    input ID_EX_RegWrite;
    output [1:0] forward;
    
    assign forward = ID_EX_RegWrite && (ID_EX_Rd !=5'b00000) && (IF_ID_Rs == ID_EX_Rd)? 2'b11:
                      EX_MEM_RegWrite && (EX_MEM_Rd != 5'b00000) && (IF_ID_Rs == EX_MEM_Rd) ? 2'b10:
                      2'b00;
    
endmodule
