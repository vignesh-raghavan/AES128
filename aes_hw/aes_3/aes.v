module aes (
	input clock,
	input resetn,

	input enable,
	input [127:0] i_text,
	input [127:0] key,
	input [3:0] round,

	output reg [127:0] o_text,
	output reg [127:0] Rkey,
	output reg done
);

reg [127:0] subbytes_text;
wire [127:0] roundkey_text;
wire [127:0] shiftrows_text;
reg [127:0] mixcolumns_text;

wire [127:0] okey;
reg [31:0] tkey;

reg [7:0] Rcon[0:9]; //Round Constant

initial begin
	Rcon[0] = 8'h01;
	Rcon[1] = 8'h02;
	Rcon[2] = 8'h04;
	Rcon[3] = 8'h08;
	Rcon[4] = 8'h10;
	Rcon[5] = 8'h20;
	Rcon[6] = 8'h40;
	Rcon[7] = 8'h80;
	Rcon[8] = 8'h1b;
	Rcon[9] = 8'h36;
end

reg [3:0] scounter;
reg [3:0] scounter_next;

reg sbox_en;
reg [159:0] sbox_in;
wire [159:0] sbox_out;
wire sbox_done;

reg mix_en;
reg [31:0] mix_in;
wire [31:0] mix_out;
wire mix_done;

always @(posedge clock) begin
	if(!resetn) begin
		scounter <= 4'h0;
	end
	else begin
		scounter <= scounter_next;
	end
end

always @(scounter or enable or i_text or key or round or sbox_out or sbox_done or shiftrows_text or mix_out or mix_done) begin

	done = 1'b0;

	if((scounter == 4'h0)) begin
		if(enable) begin
			sbox_en = 1'b1;
			sbox_in = { i_text, key[103:96], key[127:104] }; 
			scounter_next = scounter + 4'h1;
			mix_en = 1'b0;
			mix_in = 32'h0;
		end
		else begin
			sbox_en = 1'b0;
			sbox_in = 160'h0;
			scounter_next = 4'h0;
			tkey = 32'h0;
			mix_en = 1'b0;
			mix_in = 32'h0;
			mixcolumns_text = 128'h0;
		end
	end
	else if((scounter == 4'h1)) begin
		if(sbox_done) begin
			scounter_next = scounter + 4'h1;
			tkey[7 : 0]   = sbox_out[7:0]   ^ key[7 : 0] ^ Rcon[round];
			tkey[15 : 8]  = sbox_out[15:8]  ^ key[15 : 8];
			tkey[23 : 16] = sbox_out[23:16] ^ key[23 : 16];
			tkey[31 : 24] = sbox_out[31:24] ^ key[31 : 24];
		end
	end
	else if((scounter == 4'h2)) begin
		sbox_en = 1'b0;
		if(round == 4'h9) begin
			mix_en = 1'b0;
			mixcolumns_text = shiftrows_text;
			scounter_next = 4'h0;
			done = 1'b1;
		end
		else begin
			mix_en = 1'b1;
			mix_in = shiftrows_text[31:0];
			scounter_next = scounter + 4'h1;
		end
	end
	else if((scounter == 4'h3)) begin
		if(mix_done) begin
			mixcolumns_text[31:0] = mix_out;
			scounter_next = scounter + 4'h1;
		end
	end
	else if((scounter == 4'h4)) begin
		sbox_en = 1'b0;
		mix_en = 1'b1;
		mix_in = shiftrows_text[63:32];
		scounter_next = scounter + 4'h1;
	end
	else if((scounter == 4'h5)) begin
		if(mix_done) begin
			mixcolumns_text[63:32] = mix_out;
			scounter_next = scounter + 4'h1;
		end
	end
	else if((scounter == 4'h6)) begin
		sbox_en = 1'b0;
		mix_en = 1'b1;
		mix_in = shiftrows_text[95:64];
		scounter_next = scounter + 4'h1;
	end
	else if((scounter == 4'h7)) begin
		if(mix_done) begin
			mixcolumns_text[95:64] = mix_out;
			scounter_next = scounter + 4'h1;
		end
	end
	else if((scounter == 4'h8)) begin
		sbox_en = 1'b0;
		mix_en = 1'b1;
		mix_in = shiftrows_text[127:96];
		scounter_next = scounter + 4'h1;
	end
	else if((scounter == 4'h9)) begin
		if(mix_done) begin
			mixcolumns_text[127:96] = mix_out;
			scounter_next = 4'h0;
			done = 1'b1;
		end
	end		
end


//SBOX lookup
sbox inst ( .clk(clock),
				.resetn(resetn),

				.enable(sbox_en),
				.index(sbox_in),

				.sbout(sbox_out),
				.done(sbox_done)
			 );


always @(posedge clock) begin
	if(!resetn) begin
		subbytes_text <= 128'h0;
	end
	else if((scounter == 5'h1) & sbox_done) begin
		subbytes_text <= sbox_out[159:32];
	end
end


//Shift Rows for Encryption
shiftrows U2 (.istate(subbytes_text), .ostate(shiftrows_text));

//Mix Columns for Encryption
mixcolumns U3 (.clock(clock), .resetn(resetn), .enable(mix_en), .istate(mix_in), .ostate(mix_out), .done(mix_done));

//Key Expansion for Encryption
assign okey[31:0] = tkey[31:0];
assign okey[127:32] = key[127:32] ^ okey[95:0];

//Add Roundkey for Encryption
assign roundkey_text = mixcolumns_text ^ okey;


always @(posedge clock) begin
	if(!resetn) begin
		o_text <= 128'h0;
		Rkey <= 128'h0f0e0d0c0b0a09080706050403020100;
	end
	else if(done & (round == 4'h9)) begin
		o_text <= roundkey_text;
		Rkey <= 128'h0f0e0d0c0b0a09080706050403020100;
	end
	else if(done) begin
		o_text <= roundkey_text;
		Rkey <= okey;
	end
end


endmodule
