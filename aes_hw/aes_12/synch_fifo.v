module synch_fifo #(parameter wbits = 128, abits = 2) (
	input clock,
	input resetn,

	input wen,
	input ren,
	input [wbits-1:0] wdata,
	output [wbits-1:0] rdata,

	output full,
	output empty
);

reg [abits:0] wptr;
reg [abits:0] rptr;

reg [wbits-1:0] fifofile [0 : 2**abits-1];

reg [wbits-1:0] fout;

assign full = (wptr[abits-1:0] == rptr[abits-1:0]) & (wptr[abits] != rptr[abits]);
assign empty = (wptr == rptr);

always @(posedge clock) begin
	if(!resetn) begin
		wptr <= 'h0;
		rptr <= 'h0;
	end
	else  begin
		if(wen & ~full) begin
			fifofile[wptr[abits-1:0]] <= wdata;
			wptr <= wptr + 'h1;
		end
		if(ren & ~empty) begin
			rptr <= rptr + 'h1;
		end
	end
end

assign rdata = fifofile[rptr[abits-1:0]];

endmodule
