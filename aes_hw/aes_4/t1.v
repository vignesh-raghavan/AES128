module tbox1 (
	input [7:0] index,

	output [31:0] tbox
);

reg [31:0] mem[0:255];

initial begin
	$readmemh("T1.hex", mem);
end

assign tbox = mem[index];

endmodule
