module subbytes (
	input [127:0] istate,

	output [127:0] ostate
);

//reg [7:0] sbox_mem[0:255]; //SBOX
//wire [127:0] tstate;

genvar i;

////Initial statements.
//initial begin
//	$readmemh("SBOX.hex", sbox_mem);
//end

//Sub bytes computation for Encryption
generate
	for(i = 0; i < 16; i = i+1) begin : sub_bytes
		//assign tstate[8*i+7 : 8*i] = sbox_mem [ istate[8*i+7 : 8*i] ];

		sbox inst(.index(istate[8*i+7 : 8*i]),
					 
					 .o(ostate[8*i+7 : 8*i])
			  		);
	end
endgenerate


endmodule
