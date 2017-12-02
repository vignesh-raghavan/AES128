module tbox0 (
	input [7:0] index,

	output [23:0] tbox
);

reg [15:0] mem[0:255];

wire [15:0] temp;

initial begin
	$readmemh("T0.hex", mem);
end

assign temp = mem[index];

assign tbox = {temp[15:8] ^ temp[7:0], temp};

endmodule
