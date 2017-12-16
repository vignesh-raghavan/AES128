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

reg [4:0] counter;
reg [4:0] counter_next;

reg [7:0] t3_in;

reg [31:0] t0_out;
reg [31:0] t1_out;
reg [31:0] t2_out;
wire [31:0] t3_out;

wire [31:0] m_text;

genvar i;

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
		counter <= 5'h0;
	end
	else begin
		counter <= counter_next;
	end
end




//Shift Rows for Encryption
shiftrows U2 (.istate(i_text), .ostate(shiftrows_text));


//TBOX (SBOX) lookup for Encryption
always @(counter or enable or shiftrows_text or key or round or t3_out or m_text) begin

	if(~enable & (counter == 5'h0)) begin
		counter_next = 5'h0;
	end
	else if(enable & (counter == 5'h0)) begin
		counter_next = counter + 5'h1;
	end
	else if((counter != 5'h14)) begin
		counter_next = counter + 5'h1;
	end
	else begin
		counter_next = 5'h0;
	end


	case(counter)

		5'h0 : begin t3_in = enable ? shiftrows_text[7:0] : 32'h0; end
		5'h1 : begin t3_in = shiftrows_text[15:8 ]; end
		5'h2 : begin t3_in = shiftrows_text[23:16]; end
		5'h3 : begin t3_in = shiftrows_text[31:24]; end

		5'h4 : begin t3_in = shiftrows_text[39:32]; end 
		5'h5 : begin t3_in = shiftrows_text[47:40]; end 
		5'h6 : begin t3_in = shiftrows_text[55:48]; end 
		5'h7 : begin t3_in = shiftrows_text[63:56]; end 
		
		5'h8 : begin t3_in = shiftrows_text[71:64]; end
		5'h9 : begin t3_in = shiftrows_text[79:72]; end
		5'hA : begin t3_in = shiftrows_text[87:80]; end
		5'hB : begin t3_in = shiftrows_text[95:88]; end

		5'hC : begin t3_in = shiftrows_text[103:96 ]; end
		5'hD : begin t3_in = shiftrows_text[111:104]; end
		5'hE : begin t3_in = shiftrows_text[119:112]; end
		5'hF : begin t3_in = shiftrows_text[127:120]; end

		5'h10 : begin t3_in = key[111 : 104]; end  //8*13+7 : 8*13
		5'h11 : begin t3_in = key[119 : 112]; end  //8*14+7 : 8*14
		5'h12 : begin t3_in = key[127 : 120]; end  //8*15+7 : 8*15
		5'h13 : begin t3_in = key[103 : 96 ]; end  //8*12+7 : 8*12

		default : begin t3_in = 8'h0; end

	endcase


//	case(counter)
//
//		5'h0 : begin t0_out = enable ? t3_out : 32'h0;
//						 t1_out = 32'h0;
//						 t2_out = 32'h0;
//						 mixcolumns_text = 128'h0;
//						 tkey = 32'h0;
//			    end
//		5'h1 : begin t1_out = t3_out; end
//		5'h2 : begin t2_out = t3_out; end
//		5'h3 : begin mixcolumns_text[31:0] = m_text; end
//		
//		5'h4 : begin t0_out = t3_out; end
//		5'h5 : begin t1_out = t3_out; end
//		5'h6 : begin t2_out = t3_out; end
//		5'h7 : begin mixcolumns_text[63:32] = m_text; end
//
//		5'h8 : begin t0_out = t3_out; end
//		5'h9 : begin t1_out = t3_out; end
//		5'hA : begin t2_out = t3_out; end
//		5'hB : begin mixcolumns_text[95:64] = m_text; end
//
//		5'hC : begin t0_out = t3_out; end
//		5'hD : begin t1_out = t3_out; end
//		5'hE : begin t2_out = t3_out; end
//		5'hF : begin mixcolumns_text[127:96] = m_text; end
//		
//		5'h10 : begin tkey[7 : 0]   = t3_out[15:8] ^ key[7 : 0] ^ Rcon[round]; end  //8*13+7 : 8*13
//		5'h11 : begin tkey[15 : 8]  = t3_out[15:8] ^ key[15 : 8];  end  //8*14+7 : 8*14
//		5'h12 : begin tkey[23 : 16] = t3_out[15:8] ^ key[23 : 16]; end  //8*15+7 : 8*15
//		5'h13 : begin tkey[31 : 24] = t3_out[15:8] ^ key[31 : 24]; end  //8*12+7 : 8*12
//
//		default : begin t0_out = 32'h0;
//							 t1_out = 32'h0;
//							 t2_out = 32'h0;
//							 t3_out = 32'h0;
//							 mixcolumns_text = 128'h0;
//							 tkey = 32'h0;
//					 end
//
//	endcase

end

always @(posedge clock) begin
	if(!resetn) begin
		t0_out <= 32'h0;
	end
	else if((counter == 5'h0) & enable) begin
		t0_out <= t3_out;
	end
	else if((counter == 5'h4)) begin
		t0_out <= t3_out;
	end
	else if((counter == 5'h8)) begin
		t0_out <= t3_out;
	end
	else if((counter == 5'hC)) begin
		t0_out <= t3_out;
	end
end


always @(posedge clock) begin
	if(!resetn) begin
		t1_out <= 32'h0;
	end
	else if((counter == 5'h1)) begin
		t1_out <= t3_out;
	end
	else if((counter == 5'h5)) begin
		t1_out <= t3_out;
	end
	else if((counter == 5'h9)) begin
		t1_out <= t3_out;
	end
	else if((counter == 5'hD)) begin
		t1_out <= t3_out;
	end
end

always @(posedge clock) begin
	if(!resetn) begin
		t2_out <= 32'h0;
	end
	else if((counter == 5'h2)) begin
		t2_out <= t3_out;
	end
	else if((counter == 5'h6)) begin
		t2_out <= t3_out;
	end
	else if((counter == 5'hA)) begin
		t2_out <= t3_out;
	end
	else if((counter == 5'hE)) begin
		t2_out <= t3_out;
	end
end

always @(posedge clock) begin
	if(!resetn) begin
		mixcolumns_text <= 128'h0;
	end
	else if((counter == 5'h3)) begin
		mixcolumns_text <= {m_text, mixcolumns_text[127:32]};
	end
	else if((counter == 5'h7)) begin
		mixcolumns_text <= {m_text, mixcolumns_text[127:32]};
	end
	else if((counter == 5'hB)) begin
		mixcolumns_text <= {m_text, mixcolumns_text[127:32]};
	end
	else if((counter == 5'hF)) begin
		mixcolumns_text <= {m_text, mixcolumns_text[127:32]};
	end
end

always @(posedge clock) begin
	if(!resetn) begin
		tkey <= 32'h0;
	end
	else if((counter == 5'h10)) begin
		tkey <= {t3_out[15:8] ^ key[7 : 0] ^ Rcon[round], tkey[31:8]};
	end
	else if((counter == 5'h11)) begin
		tkey <= {t3_out[15:8] ^ key[15 : 8], tkey[31:8]};
	end
	else if((counter == 5'h12)) begin
		tkey <= {t3_out[15:8] ^ key[23 : 16], tkey[31:8]};
	end
	else if((counter == 5'h13)) begin
		tkey <= {t3_out[15:8] ^ key[31 : 24], tkey[31:8]};
	end
end

assign m_text = (round == 4'h9) ? {t3_out[15:8], t2_out[15:8], t1_out[15:8], t0_out[15:8]} : t0_out ^ {t1_out[23:0], t1_out[31:24]} ^ {t2_out[15:0], t2_out[31:16]} ^ {t3_out[7:0], t3_out[31:8]};


//Key Expansion for Encryption
assign okey[31:0] = tkey[31:0];
assign okey[127:32] = key[127:32] ^ okey[95:0];

//Add Roundkey for Encryption
assign roundkey_text = mixcolumns_text ^ okey;

//TBOX (SBOX) lookup
tbox0 T3 (.index(t3_in), .tbox(t3_out));



assign done = (counter == 5'h14) ? 1'b1 : 1'b0;

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
