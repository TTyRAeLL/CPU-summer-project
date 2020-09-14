`timescale 1ns / 1ps

module top(reset, clk);
input reset;
input clk;
CPU cpu(.reset(reset), .clk(clk));

endmodule
