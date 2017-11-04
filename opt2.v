module sbox (
	input [7:0] index,

	output [7:0] o
);

wire a, b, c, d, e, f, g, h;

assign a = index[7];
assign b = index[6];
assign c = index[5];
assign d = index[4];
assign e = index[3];
assign f = index[2];
assign g = index[1];
assign h = index[0];


wire [591:0] x;



assign x[0] = ( a & (~b) & c & d & e & (~f) & g & h );
assign x[1] = ( a & (~b) & (~c) & d & (~e) & (~f) & (~g) & h );
assign x[2] = ( a & b & c & (~d) & (~e) & (~f) & g & (~h) );
assign x[3] = ( a & b & (~c) & (~d) & (~e) & (~f) & (~g) & (~h) );
assign x[4] = ( a & b & c & (~d) & (~e) & f & g & (~h) );
assign x[5] = ( a & b & c & d & e & (~f) & (~g) & h );
assign x[6] = ( (~a) & b & c & (~d) & e & f & g & h );
assign x[7] = ( a & (~b) & c & d & (~e) & (~f) & (~g) & h );
assign x[8] = ( (~a) & (~b) & (~c) & d & e & f & (~g) & h );
assign x[9] = ( a & b & (~c) & d & e & f & (~g) & h );
assign x[10] = ( a & b & (~c) & d & e & (~f) & g & h );
assign x[11] = ( a & b & (~c) & (~d) & (~e) & f & g & h );
assign x[12] = ( (~a) & c & (~d) & (~e) & (~f) & (~g) & (~h) );
assign x[13] = ( (~a) & (~b) & c & (~d) & (~e) & g & (~h) );
assign x[14] = ( a & c & (~d) & (~e) & (~f) & (~g) & (~h) );
assign x[15] = ( a & b & d & (~e) & (~f) & g & (~h) );
assign x[16] = ( (~a) & b & (~c) & (~d) & e & (~f) & g );
assign x[17] = ( a & b & c & (~d) & (~e) & f & h );
assign x[18] = ( (~a) & b & (~d) & (~e) & (~f) & (~g) & h );
assign x[19] = ( (~a) & (~b) & c & e & (~f) & g & h );
assign x[20] = ( a & b & c & (~d) & (~e) & (~g) & h );
assign x[21] = ( (~a) & (~b) & d & (~e) & (~f) & (~g) & h );
assign x[22] = ( (~a) & (~b) & (~c) & d & e & (~f) & h );
assign x[23] = ( (~a) & (~b) & (~c) & (~e) & f & (~g) & (~h) );
assign x[24] = ( (~a) & (~b) & (~c) & (~d) & e & f & (~h) );
assign x[25] = ( a & (~b) & c & d & (~e) & f & h );
assign x[26] = ( (~a) & b & c & (~d) & e & (~f) & (~g) & h );
assign x[27] = ( a & (~c) & d & (~e) & f & g & (~h) );
assign x[28] = ( (~a) & b & (~c) & d & (~e) & f & g & (~h) );
assign x[29] = ( a & b & (~c) & (~d) & f & (~g) & h );
assign x[30] = ( (~a) & b & (~c) & e & f & g & h );
assign x[31] = ( (~a) & (~b) & c & d & e & f & (~g) & (~h) );
assign x[32] = ( (~a) & (~b) & (~c) & d & (~e) & (~f) & g & (~h) );
assign x[33] = ( (~a) & b & (~c) & d & e & (~f) & (~g) & h );
assign x[34] = ( (~a) & (~b) & c & (~d) & e & f & (~g) & h );
assign x[35] = ( a & b & (~c) & (~d) & e & f & g & (~h) );
assign x[36] = ( (~a) & b & (~c) & (~d) & e & f & (~g) & h );
assign x[37] = ( (~b) & d & e & (~f) & g & (~h) );
assign x[38] = ( a & b & c & (~d) & e & (~f) & (~h) );
assign x[39] = ( (~a) & b & c & e & f & g & (~h) );
assign x[40] = ( b & c & d & (~e) & f & (~g) & (~h) );
assign x[41] = ( a & b & c & d & e & f & (~h) );
assign x[42] = ( (~a) & b & c & d & e & f & g );
assign x[43] = ( b & c & d & (~e) & (~f) & (~g) & h );
assign x[44] = ( a & (~b) & c & (~d) & e & (~f) & (~g) );
assign x[45] = ( a & (~b) & c & (~d) & e & f & (~g) );
assign x[46] = ( (~a) & (~d) & (~e) & f & g & h );
assign x[47] = ( a & (~b) & (~c) & (~d) & (~f) & (~g) & (~h) );
assign x[48] = ( (~a) & b & c & d & e & (~f) & (~g) & (~h) );
assign x[49] = ( (~a) & (~b) & c & d & (~e) & f & h );
assign x[50] = ( (~a) & b & (~c) & d & (~e) & (~g) & h );
assign x[51] = ( (~a) & b & c & (~e) & f & g & h );
assign x[52] = ( (~a) & (~b) & c & (~d) & e & (~f) & g & (~h) );
assign x[53] = ( (~b) & (~c) & d & f & g & h );
assign x[54] = ( a & b & (~c) & (~e) & f & g & (~h) );
assign x[55] = ( a & b & (~c) & (~d) & e & (~f) & (~g) );
assign x[56] = ( a & c & d & (~e) & f & (~g) & h );
assign x[57] = ( a & (~c) & d & e & f & (~g) & (~h) );
assign x[58] = ( a & b & c & (~d) & e & f & (~g) & (~h) );
assign x[59] = ( a & b & c & (~d) & e & (~f) & g & h );
assign x[60] = ( a & (~c) & (~d) & (~e) & f & (~g) & h );
assign x[61] = ( a & b & (~c) & e & f & g & h );
assign x[62] = ( a & c & d & (~e) & (~g) & (~h) );
assign x[63] = ( a & (~b) & c & e & g & (~h) );
assign x[64] = ( (~a) & (~b) & (~c) & d & (~g) & (~h) );
assign x[65] = ( (~a) & b & c & (~d) & (~e) & (~f) & g );
assign x[66] = ( (~a) & b & d & e & (~f) & g & (~h) );
assign x[67] = ( (~a) & (~b) & c & (~d) & (~f) & (~g) & h );
assign x[68] = ( (~a) & b & c & d & e & (~g) & h );
assign x[69] = ( (~a) & b & c & d & f & (~g) & h );
assign x[70] = ( a & (~b) & (~c) & e & (~f) & (~g) & h );
assign x[71] = ( a & (~b) & (~c) & (~e) & (~f) & g & h );
assign x[72] = ( (~a) & b & (~c) & d & (~e) & (~f) & g & h );
assign x[73] = ( (~a) & c & d & (~e) & (~f) & h );
assign x[74] = ( c & d & e & f & g & (~h) );
assign x[75] = ( (~a) & (~b) & (~c) & (~d) & e & f & (~g) );
assign x[76] = ( a & b & c & (~d) & e & f & g & h );


