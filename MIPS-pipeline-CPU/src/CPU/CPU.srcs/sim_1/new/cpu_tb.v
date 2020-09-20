`timescale 1ns / 1ps
`define PERIOD 9.9
module cpu_tb();

reg reset;
reg clk;
wire [3:0] ans;
wire [7:0] cathodes;
CPU cpu(.reset(reset), .clk(clk), .ans(ans), .cathodes(cathodes));

initial begin
    forever
        #(`PERIOD / 2) clk = ~clk;
end

initial begin
    reset = 1;
    clk = 1;
    #100 reset = 0;
    //$readmemh("C:/Users/hp/Desktop/data.txt", cpu.data_memory.RAM_data, 0, 127);
    //$readmemh("C:/Users/hp/Desktop/sort", cpu.instruction_memory.RAM_data, 0, 49);
end

endmodule
