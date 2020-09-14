`timescale 1ns / 1ps


module IF_ID_Reg(
    clk,
    reset,
    instr_in,
    PC_next_in
    );
    input clk;
    input reset;
    input instr_in;
    input PC_next_in;
    
    reg [31:0] instr_out;
    reg [31:0] PC_next_out;
    
    always @ (posedge clk)
    begin
        if (~reset)
        begin
            instr_out <= instr_in;
            PC_next_out <= PC_next_in;
        end
        else
        begin
            instr_out <= 32'h00000000;
            PC_next <= 32'h00000000;
        end
    end
endmodule