assign o[7] = |(x[76:0]);



assign x[77] = ( (~a) & (~b) & (~c) & d & e & (~f) & (~g) & h );
assign x[78] = ( a & b & (~c) & d & (~e) & f & (~g) & (~h) );
assign x[79] = ( a & b & (~c) & d & (~e) & (~f) & g & h );
assign x[80] = ( (~a) & b & c & d & (~f) & g & (~h) );
assign x[81] = ( (~a) & b & c & (~d) & e & (~f) & (~g) & (~h) );
assign x[82] = ( a & (~b) & c & d & e & f & (~g) & (~h) );
assign x[83] = ( (~a) & b & (~c) & (~d) & (~e) & f & g & (~h) );
assign x[84] = ( a & b & (~c) & d & (~e) & f & g & (~h) );
assign x[85] = ( x[7] );
assign x[86] = ( x[9] );
assign x[87] = ( x[11] );
assign x[88] = ( (~a) & c & (~d) & e & f & (~g) & (~h) );
assign x[89] = ( a & (~b) & c & d & e & (~f) & (~h) );
assign x[90] = ( a & b & d & e & (~f) & (~g) & (~h) );
assign x[91] = ( (~a) & b & (~c) & d & e & (~g) & (~h) );
assign x[92] = ( (~a) & (~b) & c & d & (~f) & g & h );
assign x[93] = ( (~b) & (~c) & (~d) & (~e) & (~f) & (~g) & (~h) );
assign x[94] = ( (~a) & (~c) & d & (~e) & (~f) & (~g) & (~h) );
assign x[95] = ( (~a) & (~b) & c & (~e) & (~f) & (~g) & h );
assign x[96] = ( (~a) & (~c) & d & e & f & g & (~h) );
assign x[97] = ( a & c & d & (~e) & f & g & (~h) );
assign x[98] = ( a & (~c) & d & (~e) & (~f) & (~g) & (~h) );
assign x[99] = ( a & (~b) & c & (~d) & e & f & g );
assign x[100] = ( b & c & d & (~e) & f & g & h );
assign x[101] = ( (~a) & b & d & e & f & (~g) & h );
assign x[102] = ( a & (~b) & c & d & (~e) & (~f) & (~g) & (~h) );
assign x[103] = ( a & b & (~c) & d & e & (~f) & g & (~h) );
assign x[104] = ( (~a) & (~b) & (~c) & d & (~e) & g & h );
assign x[105] = ( a & (~b) & d & (~e) & (~f) & g & h );
assign x[106] = ( x[31] );
assign x[107] = ( x[32] );
assign x[108] = ( x[33] );
assign x[109] = ( a & (~b) & (~c) & d & (~e) & (~f) & g & (~h) );
assign x[110] = ( a & b & (~c) & (~d) & e & f & (~g) & (~h) );
assign x[111] = ( x[34] );
assign x[112] = ( x[36] );
assign x[113] = ( (~a) & b & d & (~e) & (~f) & (~g) & (~h) );
assign x[114] = ( a & (~b) & (~d) & (~e) & (~g) & (~h) );
assign x[115] = ( (~a) & b & (~c) & (~d) & e & (~f) & (~h) );
assign x[116] = ( (~b) & (~c) & (~d) & (~e) & f & (~h) );
assign x[117] = ( (~a) & c & (~d) & e & (~f) & g & h );
assign x[118] = ( x[42] );
assign x[119] = ( (~a) & d & e & f & g & h );
assign x[120] = ( a & b & (~d) & (~e) & (~f) & (~g) & h );
assign x[121] = ( x[44] );
assign x[122] = ( x[47] );
assign x[123] = ( x[50] );
assign x[124] = ( a & b & c & e & f & (~g) & h );
assign x[125] = ( x[52] );
assign x[126] = ( (~b) & (~c) & (~d) & e & f & (~g) & (~h) );
assign x[127] = ( x[55] );
assign x[128] = ( a & (~b) & c & (~d) & f & g & h );
assign x[129] = ( a & (~b) & c & e & (~f) & g & h );
assign x[130] = ( a & (~b) & d & e & (~f) & (~g) & h );
assign x[131] = ( x[56] );
assign x[132] = ( (~a) & (~c) & (~d) & (~e) & f & (~g) & h );
assign x[133] = ( x[58] );
assign x[134] = ( x[59] );
assign x[135] = ( (~a) & (~b) & (~c) & (~d) & e & f & g & h );
assign x[136] = ( (~a) & b & c & (~d) & (~f) & h );
assign x[137] = ( (~a) & (~b) & (~d) & (~e) & f & g );
assign x[138] = ( (~a) & (~b) & (~c) & (~e) & f & (~h) );
assign x[139] = ( (~a) & (~b) & (~c) & (~d) & (~f) & g & (~h) );
assign x[140] = ( (~a) & (~c) & d & (~e) & f & h );
assign x[141] = ( a & (~c) & (~d) & e & (~f) & g & (~h) );
assign x[142] = ( a & (~b) & (~c) & e & f & h );
assign x[143] = ( (~a) & (~b) & (~c) & (~d) & (~e) & (~f) & h );
assign x[144] = ( a & (~b) & d & e & f & (~g) & h );
assign x[145] = ( x[71] );
assign x[146] = ( x[72] );
assign x[147] = ( b & c & (~d) & (~e) & (~g) );
assign x[148] = ( a & (~b) & (~c) & d & e & (~g) );
assign x[149] = ( x[75] );
assign x[150] = ( x[76] );


