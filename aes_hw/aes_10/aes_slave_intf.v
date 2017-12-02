module aes_slave_intf (
   input clock,
	input resetn,

	//Slave Interface 0
	input chipselect,
	input [3:0] address,
	input write,
	input [31:0] writedata,
	output waitrequest,

	//Slave Interface 1
	input chipselect1,
	input [3:0] address1,
	input read,
	output reg [31:0] readdata,
	output waitrequest1
);

wire [127:0] plain_text;

wire plain_text_write;

reg [1:0] icounter;

reg [4:0] ecounter;
reg [4:0] ecounter_next;

reg enable;
reg [127:0] i_text;
wire [3:0] round;
wire [127:0] o_text;
wire [127:0] Rkey;
wire done;


// Input Synchronous FIFO signals
wire ifull;
wire iempty;
wire iwen;
reg iren;
reg [127:0] to_ififo;

// Output Synchronous FIFO signals
wire ofull;
wire oempty;
wire owen;
wire oren;
wire [127:0] from_ofifo;


wire cipher_available;
wire cipher_text_read;
wire cipher_status_read;
reg [1:0] ocounter;
wire idle;
reg [3:0] idlecounter;
reg [3:0] idlecounter_next;
wire clock_gate_en;
reg clock_gate_en_1;
wire gatedclock;

assign plain_text_write = chipselect & write & (address == 4'h0);



always @(posedge clock) begin
	if(!resetn) begin
		icounter <= 2'h0;
	end
	else if(plain_text_write & (~waitrequest)) begin
		icounter <= icounter + 2'h1;
	end
end



always @(icounter or plain_text_write or writedata) begin

	if((icounter == 2'h0)) begin
		to_ififo = {writedata, 96'h0};
	end
	else if((icounter == 2'h1) & plain_text_write) begin
		to_ififo[95:64] = writedata;
	end
	else if((icounter == 2'h2) & plain_text_write) begin
		to_ififo[63:32] = writedata;
	end
	else if((icounter == 2'h3) & plain_text_write) begin
		to_ififo[31:0] = writedata;
	end

end



assign iwen = (icounter == 2'h3) & plain_text_write & (~ifull);
assign waitrequest = (icounter == 2'h3) & plain_text_write & ifull;


synch_fifo IFIFO (
	.clock(clock),
	.resetn(resetn),

	.wen(iwen),
	.ren(iren),
	.wdata(to_ififo),
	.rdata(plain_text),

	.full(ifull),
	.empty(iempty)
);




always @(posedge clock) begin
	if(!resetn) begin
		ecounter <= 5'h0;
	end
	else begin
		ecounter <= ecounter_next;
	end
end

//Multiple rounds - 10 for 128bit encryption.
always @(ecounter or iempty or ofull or o_text or plain_text or Rkey or done) begin

	iren = 1'b0;

	if( (ecounter == 5'h0) ) begin // READ plaintext from IFIFO0.
		if(~iempty) begin
			enable = 1'b1;
			i_text = plain_text ^ Rkey;
			ecounter_next = 5'h1;
			iren = 1'b1;
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
			ecounter_next = 5'h14;
		end
	end
	else if( (ecounter == 5'h14) ) begin // WRITE ciphertext into OFIFO0.
		enable = 1'b0;
		if(~ofull) begin
			ecounter_next = 5'h0;
		end
	end
	else if( (ecounter[0]) ) begin // ODD states except 5'h13.
		enable = 1'b0;
		if(done) begin
			ecounter_next = ecounter + 5'h1;
		end
	end
	else if( (!ecounter[0]) )begin // Even states except 5'h0, 5'h14.
		enable = 1'b1;
		i_text = o_text;
		ecounter_next = ecounter + 5'h1;
	end

end


assign round = ecounter[4:1];

//Compute AES cipher for one round.
aes aes0 (
	.clock(gatedclock),
	.resetn(resetn),

	.enable(enable),

	.i_text(i_text),
	.key(Rkey),
	.round(round),

	.o_text(o_text),
	.Rkey(Rkey),

	.done(done)
);


assign owen = (ecounter == 5'h14) & (~ofull);

synch_fifo OFIFO (
	.clock(clock),
	.resetn(resetn),

	.wen(owen),
	.ren(oren),
	.wdata(o_text),
	.rdata(from_ofifo),

	.full(ofull),
	.empty(oempty)
);



assign cipher_available = ~oempty;

assign cipher_text_read = chipselect1 & read & (address1 == 4'h4);
assign cipher_status_read = chipselect1 & read & (address1 == 4'h8);

always @(posedge clock) begin
	if(!resetn) begin
		ocounter <= 2'h0;
	end
	else if(cipher_text_read & (~waitrequest1)) begin
		ocounter <= ocounter + 2'h1;
	end
end


assign oren = (ocounter == 2'h3) & cipher_text_read & (~oempty);
assign waitrequest1 = cipher_text_read & oempty;


//Reading Out Cipher
always @(ocounter or cipher_text_read or cipher_status_read or from_ofifo or oempty) begin
	readdata = 32'h0;

	if(cipher_text_read) begin
		case(ocounter)
		2'h0 : begin readdata = from_ofifo[127:96]; end
		2'h1 : begin readdata = from_ofifo[95:64]; end
		2'h2 : begin readdata = from_ofifo[63:32]; end
		2'h3 : begin readdata = from_ofifo[31:0]; end
		endcase
	end

	else if(cipher_status_read) begin
		readdata = {31'h0, ~oempty};
	end

end




//No Pending Input PlainTexts and No Encryption in Progress and Empty IFIFO0.
assign idle = ( (icounter != 2'h3) | ((~plain_text_write) & (icounter == 2'h3)) ) & (ecounter == 5'h0) & iempty;

always @(posedge clock) begin
	if(!resetn) begin
		idlecounter <= 4'h0;
	end
	else if(idle) begin
		idlecounter <= idlecounter_next;
	end
	else begin
		idlecounter <= 4'h0;
	end
end

always @(idlecounter or idle) begin
	case(idlecounter)
	4'hF : begin idlecounter_next = idlecounter; end
	default : begin idlecounter_next = idlecounter + 4'h1; end
	endcase
end

assign clock_gate_en = ((idlecounter == 4'hF) & (~idle)) | (idlecounter != 4'hF);

always @(negedge clock) begin
	if(!resetn) begin
		clock_gate_en_1 <= 1'b0;
	end
	else begin
		clock_gate_en_1 <= clock_gate_en;
	end
end

assign gatedclock = clock & clock_gate_en_1;

endmodule
