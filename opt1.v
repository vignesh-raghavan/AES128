module sbox (
	input [7:0] index,

	output [7:0] o
);

reg [31:0] lu3[0:63]; //Continous assignment of Product terms for each bit of o.
genvar j;

//The following logic for the o are minimized version obtained from logic
//friday.

initial begin
	$readmemh("sbox.hex", lu3);
end

generate
for(j=0; j<8; j= j+1) begin : try
assign o[j] = lu3[8*j + index[7:5] ][ (~(index[4:0])) ];
end
endgenerate

endmodule