assign o[6] = |(x[150:77]);



assign x[151] = ( (~a) & b & c & d & (~e) & f & g & (~h) );
assign x[152] = ( (~a) & (~c) & d & (~e) & f & (~g) & (~h) );
assign x[153] = ( (~a) & b & (~c) & (~d) & (~e) & f & h );
assign x[154] = ( (~a) & b & (~c) & (~d) & (~e) & (~f) & g & (~h) );
assign x[155] = ( (~a) & (~b) & c & (~d) & (~e) & (~f) & g & h );
assign x[156] = ( a & (~b) & c & (~d) & (~e) & (~f) & (~g) & h );
assign x[157] = ( x[6] );
assign x[158] = ( x[8] );
assign x[159] = ( x[10] );
assign x[160] = ( a & (~b) & (~c) & d & (~e) & f & (~g) & h );
assign x[161] = ( a & b & c & (~d) & (~e) & (~g) & (~h) );
assign x[162] = ( x[89] );
assign x[163] = ( a & (~b) & c & (~d) & (~f) & g & (~h) );
assign x[164] = ( x[14] );
assign x[165] = ( a & b & c & d & (~e) & f & (~g) );
assign x[166] = ( x[98] );
assign x[167] = ( x[99] );
assign x[168] = ( x[100] );
assign x[169] = ( a & b & c & e & f & g & (~h) );
assign x[170] = ( x[19] );
assign x[171] = ( x[102] );
assign x[172] = ( (~b) & (~c) & d & (~e) & f & (~g) & (~h) );
assign x[173] = ( x[23] );
assign x[174] = ( x[104] );
assign x[175] = ( x[28] );
assign x[176] = ( a & (~b) & (~c) & (~d) & e & g & h );
assign x[177] = ( x[29] );
assign x[178] = ( a & b & (~c) & d & e & (~f) & (~g) & h );
assign x[179] = ( (~a) & b & (~c) & (~d) & e & (~f) & (~g) & h );
assign x[180] = ( x[36] );
assign x[181] = ( (~b) & c & (~d) & f & g & (~h) );
assign x[182] = ( (~a) & (~c) & d & e & (~f) & (~h) );
assign x[183] = ( a & b & (~c) & (~f) & (~g) & (~h) );
assign x[184] = ( (~b) & c & d & e & f & (~g) );
assign x[185] = ( (~a) & c & (~d) & (~e) & f & g & (~h) );
assign x[186] = ( (~a) & (~b) & (~d) & (~e) & (~f) & (~g) & (~h) );
assign x[187] = ( (~b) & c & d & (~e) & (~f) & g & (~h) );
assign x[188] = ( x[41] );
assign x[189] = ( a & b & c & d & e & g & (~h) );
assign x[190] = ( x[43] );
assign x[191] = ( x[120] );
assign x[192] = ( (~a) & b & (~c) & (~d) & e & f & (~h) );
assign x[193] = ( (~a) & (~b) & c & d & e & f & h );
assign x[194] = ( x[48] );
assign x[195] = ( (~a) & (~b) & (~c) & (~d) & f & g & (~h) );
assign x[196] = ( x[52] );
assign x[197] = ( x[126] );
assign x[198] = ( x[54] );
assign x[199] = ( a & (~b) & (~c) & e & (~f) & g & (~h) );
assign x[200] = ( x[129] );
assign x[201] = ( a & (~b) & c & d & (~e) & g & h );
assign x[202] = ( x[132] );
assign x[203] = ( (~a) & b & (~c) & (~e) & f & (~g) & h );
assign x[204] = ( x[59] );
assign x[205] = ( a & b & (~c) & d & (~e) & (~f) & (~g) & h );
assign x[206] = ( x[135] );
assign x[207] = ( x[136] );
assign x[208] = ( (~a) & (~b) & (~d) & e & (~g) & (~h) );
assign x[209] = ( (~a) & b & e & (~f) & g & h );
assign x[210] = ( a & b & (~c) & (~e) & (~f) & g );
assign x[211] = ( (~a) & (~b) & (~c) & e & g & (~h) );
assign x[212] = ( x[139] );
assign x[213] = ( x[65] );
assign x[214] = ( x[67] );
assign x[215] = ( (~b) & (~c) & (~d) & (~f) & g & h );
assign x[216] = ( x[68] );
assign x[217] = ( x[141] );
assign x[218] = ( (~a) & b & c & e & f & (~g) & h );
assign x[219] = ( x[143] );
assign x[220] = ( x[70] );
assign x[221] = ( x[72] );
assign x[222] = ( (~a) & (~b) & c & (~d) & (~e) & (~g) );
assign x[223] = ( x[74] );
assign x[224] = ( (~a) & (~b) & (~c) & (~f) & g & h );


