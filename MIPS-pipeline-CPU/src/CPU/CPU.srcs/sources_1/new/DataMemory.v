`timescale 1ns / 1ps

module DataMemory(reset, clk, Address, Write_data, Read_data, MemRead, MemWrite, write_en);
	input reset, clk;
	input [31:0] Address, Write_data;
	input write_en;
	input MemRead, MemWrite;
	output [31:0] Read_data;
	
	parameter RAM_SIZE = 256;
	parameter RAM_SIZE_BIT = 8;

	reg [31:0] RAM_data[RAM_SIZE - 1: 0];
		initial
	begin
	RAM_data[0] <= 32'h6e037588;
    RAM_data[1] <= 32'h4c2d2400;
    RAM_data[2] <= 32'h457ddf47;
    RAM_data[3] <= 32'hb9ac5ed3;
    RAM_data[4] <= 32'h7eb33b04;
    RAM_data[5] <= 32'hcee52cfe;
    RAM_data[6] <= 32'h150257e6;
    RAM_data[7] <= 32'h509c7fa7;
    RAM_data[8] <= 32'h0adeb752;
    RAM_data[9] <= 32'h34bab743;
    RAM_data[10] <= 32'hacba9e52;
    RAM_data[11] <= 32'h225d3439;
    RAM_data[12] <= 32'he11217bc;
    RAM_data[13] <= 32'h65b62e72;
    RAM_data[14] <= 32'h36890991;
    RAM_data[15] <= 32'h4baeedfb;
    RAM_data[16] <= 32'h4e4ad2d2;
    RAM_data[17] <= 32'h1d25dea2;
    RAM_data[18] <= 32'he44c16d8;
    RAM_data[19] <= 32'he41978f7;
    RAM_data[20] <= 32'h04752d75;
    RAM_data[21] <= 32'had8f9dff;
    RAM_data[22] <= 32'haa83d36b;
    RAM_data[23] <= 32'h803bd48b;
    RAM_data[24] <= 32'ha8dc281f;
    RAM_data[25] <= 32'h8f45dbfa;
    RAM_data[26] <= 32'h1771e9f4;
    RAM_data[27] <= 32'hba99398f;
    RAM_data[28] <= 32'hae93b4fd;
    RAM_data[29] <= 32'hfabe734b;
    RAM_data[30] <= 32'h032a1cdb;
    RAM_data[31] <= 32'h55d749d4;
    RAM_data[32] <= 32'h0dc3bd08;
    RAM_data[33] <= 32'h10101206;
    RAM_data[34] <= 32'hed6f2d97;
    RAM_data[35] <= 32'h35491732;
    RAM_data[36] <= 32'h55cec923;
    RAM_data[37] <= 32'hdeb8e688;
    RAM_data[38] <= 32'h84ed6cd7;
    RAM_data[39] <= 32'h63cc2745;
    RAM_data[40] <= 32'h2e786bc6;
    RAM_data[41] <= 32'heb66753b;
    RAM_data[42] <= 32'h16a2fc62;
    RAM_data[43] <= 32'h302d11b2;
    RAM_data[44] <= 32'h85d014c9;
    RAM_data[45] <= 32'h3fd73e24;
    RAM_data[46] <= 32'h70fef555;
    RAM_data[47] <= 32'hcb36dd8d;
    RAM_data[48] <= 32'hf8085ebd;
    RAM_data[49] <= 32'hb9563d98;
    RAM_data[50] <= 32'h69ba34ef;
    RAM_data[51] <= 32'hb07644d8;
    RAM_data[52] <= 32'h962b0b7a;
    RAM_data[53] <= 32'hd16c1b99;
    RAM_data[54] <= 32'h638c6a84;
    RAM_data[55] <= 32'hbbba95a0;
    RAM_data[56] <= 32'hddccdaae;
    RAM_data[57] <= 32'h4ed5ba5d;
    RAM_data[58] <= 32'h6ab3949c;
    RAM_data[59] <= 32'h193941b2;
    RAM_data[60] <= 32'h4dc4f8fc;
    RAM_data[61] <= 32'h80e71144;
    RAM_data[62] <= 32'h295dd4ef;
    RAM_data[63] <= 32'h4c8a559a;
    RAM_data[64] <= 32'he78f177e;
    RAM_data[65] <= 32'h54f78bef;
    RAM_data[66] <= 32'h53c24e8a;
    RAM_data[67] <= 32'h18dead17;
    RAM_data[68] <= 32'h0fbf6c69;
    RAM_data[69] <= 32'h28dd5e6a;
    RAM_data[70] <= 32'h2e07f85d;
    RAM_data[71] <= 32'ha111ec46;
    RAM_data[72] <= 32'ha27fbf0e;
    RAM_data[73] <= 32'h28b1f213;
    RAM_data[74] <= 32'h9bdc1e65;
    RAM_data[75] <= 32'hf559209b;
    RAM_data[76] <= 32'h69a71902;
    RAM_data[77] <= 32'h3c8fcc1f;
    RAM_data[78] <= 32'hfa99e2c2;
    RAM_data[79] <= 32'h346a024c;
    RAM_data[80] <= 32'hb270e93f;
    RAM_data[81] <= 32'h7e9d783a;
    RAM_data[82] <= 32'h772f31d8;
    RAM_data[83] <= 32'h76c73b83;
    RAM_data[84] <= 32'h6901c7a1;
    RAM_data[85] <= 32'h5928fc5c;
    RAM_data[86] <= 32'h9c6a4121;
    RAM_data[87] <= 32'he121e94a;
    RAM_data[88] <= 32'h33c1bebb;
    RAM_data[89] <= 32'h20fde260;
    RAM_data[90] <= 32'h1520692c;
    RAM_data[91] <= 32'h3b94bb3b;
    RAM_data[92] <= 32'hf36e5170;
    RAM_data[93] <= 32'h839a0259;
    RAM_data[94] <= 32'h8f83e329;
    RAM_data[95] <= 32'h2cde244c;
    RAM_data[96] <= 32'h8bd49d82;
    RAM_data[97] <= 32'hf453c9cd;
    RAM_data[98] <= 32'hb36db605;
    RAM_data[99] <= 32'h9ce507cf;
    RAM_data[100] <= 32'h61589539;
    RAM_data[101] <= 32'h2f38c984;
    RAM_data[102] <= 32'h6af16b1d;
    RAM_data[103] <= 32'h99904fa3;
    RAM_data[104] <= 32'h7992c761;
    RAM_data[105] <= 32'hef6ceaf1;
    RAM_data[106] <= 32'h8836da43;
    RAM_data[107] <= 32'hd9ea4695;
    RAM_data[108] <= 32'h8363dfd4;
    RAM_data[109] <= 32'hab259f50;
    RAM_data[110] <= 32'h1c838573;
    RAM_data[111] <= 32'he892a2ac;
    RAM_data[112] <= 32'hc687e9a1;
    RAM_data[113] <= 32'h74ff712d;
    RAM_data[114] <= 32'h16af6225;
    RAM_data[115] <= 32'h7520822d;
    RAM_data[116] <= 32'h0bbc3be1;
    RAM_data[117] <= 32'h51f31fa9;
    RAM_data[118] <= 32'h9df8fc3c;
    RAM_data[119] <= 32'hd6215174;
    RAM_data[120] <= 32'h903e5a58;
    RAM_data[121] <= 32'hc5ca779f;
    RAM_data[122] <= 32'h4549d763;
    RAM_data[123] <= 32'h35424389;
    RAM_data[124] <= 32'h6654566f;
    RAM_data[125] <= 32'h88950199;
    RAM_data[126] <= 32'h96e8f221;
    RAM_data[127] <= 32'h6fb95788;

	end
	assign Read_data = MemRead? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	
	integer i;
	always @(posedge reset or posedge clk)
		if (reset)
			for (i = 128; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h00000000;
		else if (MemWrite && write_en)
			RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
			
endmodule
