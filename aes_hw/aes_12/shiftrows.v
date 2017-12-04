module shiftrows (
	input [127:0] istate,

	output [127:0] ostate
);

genvar i;

// state[0]  = state[0]
// state[4]  = state[4]
// state[8]  = state[8]
// state[12] = state[12]
generate
	for(i = 0; i < 16; i = i+4) begin : shift0
		assign ostate[8*i+7 : 8*i] = istate[8*i+7 : 8*i];
	end
endgenerate


// state[1]  = state[5]
// state[5]  = state[9]
// state[9]  = state[13]
// state[13] = state[1]
generate
	for(i = 1; i < 13; i = i+4) begin : shift1
		assign ostate[8*i+7 : 8*i] = istate[8*(i+4)+7 : 8*(i+4)];
	end
endgenerate
			
		assign ostate[8*13+7 : 8*13] = istate[8*1+7 : 8*1];


// state[2]  = state[10]
// state[6]  = state[14]
// state[10] = state[2]
// state[14] = state[6]
generate
	for(i = 2; i < 7; i = i+4) begin : shift2
		assign ostate[8*i+7 : 8*i] = istate[8*(i+8)+7 : 8*(i+8)];
	end
endgenerate

generate
	for(i = 10; i < 16; i = i+4) begin : shift3
		assign ostate[8*i+7 : 8*i] = istate[8*(i-8)+7 : 8*(i-8)];
	end
endgenerate


// state[7]  = state[3]
// state[11] = state[7]
// state[15] = state[11]
// state[3]  = state[15]
generate
	for(i = 7; i < 16; i = i+4) begin : shift4
		assign ostate[8*i+7 : 8*i] = istate[8*(i-4)+7 : 8*(i-4)];
	end
endgenerate

		assign ostate[8*3+7 : 8*3] = istate[8*15+7 : 8*15];


endmodule