assign o[5] = |(x[224:151]);



assign x[225] = ( x[77] );
assign x[226] = ( a & b & (~c) & d & (~e) & (~f) & (~h) );
assign x[227] = ( x[2] );
assign x[228] = ( x[3] );
assign x[229] = ( x[156] );
assign x[230] = ( x[83] );
assign x[231] = ( a & (~b) & (~c) & (~d) & e & f & g & (~h) );
assign x[232] = ( (~a) & (~b) & c & (~d) & e & f & (~h) );
assign x[233] = ( x[12] );
assign x[234] = ( a & (~b) & c & d & (~f) & g & (~h) );
assign x[235] = ( b & c & (~d) & (~e) & (~f) & g & h );
assign x[236] = ( x[88] );
assign x[237] = ( a & (~b) & c & (~d) & e & (~g) & h );
assign x[238] = ( (~a) & (~b) & d & (~e) & f & (~g) & (~h) );
assign x[239] = ( x[17] );
assign x[240] = ( x[96] );
assign x[241] = ( (~b) & c & d & (~e) & f & (~g) & h );
assign x[242] = ( (~b) & c & (~d) & e & f & g & h );
assign x[243] = ( (~b) & (~c) & d & (~e) & (~f) & g & h );
assign x[244] = ( x[103] );
assign x[245] = ( x[26] );
assign x[246] = ( x[27] );
assign x[247] = ( a & (~b) & (~c) & e & (~f) & g & h );
assign x[248] = ( x[28] );
assign x[249] = ( a & (~b) & (~c) & (~d) & f & g & h );
assign x[250] = ( x[178] );
assign x[251] = ( x[179] );
assign x[252] = ( a & b & (~c) & d & e & f & g & (~h) );
assign x[253] = ( x[34] );
assign x[254] = ( (~a) & c & d & e & f & g );
assign x[255] = ( x[113] );
assign x[256] = ( c & d & e & (~f) & (~g) & h );
assign x[257] = ( x[115] );
assign x[258] = ( (~c) & (~d) & (~e) & f & (~g) & (~h) );
assign x[259] = ( x[185] );
assign x[260] = ( a & b & c & (~d) & e & (~f) & (~g) );
assign x[261] = ( x[39] );
assign x[262] = ( x[40] );
assign x[263] = ( x[41] );
assign x[264] = ( x[117] );
assign x[265] = ( x[120] );
assign x[266] = ( x[45] );
assign x[267] = ( x[48] );
assign x[268] = ( x[49] );
assign x[269] = ( x[50] );
assign x[270] = ( x[124] );
assign x[271] = ( a & (~b) & (~c) & (~d) & (~e) & f & (~g) );
assign x[272] = ( x[54] );
assign x[273] = ( x[199] );
assign x[274] = ( (~b) & (~c) & d & e & f & (~g) & (~h) );
assign x[275] = ( x[128] );
assign x[276] = ( (~a) & (~c) & (~d) & (~e) & (~f) & g & h );
assign x[277] = ( a & b & d & e & f & g & h );
assign x[278] = ( x[205] );
assign x[279] = ( x[135] );
assign x[280] = ( x[208] );
assign x[281] = ( (~b) & (~d) & (~e) & (~f) & g & (~h) );
assign x[282] = ( a & b & (~d) & e & (~g) & h );
assign x[283] = ( b & (~c) & e & (~f) & g & h );
assign x[284] = ( x[140] );
assign x[285] = ( x[66] );
assign x[286] = ( x[141] );
assign x[287] = ( x[142] );
assign x[288] = ( x[218] );
assign x[289] = ( x[143] );
assign x[290] = ( x[144] );
assign x[291] = ( (~a) & b & c & d & f );
assign x[292] = ( x[222] );
assign x[293] = ( x[75] );
assign x[294] = ( x[76] );


