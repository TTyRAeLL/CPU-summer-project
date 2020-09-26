`timescale 1ns / 1ps

module InstructionMemory(Address, Instruction);
	input [31:0] Address;
	output reg [31:0] Instruction;
	always @(*)
	   case (Address[9:2])

        8'd0: Instruction <= 32'h08000003;
        8'd1: Instruction <= 32'h0800002b;
        8'd2: Instruction <= 32'h0800008c;
        8'd3: Instruction <= 32'h3c114000;
        8'd4: Instruction <= 32'h22310014;
        8'd5: Instruction <= 32'h8e320000;
        8'd6: Instruction <= 32'h24100000;
        8'd7: Instruction <= 32'h20080080;
        8'd8: Instruction <= 32'h0c00000a;
        8'd9: Instruction <= 32'h0800000e;
        8'd10: Instruction <= 32'h20090000;
        8'd11: Instruction <= 32'h0128502a;
        8'd12: Instruction <= 32'h1540000d;
        8'd13: Instruction <= 32'h03e00008;
        8'd14: Instruction <= 32'h8e330000;
        8'd15: Instruction <= 32'h0272a022;
        8'd16: Instruction <= 32'h3c114000;
        8'd17: Instruction <= 32'h20120003;
        8'd18: Instruction <= 32'hae320008;
        8'd19: Instruction <= 32'h2415fff0;
        8'd20: Instruction <= 32'hae350000;
        8'd21: Instruction <= 32'h2413ffff;
        8'd22: Instruction <= 32'hae330004;
        8'd23: Instruction <= 32'h08000017;
        8'd24: Instruction <= 32'h21290001;
        8'd25: Instruction <= 32'h0800000b;
        8'd26: Instruction <= 32'h212bffff;
        8'd27: Instruction <= 32'h000b5880;
        8'd28: Instruction <= 32'h020b6020;
        8'd29: Instruction <= 32'h000b5882;
        8'd30: Instruction <= 32'h8d8d0000;
        8'd31: Instruction <= 32'h8d8e0004;
        8'd32: Instruction <= 32'h01cd782b;
        8'd33: Instruction <= 32'h0160c02a;
        8'd34: Instruction <= 32'h1700fff5;
        8'd35: Instruction <= 32'h11e0fff4;
        8'd36: Instruction <= 32'h01cd6826;
        8'd37: Instruction <= 32'h01cd7026;
        8'd38: Instruction <= 32'h01cd6826;
        8'd39: Instruction <= 32'had8d0000;
        8'd40: Instruction <= 32'had8e0004;
        8'd41: Instruction <= 32'h216bffff;
        8'd42: Instruction <= 32'h0800001b;
        8'd43: Instruction <= 32'h3c104000;
        8'd44: Instruction <= 32'hae000008;
        8'd45: Instruction <= 32'h24100190;
        8'd46: Instruction <= 32'h240c000f;
        8'd47: Instruction <= 32'h028c4024;
        8'd48: Instruction <= 32'h0014a102;
        8'd49: Instruction <= 32'h028c4824;
        8'd50: Instruction <= 32'h0014a102;
        8'd51: Instruction <= 32'h028c5024;
        8'd52: Instruction <= 32'h0014a102;
        8'd53: Instruction <= 32'h028c5824;
        8'd54: Instruction <= 32'h21040000;
        8'd55: Instruction <= 32'h0c000043;
        8'd56: Instruction <= 32'h20880000;
        8'd57: Instruction <= 32'h21240000;
        8'd58: Instruction <= 32'h0c000043;
        8'd59: Instruction <= 32'h20890000;
        8'd60: Instruction <= 32'h21440000;
        8'd61: Instruction <= 32'h0c000043;
        8'd62: Instruction <= 32'h208a0000;
        8'd63: Instruction <= 32'h21640000;
        8'd64: Instruction <= 32'h0c000043;
        8'd65: Instruction <= 32'h208b0000;
        8'd66: Instruction <= 32'h08000084;
        8'd67: Instruction <= 32'h00006020;
        8'd68: Instruction <= 32'h108c001f;
        8'd69: Instruction <= 32'h218c0001;
        8'd70: Instruction <= 32'h108c001f;
        8'd71: Instruction <= 32'h218c0001;
        8'd72: Instruction <= 32'h108c001f;
        8'd73: Instruction <= 32'h218c0001;
        8'd74: Instruction <= 32'h108c001f;
        8'd75: Instruction <= 32'h218c0001;
        8'd76: Instruction <= 32'h108c001f;
        8'd77: Instruction <= 32'h218c0001;
        8'd78: Instruction <= 32'h100c001f;
        8'd79: Instruction <= 32'h218c0001;
        8'd80: Instruction <= 32'h108c001f;
        8'd81: Instruction <= 32'h218c0001;
        8'd82: Instruction <= 32'h108c001f;
        8'd83: Instruction <= 32'h218c0001;
        8'd84: Instruction <= 32'h108c001f;
        8'd85: Instruction <= 32'h218c0001;
        8'd86: Instruction <= 32'h108c001f;
        8'd87: Instruction <= 32'h218c0001;
        8'd88: Instruction <= 32'h108c001f;
        8'd89: Instruction <= 32'h218c0001;
        8'd90: Instruction <= 32'h108c001f;
        8'd91: Instruction <= 32'h218c0001;
        8'd92: Instruction <= 32'h108c001f;
        8'd93: Instruction <= 32'h218c0001;
        8'd94: Instruction <= 32'h108c001f;
        8'd95: Instruction <= 32'h218c0001;
        8'd96: Instruction <= 32'h108c001f;
        8'd97: Instruction <= 32'h218c0001;
        8'd98: Instruction <= 32'h108c001f;
        8'd99: Instruction <= 32'h218c0001;
        8'd100: Instruction <= 32'h2000003f;
        8'd101: Instruction <= 32'h03e00008;
        8'd102: Instruction <= 32'h20040006;
        8'd103: Instruction <= 32'h03e00008;
        8'd104: Instruction <= 32'h2004005b;
        8'd105: Instruction <= 32'h03e00008;
        8'd106: Instruction <= 32'h2004004f;
        8'd107: Instruction <= 32'h03e00008;
        8'd108: Instruction <= 32'h20040066;
        8'd109: Instruction <= 32'h03e00008;
        8'd110: Instruction <= 32'h2004006d;
        8'd111: Instruction <= 32'h03e00008;
        8'd112: Instruction <= 32'h2004007d;
        8'd113: Instruction <= 32'h03e00008;
        8'd114: Instruction <= 32'h20040007;
        8'd115: Instruction <= 32'h03e00008;
        8'd116: Instruction <= 32'h2004007f;
        8'd117: Instruction <= 32'h03e00008;
        8'd118: Instruction <= 32'h2004006f;
        8'd119: Instruction <= 32'h03e00008;
        8'd120: Instruction <= 32'h20040077;
        8'd121: Instruction <= 32'h03e00008;
        8'd122: Instruction <= 32'h2004007c;
        8'd123: Instruction <= 32'h03e00008;
        8'd124: Instruction <= 32'h20040039;
        8'd125: Instruction <= 32'h03e00008;
        8'd126: Instruction <= 32'h2004005e;
        8'd127: Instruction <= 32'h03e00008;
        8'd128: Instruction <= 32'h20040079;
        8'd129: Instruction <= 32'h03e00008;
        8'd130: Instruction <= 32'h20040071;
        8'd131: Instruction <= 32'h03e00008;
        8'd132: Instruction <= 32'h3c104000;
        8'd133: Instruction <= 32'h22100010;
        8'd134: Instruction <= 32'hae0b0000;
        8'd135: Instruction <= 32'hae0a0000;
        8'd136: Instruction <= 32'hae090000;
        8'd137: Instruction <= 32'hae080000;
        8'd138: Instruction <= 32'h08000086;
        8'd139: Instruction <= 32'h0800008b;
        8'd140: Instruction <= 32'h0800008c;



            
            default: Instruction <= 32'h00000000;
        endcase
endmodule
/*
module InstructionMemory(Address, Instruction);//read as DataMemory does, for debugging
	input [31:0] Address;
	output [31:0] Instruction;
	
	parameter RAM_SIZE = 256;
	parameter RAM_SIZE_BIT = 8;
	
	reg [31:0] RAM_data[RAM_SIZE - 1: 0];
	
	assign Instruction = RAM_data[Address[RAM_SIZE_BIT + 1:2]];
	
endmodule
*/
