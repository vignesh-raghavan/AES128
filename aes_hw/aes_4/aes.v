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

wire [127:0] roundkey_text;
wire [127:0] shiftrows_text;
reg [127:0] mixcolumns_text;

wire [127:0] okey;
reg [31:0] tkey;

reg [7:0] Rcon[0:9]; //Round Constant

reg [2:0] counter;
reg [2:0] counter_next;

reg [7:0] t0_in;
reg [7:0] t1_in;
reg [7:0] t2_in;
reg [7:0] t3_in;

wire [31:0] t0_out;
wire [31:0] t1_out;
wire [31:0] t2_out;
wire [31:0] t3_out;


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
		counter <= 3'h0;
	end
	else begin
		counter <= counter_next;
	end
end




//Shift Rows for Encryption
shiftrows U2 (.istate(i_text), .ostate(shiftrows_text));


//TBOX (SBOX) lookup for Encryption
always @(counter or enable or shiftrows_text or key or round or t0_out or t1_out or t2_out or t3_out) begin
	
	if((counter == 3'h0)) begin
		if(enable) begin
			t0_in = shiftrows_text[7:0];
			t1_in = shiftrows_text[15:8];	
			t2_in = shiftrows_text[23:16];
			t3_in = shiftrows_text[31:24];
			if(round == 4'h9) begin
				mixcolumns_text[31:0] = {t3_out[7:0], t2_out[7:0], t1_out[23:16], t0_out[23:16]};
			end
			else begin
				mixcolumns_text[31:0] = t0_out ^ t1_out ^ t2_out ^ t3_out;
			end
			counter_next = counter + 3'h1;
		end
		else begin
			t0_in = 32'h0;
			t1_in = 32'h0;
			t2_in = 32'h0;
			t3_in = 32'h0;
			mixcolumns_text = 128'h0;
			tkey = 32'h0;
			counter_next = 3'h0;
		end
	end
	else if((counter == 3'h1)) begin
		t0_in = shiftrows_text[39:32];
		t1_in = shiftrows_text[47:40];	
		t2_in = shiftrows_text[55:48];
		t3_in = shiftrows_text[63:56];
		if(round == 4'h9) begin
			mixcolumns_text[63:32] = {t3_out[7:0], t2_out[7:0], t1_out[23:16], t0_out[23:16]};
		end
		else begin
			mixcolumns_text[63:32] = t0_out ^ t1_out ^ t2_out ^ t3_out;
		end
		counter_next = counter + 3'h1;
	end
	else if((counter == 3'h2)) begin
		t0_in = shiftrows_text[71:64];
		t1_in = shiftrows_text[79:72];	
		t2_in = shiftrows_text[87:80];
		t3_in = shiftrows_text[95:88];
		if(round == 4'h9) begin
			mixcolumns_text[95:64] = {t3_out[7:0], t2_out[7:0], t1_out[23:16], t0_out[23:16]};
		end
		else begin
			mixcolumns_text[95:64] = t0_out ^ t1_out ^ t2_out ^ t3_out;
		end
		counter_next = counter + 3'h1;
	end
	else if((counter == 3'h3)) begin
		t0_in = shiftrows_text[103:96];
		t1_in = shiftrows_text[111:104];	
		t2_in = shiftrows_text[119:112];
		t3_in = shiftrows_text[127:120];
		if(round == 4'h9) begin
			mixcolumns_text[127:96] = {t3_out[7:0], t2_out[7:0], t1_out[23:16], t0_out[23:16]};
		end
		else begin
			mixcolumns_text[127:96] = t0_out ^ t1_out ^ t2_out ^ t3_out;
		end
		counter_next = counter + 3'h1;
	end
	else if((counter == 3'h4)) begin
		t0_in = key[111 : 104]; //8*13+7 : 8*13
		t1_in = key[119 : 112]; //8*14+7 : 8*14
		t2_in = key[127 : 120]; //8*15+7 : 8*15
		t3_in = key[103 : 96];  //8*12+7 : 8*12


		tkey[7 : 0]   = t0_out[23:16] ^ key[7 : 0] ^ Rcon[round];
		tkey[15 : 8]  = t1_out[23:16] ^ key[15 : 8];
		tkey[23 : 16] = t2_out[7:0] ^ key[23 : 16];
		tkey[31 : 24] = t3_out[7:0] ^ key[31 : 24];
		counter_next = 3'h0;
	end
end


//Key Expansion for Encryption
assign okey[31:0] = tkey[31:0];
assign okey[127:32] = key[127:32] ^ okey[95:0];

//Add Roundkey for Encryption
assign roundkey_text = mixcolumns_text ^ okey;

//TBOX (SBOX) lookup
tbox0 T0 (.index(t0_in), .tbox(t0_out));
tbox1 T1 (.index(t1_in), .tbox(t1_out));
tbox2 T2 (.index(t2_in), .tbox(t2_out));
tbox3 T3 (.index(t3_in), .tbox(t3_out));

assign done = (counter == 3'h4) ? 1'b1 : 1'b0;

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