assign o[4] = |(x[294:225]);



assign x[295] = ( x[151] );
assign x[296] = ( a & (~b) & c & d & e & (~f) & (~g) & (~h) );
assign x[297] = ( x[78] );
assign x[298] = ( a & (~b) & c & d & e & (~f) & g & h );
assign x[299] = ( a & b & c & d & (~e) & (~f) & (~h) );
assign x[300] = ( x[2] );
assign x[301] = ( x[154] );
assign x[302] = ( (~a) & b & c & (~d) & e & (~f) & g & h );
assign x[303] = ( x[83] );
assign x[304] = ( x[4] );
assign x[305] = ( a & (~b) & (~c) & d & e & (~g) & h );
assign x[306] = ( x[5] );
assign x[307] = ( x[231] );
assign x[308] = ( x[6] );
assign x[309] = ( a & (~c) & (~d) & e & f & (~g) & h );
assign x[310] = ( x[7] );
assign x[311] = ( x[10] );
assign x[312] = ( x[160] );
assign x[313] = ( (~a) & b & (~c) & (~d) & (~e) & (~g) & (~h) );
assign x[314] = ( x[163] );
assign x[315] = ( x[238] );
assign x[316] = ( (~a) & b & (~d) & e & f & g & (~h) );
assign x[317] = ( a & (~b) & c & (~d) & (~e) & (~f) & g );
assign x[318] = ( a & (~b) & c & d & f & g & (~h) );
assign x[319] = ( x[169] );
assign x[320] = ( x[20] );
assign x[321] = ( x[24] );
assign x[322] = ( x[26] );
assign x[323] = ( a & (~c) & (~d) & (~e) & f & (~g) & (~h) );
assign x[324] = ( x[31] );
assign x[325] = ( x[179] );
assign x[326] = ( a & b & c & d & e & (~f) & g & h );
assign x[327] = ( (~a) & (~b) & (~c) & (~e) & f & (~g) & h );
assign x[328] = ( x[32] );
assign x[329] = ( x[252] );
assign x[330] = ( x[109] );
assign x[331] = ( x[110] );
assign x[332] = ( x[34] );
assign x[333] = ( x[35] );
assign x[334] = ( x[260] );
assign x[335] = ( a & (~c) & (~d) & (~e) & (~f) & (~g) );
assign x[336] = ( x[189] );
assign x[337] = ( x[192] );
assign x[338] = ( b & c & d & (~e) & (~f) & g & h );
assign x[339] = ( (~b) & c & (~e) & f & g & h );
assign x[340] = ( x[48] );
assign x[341] = ( x[195] );
assign x[342] = ( a & (~b) & d & f & g & h );
assign x[343] = ( x[199] );
assign x[344] = ( x[274] );
assign x[345] = ( a & d & (~e) & f & g & h );
assign x[346] = ( x[55] );
assign x[347] = ( x[128] );
assign x[348] = ( x[276] );
assign x[349] = ( x[201] );
assign x[350] = ( a & b & (~c) & (~d) & (~f) & g & h );
assign x[351] = ( (~a) & b & (~c) & d & f & g & h );
assign x[352] = ( x[203] );
assign x[353] = ( a & (~b) & (~c) & d & e & f & g );
assign x[354] = ( x[58] );
assign x[355] = ( x[59] );
assign x[356] = ( x[205] );
assign x[357] = ( x[61] );
assign x[358] = ( x[64] );
assign x[359] = ( a & c & (~e) & f & (~g) & (~h) );
assign x[360] = ( x[65] );
assign x[361] = ( x[66] );
assign x[362] = ( x[215] );
assign x[363] = ( x[218] );
assign x[364] = ( x[69] );
assign x[365] = ( x[143] );
assign x[366] = ( x[144] );
assign x[367] = ( x[71] );
assign x[368] = ( x[72] );
assign x[369] = ( (~a) & b & (~c) & d & e );
assign x[370] = ( (~a) & c & (~d) & (~e) & (~g) & h );
assign x[371] = ( x[224] );
assign x[372] = ( x[76] );


