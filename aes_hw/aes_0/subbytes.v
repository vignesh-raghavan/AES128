module subbytes (
	input [127:0] istate,

	output [127:0] ostate
);

genvar i;

//Sub bytes computation for Encryption
generate
	for(i = 0; i < 16; i = i+1) begin : sub_bytes

		sbox inst(.index(istate[8*i+7 : 8*i]),
					 
					 .o(ostate[8*i+7 : 8*i])
			  		);
	end
endgenerate


endmodule
