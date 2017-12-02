module aes (
	input clock,
	input resetn,

	input enable,
	input [127:0] i_text,
	input [127:0] key,
	input [3:0] round,

	output reg [127:0] o_text,
	output reg [127:0] Rkey,
	output done
);

reg [7:0] index;
wire [7:0] byteout;

reg [4:0] bytecounter;
reg [4:0] bytecounter_next;
reg [127:0] tstate;

reg [127:0] subbytes_text;
wire [127:0] roundkey_text;
wire [127:0] shiftrows_text;
wire [127:0] mixcolumns_text;

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

always @(posedge clock) begin
	if(!resetn) begin
		bytecounter <= 5'h0;
	end
	else begin
		bytecounter <= bytecounter_next;
	end
end


always @(bytecounter or enable or i_text or byteout or key or round) begin
	
	if((bytecounter == 5'h0)) begin
		if(enable) begin
			index = i_text[127:120];
			tstate[127:120] = byteout;
		end
		else begin
			tstate = 128'h0;
			tkey = 32'h0;
		end
	end
	else if((bytecounter == 5'h1)) begin
		index = i_text[119:112];
		tstate[119:112] = byteout;
	end
	else if((bytecounter == 5'h2)) begin
		index = i_text[111:104];
		tstate[111:104] = byteout;
	end
	else if((bytecounter == 5'h3)) begin
		index = i_text[103:96];
		tstate[103:96] = byteout;
	end
	else if((bytecounter == 5'h4)) begin
		index = i_text[95:88];
		tstate[95:88] = byteout;
	end	
	else if((bytecounter == 5'h5)) begin
		index = i_text[87:80];
		tstate[87:80] = byteout;
	end	
	else if((bytecounter == 5'h6)) begin
		index = i_text[79:72];
		tstate[79:72] = byteout;
	end	
	else if((bytecounter == 5'h7)) begin
		index = i_text[71:64];
		tstate[71:64] = byteout;
	end	
	else if((bytecounter == 5'h8)) begin
		index = i_text[63:56];
		tstate[63:56] = byteout;
	end	
	else if((bytecounter == 5'h9)) begin
		index = i_text[55:48];
		tstate[55:48] = byteout;
	end	
	else if((bytecounter == 5'hA)) begin
		index = i_text[47:40];
		tstate[47:40] = byteout;
	end	
	else if((bytecounter == 5'hB)) begin
		index = i_text[39:32];
		tstate[39:32] = byteout;
	end	
	else if((bytecounter == 5'hC)) begin
		index = i_text[31:24];
		tstate[31:24] = byteout;
	end	
	else if((bytecounter == 5'hD)) begin
		index = i_text[23:16];
		tstate[23:16] = byteout;
	end	
	else if((bytecounter == 5'hE)) begin
		index = i_text[15:8];
		tstate[15:8] = byteout;
	end
	else if((bytecounter == 5'hF)) begin
		index = i_text[7:0];
		tstate[7:0] = byteout;
	end
	else if((bytecounter == 5'h10)) begin
		index = key[111 : 104]; //8*13+7 : 8*13
		tkey[7 : 0] = byteout ^ key[7 : 0] ^ Rcon[round];
	end	
	else if((bytecounter == 5'h11)) begin
		index = key[119 : 112]; //8*14+7 : 8*14
		tkey[15 : 8] = byteout ^ key[15 : 8];
	end
	else if((bytecounter == 5'h12)) begin
		index = key[127 : 120]; //8*15+7 : 8*15
		tkey[23 : 16] = byteout ^ key[23 : 16];
	end
	else if((bytecounter == 5'h13)) begin
		index = key[103 : 96]; //8*12+7 : 8*12
		tkey[31 : 24] = byteout ^ key[31 : 24];
	end
	
	
	if((bytecounter == 5'h13)) begin
		bytecounter_next = 5'h0;
	end
	else if( ((bytecounter == 5'h0) & enable) || (|(bytecounter)) ) begin
		bytecounter_next = bytecounter + 5'h1;
	end
	else begin
		bytecounter_next = bytecounter;
	end

end

//SBOX lookup
sbox inst(.index(index),

			 .o(byteout)
	  		);


always @(posedge clock) begin
	if(!resetn) begin
		subbytes_text <= 128'h0;
	end
	else if(bytecounter == 5'hF) begin
		subbytes_text <= tstate;
	end
end


//Shift Rows for Encryption
shiftrows U2 (.istate(subbytes_text), .ostate(shiftrows_text));

//Mix Columns for Encryption
mixcolumns U3 (.istate(shiftrows_text), .bypass(round==4'h9), .ostate(mixcolumns_text));

//Key Expansion for Encryption
assign okey[31:0] = tkey[31:0];
assign okey[127:32] = key[127:32] ^ okey[95:0];

//Add Roundkey for Encryption
assign roundkey_text = mixcolumns_text ^ okey;


assign done = (bytecounter == 5'h13) ? 1'b1 : 1'b0;

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