assign o[3] = |(x[372:295]);



assign x[373] = ( x[296] );
assign x[374] = ( x[81] );
assign x[375] = ( (~b) & (~c) & (~d) & (~e) & (~f) & (~g) & h );
assign x[376] = ( (~a) & (~b) & c & e & f & g & h );
assign x[377] = ( x[154] );
assign x[378] = ( x[155] );
assign x[379] = ( x[302] );
assign x[380] = ( x[82] );
assign x[381] = ( x[84] );
assign x[382] = ( x[8] );
assign x[383] = ( x[234] );
assign x[384] = ( (~a) & (~b) & d & e & (~f) & (~g) & (~h) );
assign x[385] = ( x[95] );
assign x[386] = ( x[316] );
assign x[387] = ( x[241] );
assign x[388] = ( x[318] );
assign x[389] = ( x[101] );
assign x[390] = ( x[243] );
assign x[391] = ( (~b) & c & (~d) & (~e) & f & (~g) & h );
assign x[392] = ( x[22] );
assign x[393] = ( x[105] );
assign x[394] = ( x[247] );
assign x[395] = ( x[323] );
assign x[396] = ( a & b & (~c) & d & f & g & h );
assign x[397] = ( x[30] );
assign x[398] = ( x[178] );
assign x[399] = ( x[326] );
assign x[400] = ( x[252] );
assign x[401] = ( x[109] );
assign x[402] = ( (~a) & (~b) & c & (~f) & (~g) & (~h) );
assign x[403] = ( a & b & e & (~f) & g & (~h) );
assign x[404] = ( b & (~c) & e & (~f) & g & (~h) );
assign x[405] = ( x[338] );
assign x[406] = ( x[193] );
assign x[407] = ( x[47] );
assign x[408] = ( x[48] );
assign x[409] = ( x[124] );
assign x[410] = ( x[51] );
assign x[411] = ( x[52] );
assign x[412] = ( x[126] );
assign x[413] = ( x[274] );
assign x[414] = ( x[277] );
assign x[415] = ( x[130] );
assign x[416] = ( x[350] );
assign x[417] = ( x[56] );
assign x[418] = ( x[57] );
assign x[419] = ( x[203] );
assign x[420] = ( x[58] );
assign x[421] = ( x[60] );
assign x[422] = ( x[205] );
assign x[423] = ( x[135] );
assign x[424] = ( x[62] );
assign x[425] = ( x[282] );
assign x[426] = ( (~a) & (~b) & (~e) & f & g & (~h) );
assign x[427] = ( x[63] );
assign x[428] = ( x[137] );
assign x[429] = ( x[210] );
assign x[430] = ( x[139] );
assign x[431] = ( x[67] );
assign x[432] = ( x[68] );
assign x[433] = ( x[141] );
assign x[434] = ( a & (~d) & e & f & (~g) & h );
assign x[435] = ( x[218] );
assign x[436] = ( x[69] );
assign x[437] = ( x[70] );
assign x[438] = ( x[71] );
assign x[439] = ( x[72] );
assign x[440] = ( x[222] );
assign x[441] = ( a & (~d) & (~e) & f & g );
assign x[442] = ( x[370] );
assign x[443] = ( x[148] );
assign x[444] = ( x[75] );
assign x[445] = ( x[76] );


