module aes (
	input clock,
	input resetn,

	input enable,

	input [127:0] i_text,
	input [127:0] key,
	input [3:0] round,

	output reg [127:0] o_text,
	output reg [127:0] Rkey
);

wire [127:0] okey;

wire [127:0] subbytes_text;
wire [127:0] roundkey_text;
wire [127:0] shiftrows_text;
wire [127:0] mixcolumns_text;


//Sub bytes computation for Encryption
subbytes U1 (.istate(i_text), .ostate(subbytes_text));

//Shift Rows for Encryption
shiftrows U2 (.istate(subbytes_text), .ostate(shiftrows_text));

//Mix Columns for Encryption
mixcolumns U3 (.istate(shiftrows_text), .bypass(round==4'h9), .ostate(mixcolumns_text));

//Key Expansion for Encryption
keyexpand U4 (.ikey(key), .round(round), .okey(okey));

//Add Roundkey for Encryption
addroundkey U5 (.istate(mixcolumns_text), .key(okey), .ostate(roundkey_text));

always @(posedge clock) begin
	if(!resetn) begin
		o_text <= 128'h0;
		Rkey <= 128'h0f0e0d0c0b0a09080706050403020100;
	end
	else if(enable & (round == 4'h9)) begin
		o_text <= roundkey_text;
		Rkey <= 128'h0f0e0d0c0b0a09080706050403020100;
	end
	else if(enable) begin
		o_text <= roundkey_text;
		Rkey <= okey;
	end
end

endmodule
