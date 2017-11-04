module aes_slave_intf (
   input clock,
	input resetn,

	input chipselect,
	input [10:0] address,
	
	input read,
	output reg [31:0] readdata,
	
	input write,
	input [31:0] writedata,

	output waitrequest,
	
	output [31:0] debugbus
);

reg [127:0] plain_text;
wire [127:0] cipher_text;

reg [31:0] aes_control;

wire plain_text_write;
reg plain_text_complete;
wire aes_control_write;

reg [1:0] icounter;

//reg [7:0] isbox_mem[0:255]; //SBOX Inverse

reg [3:0] ecounter;
reg [3:0] ecounter_next;

reg enable;
reg [127:0] i_text;
reg [3:0] round;
wire [127:0] o_text;
wire [127:0] Rkey;

////Initial statements.
//initial begin
//	$readmemh("ISBOX.hex", isbox_mem);
//end




//Continous Assignment statements.
assign plain_text_write = chipselect & write & (address == 11'h0);
assign aes_control_write = chipselect & write & (address == 11'h8);




always @(posedge clock) begin
	if(!resetn) begin
		icounter <= 2'h0;
	end
	else if(plain_text_write) begin
		icounter <= icounter + 2'h1;
	end
end


always @(posedge clock) begin
	if(!resetn) begin
		plain_text <= 128'h0;
		plain_text_complete <= 1'b0;
	end
	else if((icounter == 2'h0) & plain_text_write) begin // & ~waitrequest
		plain_text <= {96'h0, writedata};
	end
	else if((icounter == 2'h1) & plain_text_write) begin // & ~waitrequest
		plain_text <= {plain_text[95:0], writedata};
	end
	else if((icounter == 2'h2) & plain_text_write) begin // & ~waitrequest
		plain_text <= {plain_text[95:0], writedata};
	end
	else if((icounter == 2'h3) & plain_text_write) begin // & ~waitrequest
		plain_text <= {plain_text[95:0], writedata};
		plain_text_complete <= 1'b1;
	end
	else begin
		plain_text_complete <= 1'b0;
	end
end






always @(posedge clock) begin
	if(!resetn) begin
		ecounter <= 4'h0;
	end
	else begin
		ecounter <= ecounter_next;
	end
end

//Multiple rounds - 10 for 128bit encryption.
always @(ecounter or plain_text_complete or plain_text or o_text or Rkey) begin
	ecounter_next = ecounter; //Keep the same state.
	enable = 1'b0;
	round = 4'h0;
	i_text = 128'h0;

	if( (ecounter == 4'h0) || (ecounter == 4'hA)) begin
		if(plain_text_complete) begin
			ecounter_next = 4'h1;
			enable = 1'b1;
			round = 4'h0;
			i_text = plain_text ^ Rkey; //First Addroundkey for Encryption. //XOR Initialization Vector here..
		end
	end
	else begin
		ecounter_next = ecounter + 4'h1;
		enable = 1'b1;
		round = ecounter;
		i_text = o_text;
	end
end

//Compute AES cipher for one round.
aes aes0 (
	.clock(clock),
	.resetn(resetn),

	.enable(enable),

	.i_text(i_text),
	.key(Rkey),
	.round(round),

	.o_text(o_text),
	.Rkey(Rkey)
);


always @(posedge clock) begin
	if(!resetn) begin
		aes_control <= 32'h1;
	end
	else if(aes_control_write) begin
		aes_control <= writedata;
	end
end


assign cipher_text = (ecounter==4'hA) ? o_text : cipher_text;



//Reading Out Cipher
always @(cipher_text or chipselect or read or address) begin
	readdata = 32'h0;

	if(chipselect & read) begin
		case(address)
		11'h4 : begin
					readdata = cipher_text[127:96];
				  end
		11'h5 : begin
					readdata = cipher_text[95:64];
				  end
		11'h6 : begin
					readdata = cipher_text[63:32];
				  end
		11'h7 : begin
					readdata = cipher_text[31:0];
				  end
		endcase
	end
end

assign waitrequest = 1'b0;

endmodule