assign o[2] = |(x[445:373]);



assign x[446] = ( x[79] );
assign x[447] = ( a & b & (~c) & d & (~e) & f & (~g) & h );
assign x[448] = ( x[3] );
assign x[449] = ( x[155] );
assign x[450] = ( x[156] );
assign x[451] = ( x[302] );
assign x[452] = ( x[4] );
assign x[453] = ( x[84] );
assign x[454] = ( x[11] );
assign x[455] = ( x[160] );
assign x[456] = ( x[91] );
assign x[457] = ( x[92] );
assign x[458] = ( x[94] );
assign x[459] = ( x[165] );
assign x[460] = ( x[16] );
assign x[461] = ( x[317] );
assign x[462] = ( x[18] );
assign x[463] = ( x[97] );
assign x[464] = ( x[391] );
assign x[465] = ( x[102] );
assign x[466] = ( x[21] );
assign x[467] = ( x[172] );
assign x[468] = ( x[103] );
assign x[469] = ( x[249] );
assign x[470] = ( x[396] );
assign x[471] = ( x[179] );
assign x[472] = ( x[326] );
assign x[473] = ( x[33] );
assign x[474] = ( x[109] );
assign x[475] = ( x[110] );
assign x[476] = ( x[35] );
assign x[477] = ( x[36] );
assign x[478] = ( (~a) & b & (~d) & e & g & (~h) );
assign x[479] = ( (~a) & (~b) & c & d & e & (~g) );
assign x[480] = ( (~b) & (~c) & (~d) & (~f) & g & (~h) );
assign x[481] = ( x[115] );
assign x[482] = ( x[38] );
assign x[483] = ( (~a) & (~b) & (~c) & e & (~f) & g );
assign x[484] = ( x[186] );
assign x[485] = ( x[187] );
assign x[486] = ( x[260] );
assign x[487] = ( x[40] );
assign x[488] = ( x[42] );
assign x[489] = ( x[44] );
assign x[490] = ( x[49] );
assign x[491] = ( x[271] );
assign x[492] = ( x[129] );
assign x[493] = ( x[276] );
assign x[494] = ( x[277] );
assign x[495] = ( x[130] );
assign x[496] = ( x[350] );
assign x[497] = ( x[351] );
assign x[498] = ( x[132] );
assign x[499] = ( x[57] );
assign x[500] = ( x[353] );
assign x[501] = ( x[58] );
assign x[502] = ( x[60] );
assign x[503] = ( x[205] );
assign x[504] = ( x[135] );
assign x[505] = ( x[61] );
assign x[506] = ( x[281] );
assign x[507] = ( x[211] );
assign x[508] = ( x[138] );
assign x[509] = ( x[65] );
assign x[510] = ( x[66] );
assign x[511] = ( x[68] );
assign x[512] = ( x[144] );
assign x[513] = ( x[70] );
assign x[514] = ( (~a) & (~d) & (~e) & f & (~h) );
assign x[515] = ( x[73] );
assign x[516] = ( x[74] );
assign x[517] = ( x[148] );
assign x[518] = ( x[75] );
assign x[519] = ( x[76] );


