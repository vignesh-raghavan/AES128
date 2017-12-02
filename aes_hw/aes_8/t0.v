module tbox0 (
	input [7:0] index,

	output [31:0] tbox
);

reg [7:0] mem[0:255];

wire [7:0] sbox;
wire [7:0] galois;

initial begin
	$readmemh("T0.hex", mem);
end

assign sbox = mem[index];
assign galois = {sbox[6:0], 1'b0} ^ (sbox[7] ? 8'h1b : 8'h00);

assign tbox = {galois ^ sbox, sbox, sbox, galois};

endmodule
