`timescale 1ns / 1ps

module BCD7(scan_clk, din0, din1, din2, din3, dout, AN, bcd_en);
    input scan_clk;
    input [7:0] din0;
    input [7:0] din1;
    input [7:0] din2;
    input [7:0] din3;
    input bcd_en;
    output [7:0] dout;
    output reg [3:0] AN;
    //reg [7:0] temp;
    reg [1:0]c_state = 2'b00, n_state = 2'b00;
    reg [7:0] douttemp = 7'b0;
    reg [3:0] dintemp;
    assign dout = douttemp;
    always @(posedge scan_clk)
        c_state <= n_state;
    always @(*)
    begin
        if(bcd_en)
        begin
            case(c_state)
                2'b00:
                begin
                AN <= 4'b1000;
                n_state <= 2'b01;
                douttemp <= din0;
                end
                2'b01:
                begin
                AN <= 4'b0100; 
                n_state <= 2'b10;
                douttemp <= din1;
                end
                2'b10:
                begin
                AN <= 4'b0010; 
                n_state <= 2'b11;
                douttemp <= din2;
                end
                2'b11:
                begin
                AN <= 4'b0001;
                n_state <= 2'b00;
                douttemp <= din3;
                end
            endcase
       end
    end
endmodule