assign o[1] = |(x[519:446]);



assign x[520] = ( x[447] );
assign x[521] = ( x[1] );
assign x[522] = ( x[81] );
assign x[523] = ( x[82] );
assign x[524] = ( x[5] );
assign x[525] = ( x[231] );
assign x[526] = ( x[9] );
assign x[527] = ( x[232] );
assign x[528] = ( x[161] );
assign x[529] = ( x[13] );
assign x[530] = ( x[235] );
assign x[531] = ( x[384] );
assign x[532] = ( x[90] );
assign x[533] = ( x[313] );
assign x[534] = ( x[15] );
assign x[535] = ( x[93] );
assign x[536] = ( x[237] );
assign x[537] = ( x[242] );
assign x[538] = ( x[102] );
assign x[539] = ( x[103] );
assign x[540] = ( x[25] );
assign x[541] = ( x[26] );
assign x[542] = ( x[28] );
assign x[543] = ( x[176] );
assign x[544] = ( x[31] );
assign x[545] = ( x[178] );
assign x[546] = ( x[326] );
assign x[547] = ( x[327] );
assign x[548] = ( x[32] );
assign x[549] = ( x[252] );
assign x[550] = ( x[33] );
assign x[551] = ( x[110] );
assign x[552] = ( x[35] );
assign x[553] = ( b & c & (~d) & (~e) & f & (~g) );
assign x[554] = ( x[113] );
assign x[555] = ( (~a) & b & (~e) & (~f) & (~g) & h );
assign x[556] = ( x[38] );
assign x[557] = ( x[185] );
assign x[558] = ( a & (~c) & (~e) & (~f) & g & (~h) );
assign x[559] = ( x[186] );
assign x[560] = ( x[187] );
assign x[561] = ( x[39] );
assign x[562] = ( x[117] );
assign x[563] = ( x[189] );
assign x[564] = ( (~b) & (~c) & (~d) & (~e) & f & h );
assign x[565] = ( x[43] );
assign x[566] = ( x[45] );
assign x[567] = ( x[192] );
assign x[568] = ( x[338] );
assign x[569] = ( x[193] );
assign x[570] = ( x[195] );
assign x[571] = ( x[51] );
assign x[572] = ( x[52] );
assign x[573] = ( x[271] );
assign x[574] = ( x[201] );
assign x[575] = ( x[351] );
assign x[576] = ( x[353] );
assign x[577] = ( x[59] );
assign x[578] = ( x[426] );
assign x[579] = ( x[209] );
assign x[580] = ( x[283] );
assign x[581] = ( x[359] );
assign x[582] = ( x[139] );
assign x[583] = ( x[67] );
assign x[584] = ( x[434] );
assign x[585] = ( x[69] );
assign x[586] = ( x[72] );
assign x[587] = ( (~c) & (~d) & e & (~g) & h );
assign x[588] = ( x[73] );
assign x[589] = ( x[370] );
assign x[590] = ( x[224] );
assign x[591] = ( x[76] );


assign o[0] = |(x[591:520]);


endmodule
