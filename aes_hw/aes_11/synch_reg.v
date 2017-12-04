module synch_reg #(parameter wbits = 128) (
	input clock,
	input resetn,

	input wen,
	input ren,
	input [wbits-1:0] wdata,
	output [wbits-1:0] rdata,

	output reg full,
	output empty
);

reg [wbits-1:0] mem;

always @(posedge clock) begin
	if(!resetn) begin
		full <= 1'b0;
		mem <= 128'h0;
	end
	else if(wen & (~full)) begin
		full <= 1'b1;
		mem <= wdata;
	end
	else if(ren & full) begin
		full <= 1'b0;
	end
end

assign empty = ~full;

assign rdata = mem;

endmodule
