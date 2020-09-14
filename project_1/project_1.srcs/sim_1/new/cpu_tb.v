`timescale 1ns / 1ps
`define PERIOD 100
module cpu_tb();

reg reset;
reg clk;
reg [1:0] sel;
reg [7:0] dis;
CPU cpu(.reset(reset), .clk(clk));

initial begin
    forever
        #(`PERIOD / 2) clk = ~clk;
end
initial begin
    reset = 1;
    clk = 1;
    #100 reset = 0;
end

endmodule
