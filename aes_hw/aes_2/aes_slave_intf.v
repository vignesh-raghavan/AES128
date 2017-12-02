module aes_slave_intf (
   input clock,
	input resetn,

	input chipselect,
	input [3:0] address,
	
	input read,
	output reg [31:0] readdata,
	
	input write,
	input [31:0] writedata,

	output waitrequest
);

reg [127:0] plain_text;
reg [127:0] cipher_text;


wire plain_text_write;
reg plain_text_complete;

reg [1:0] icounter;

reg [4:0] ecounter;
reg [4:0] ecounter_next;

reg enable;
reg [127:0] i_text;
wire [3:0] round;
wire [127:0] o_text;
wire [127:0] Rkey;

wire done;

wire cipher_text_read;
reg [1:0] ocounter;
reg cipher_available;
wire cipher_status_read;



assign plain_text_write = chipselect & write & (address == 4'h0);


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
		plain_text_complete <= 1'b0;
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
		ecounter <= 5'h0;
	end
	else begin
		ecounter <= ecounter_next;
	end
end

//Multiple rounds - 10 for 128bit encryption.
always @(ecounter or plain_text_complete or o_text or plain_text or Rkey or done) begin

	if( (ecounter == 5'h0) ) begin
		cipher_text = o_text;
		if(plain_text_complete) begin
			enable = 1'b1;
			i_text = plain_text ^ Rkey;
			ecounter_next = 5'h1;
		end
		else begin
			enable = 1'b0;
			i_text = 128'h0;
			ecounter_next = ecounter;
		end
	end
	else if( (ecounter == 5'h13) ) begin
		enable = 1'b0;
		if(done) begin
			ecounter_next = 5'h0;
		end
	end
	else if( (ecounter[0]) ) begin
		enable = 1'b0;
		if(done) begin
			ecounter_next = ecounter + 5'h1;
		end
	end
	else if( (!ecounter[0]) )begin
		enable = 1'b1;
		i_text = o_text;
		ecounter_next = ecounter + 5'h1;
	end

end


assign round = ecounter[4:1];

//Compute AES cipher for one round.
aes aes0 (
	.clock(clock),
	.resetn(resetn),

	.enable(enable),

	.i_text(i_text),
	.key(Rkey),
	.round(round),

	.o_text(o_text),
	.Rkey(Rkey),

	.done(done)
);



always @(posedge clock) begin
	if(!resetn) begin
		cipher_available <= 1'b0;
	end
	else if((ecounter == 5'h13) & done) begin
		cipher_available <= 1'b1;
	end
	else if((ecounter == 5'h0) & plain_text_complete) begin
		cipher_available <= 1'b0;
	end
end


assign cipher_text_read = chipselect & read & (address == 4'h4);
assign cipher_status_read = chipselect & read & (address == 4'h8);

always @(posedge clock) begin
	if(!resetn) begin
		ocounter <= 2'h0;
	end
	else if(cipher_text_read & (~waitrequest)) begin
		ocounter <= ocounter + 2'h1;
	end
end


//Reading Out Cipher
always @(ocounter or cipher_text_read or cipher_status_read or cipher_text or cipher_available) begin
	readdata = 32'h0;

	if(cipher_text_read) begin
		case(ocounter)
		2'h0 : begin readdata = cipher_text[127:96]; end
		2'h1 : begin readdata = cipher_text[95:64]; end
		2'h2 : begin readdata = cipher_text[63:32]; end
		2'h3 : begin readdata = cipher_text[31:0]; end
		endcase
	end

	else if(cipher_status_read) begin
		readdata = {31'h0, cipher_available};
	end

end

assign waitrequest = cipher_text_read & (~cipher_available);

endmodule
