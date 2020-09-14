`timescale 1ns / 1ps

module BranchCtrl(Branch, BranchOp, i_1, i_2, ctrl);

input Branch;
input [2:0] BranchOp;
input [31:0] i_1;
input [31:0] i_2;
output ctrl;

reg ans;

assign ctrl = ans && Branch;

always @(*)
begin
    case(BranchOp)
    3'b001:
    ans = i_1[31];
    3'b010:
    ans = ~(i_1 == i_2);
    3'b011:
    ans = i_1[31] || ~|i_1;
    3'b100:
    ans = ~(i_1[31] || ~|i_1);
    default:
    ans = (i_1 == i_2);
    endcase
end

endmodule
