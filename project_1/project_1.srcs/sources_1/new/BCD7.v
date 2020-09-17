`timescale 1ns / 1ps

module BCD7(scan_clk, din0, din1, din2, din3, dout, AN, bcd_en);
    input scan_clk;
    input [3:0] din0;
    input [3:0] din1;
    input [3:0] din2;
    input [3:0] din3;
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
                dintemp <= din0;
                end
                2'b01:
                begin
                AN <= 4'b0100; 
                n_state <= 2'b10;
                dintemp <= din1;
                end
                2'b10:
                begin
                AN <= 4'b0010; 
                n_state <= 2'b11;
                dintemp <= din2;
                end
                2'b11:
                begin
                AN <= 4'b0001;
                n_state <= 2'b00;
                dintemp <= din3;
                end
            endcase
            
            if (dintemp==4'h0) douttemp = 7'b0111111;
            else if (dintemp==4'h1) douttemp = 7'b0000110;
            else if (dintemp==4'h2) douttemp = 7'b1011011;
            else if (dintemp==4'h3) douttemp = 7'b1001111;
            else if (dintemp==4'h4) douttemp = 7'b1100110;
            else if (dintemp==4'h5) douttemp = 7'b1101101;
            else if (dintemp==4'h6) douttemp = 7'b1111101;
            else if (dintemp==4'h7) douttemp = 7'b0000111;
            else if (dintemp==4'h8) douttemp = 7'b1111111;
            else if (dintemp==4'h9) douttemp = 7'b1101111;
            else if (dintemp == 4'hA)douttemp = 7'b1110111;
            else if(dintemp == 4'hB) douttemp =  7'b1111100;
            else if(dintemp == 4'hC) douttemp =  7'b0111001;
            else if(dintemp == 4'hD) douttemp =  7'b1011110;
            else if(dintemp == 4'hE) douttemp =  7'b1111001;
            else if(dintemp == 4'hF) douttemp =  7'b1110001;
            else douttemp = 7'b0;
       end
    end
endmodule