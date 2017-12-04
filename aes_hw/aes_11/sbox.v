module sbox (
	input [7:0] index,

	output [7:0] o
);

reg [7:0] mem[0:255];

initial begin
	$readmemh("SBOX.hex", mem);
end

assign o = mem[ index ];

endmodule
