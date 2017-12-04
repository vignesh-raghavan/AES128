`define SEQ_CONNECT(clock, resetn, ctr, ctr_next, iren, enable, i_text, key, iempty, fifo_text, Rkey, done, ofull, keyini) \
	always @(posedge clock) begin \
		if(!resetn) begin \
			ctr <= 1'b0; \
		end \
		else begin \
			ctr <= ctr_next; \
		end \
	end \
	always @(ctr or iempty or fifo_text or Rkey or done or ofull) begin \
		iren = 1'b0; \
		ctr_next = ctr; \
		if((ctr == 1'b0)) begin \
			if(~iempty) begin \
				enable = 1'b1; \
				i_text = fifo_text; \
				key = Rkey; \
				ctr_next = 1'b1; \
				iren = 1'b1; \
			end \
			else begin \
				i_text = 128'h0; \
				key = keyini; \
				enable = 1'b0; \
			end \
		end \
		else if((ctr == 1'b1)) begin \
			if(done & ~(ofull)) begin \
				enable = 1'b0; \
				ctr_next = 1'b0; \
			end \
		end \
	end



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

wire [127:0] Rkey;
assign Rkey = 128'h0f0e0d0c0b0a09080706050403020100;

reg [1:0] icounter;

reg ctr0;
reg ctr0_next;

reg ctr1;
reg ctr1_next;

reg ctr2;
reg ctr2_next;

reg ctr3;
reg ctr3_next;

reg ctr4;
reg ctr4_next;

reg ctr5;
reg ctr5_next;

reg ctr6;
reg ctr6_next;

reg ctr7;
reg ctr7_next;

reg ctr8;
reg ctr8_next;

reg ctr9;
reg ctr9_next;


// AES signals for 10 rounds
reg          enable0;
reg [127:0]  i_text0;
wire [127:0] o_text0;
wire [127:0]   Rkey0;
reg [127:0]     key0;
wire           done0;

reg          enable1;
reg [127:0]  i_text1;
wire [127:0] o_text1;
wire [127:0]   Rkey1;
reg [127:0]     key1;
wire           done1;

reg          enable2;
reg [127:0]  i_text2;
wire [127:0] o_text2;
wire [127:0]   Rkey2;
reg [127:0]     key2;
wire           done2;

reg          enable3;
reg [127:0]  i_text3;
wire [127:0] o_text3;
wire [127:0]   Rkey3;
reg [127:0]     key3;
wire           done3;

reg          enable4;
reg [127:0]  i_text4;
wire [127:0] o_text4;
wire [127:0]   Rkey4;
reg [127:0]     key4;
wire           done4;

reg          enable5;
reg [127:0]  i_text5;
wire [127:0] o_text5;
wire [127:0]   Rkey5;
reg [127:0]     key5;
wire           done5;

reg          enable6;
reg [127:0]  i_text6;
wire [127:0] o_text6;
wire [127:0]   Rkey6;
reg [127:0]     key6;
wire           done6;

reg          enable7;
reg [127:0]  i_text7;
wire [127:0] o_text7;
wire [127:0]   Rkey7;
reg [127:0]     key7;
wire           done7;

reg          enable8;
reg [127:0]  i_text8;
wire [127:0] o_text8;
wire [127:0]   Rkey8;
reg [127:0]     key8;
wire           done8;

reg          enable9;
reg [127:0]  i_text9;
wire [127:0] o_text9;
wire [127:0]   Rkey9;
reg [127:0]     key9;
wire           done9;

// Input Synchronous FIFO signals
wire ifull;
wire iempty;
wire iwen;
reg iren;
reg [127:0] to_ififo;

// Intermediate Stage Buffer signals
wire              ofull0;
wire             oempty0;
wire               owen0;
reg                oren0;
wire [127:0] from_ofifo0;

wire              ofull1;
wire             oempty1;
wire               owen1;
reg                oren1;
wire [127:0] from_ofifo1;

wire              ofull2;
wire             oempty2;
wire               owen2;
reg                oren2;
wire [127:0] from_ofifo2;

wire              ofull3;
wire             oempty3;
wire               owen3;
reg                oren3;
wire [127:0] from_ofifo3;

wire              ofull4;
wire             oempty4;
wire               owen4;
reg                oren4;
wire [127:0] from_ofifo4;

wire              ofull5;
wire             oempty5;
wire               owen5;
reg                oren5;
wire [127:0] from_ofifo5;

wire              ofull6;
wire             oempty6;
wire               owen6;
reg                oren6;
wire [127:0] from_ofifo6;

wire              ofull7;
wire             oempty7;
wire               owen7;
reg                oren7;
wire [127:0] from_ofifo7;

wire              ofull8;
wire             oempty8;
wire               owen8;
reg                oren8;
wire [127:0] from_ofifo8;

// Output Synchronous FIFO signals
wire              ofull9;
wire             oempty9;
wire               owen9;
wire               oren9;
wire [127:0] from_ofifo9;


wire cipher_available;
wire cipher_text_read;
wire cipher_status_read;
reg [1:0] ocounter;


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
		to_ififo = {writedata ^ Rkey[127:96], 96'h0};
	end
	else if((icounter == 2'h1) & plain_text_write) begin
		to_ififo[95:64] = writedata ^ Rkey[95:64];
	end
	else if((icounter == 2'h2) & plain_text_write) begin
		to_ififo[63:32] = writedata ^ Rkey[63:32];
	end
	else if((icounter == 2'h3) & plain_text_write) begin
		to_ififo[31:0] = writedata ^ Rkey[31:0];
	end

end



assign iwen = (icounter == 2'h3) & plain_text_write & (~ifull);
assign waitrequest = (icounter == 2'h3) & plain_text_write & ifull;


synch_fifo IFIFO(.clock(clock), .resetn(resetn), .wen(iwen), .ren(iren), .wdata(to_ififo), .rdata(plain_text), .full(ifull), .empty(iempty));
 

always @(posedge clock) begin
	if(!resetn) begin
		ctr0 <= 1'b0;
	end
	else begin
		ctr0 <= ctr0_next;
	end
end

always @(ctr0 or iempty or plain_text or Rkey0 or done0 or ofull0) begin

	iren = 1'b0;
	ctr0_next = ctr0;

	if((ctr0 == 1'b0)) begin
		if(~iempty) begin
			enable0 = 1'b1;
			i_text0 = plain_text;// ^ 128'h0f0e0d0c0b0a09080706050403020100;
			key0 = Rkey;
			ctr0_next = 1'b1;
			iren = 1'b1;
		end
		else begin
			i_text0 = 128'h0;
			key0 = Rkey;
			enable0 = 1'b0;
		end
	end
	else if((ctr0 == 1'b1)) begin
		if(done0 & ~(ofull0)) begin
			enable0 = 1'b0;
			ctr0_next = 1'b0;
		end
	end

end


//Compute AES cipher for 10 rounds.
aes aes0 (.clock(clock), .resetn(resetn), .enable(enable0), .i_text(i_text0), .key(key0), .round(4'h0), .o_text(o_text0), .Rkey(Rkey0), .done(done0));
aes aes1 (.clock(clock), .resetn(resetn), .enable(enable1), .i_text(i_text1), .key(key1), .round(4'h1), .o_text(o_text1), .Rkey(Rkey1), .done(done1));
aes aes2 (.clock(clock), .resetn(resetn), .enable(enable2), .i_text(i_text2), .key(key2), .round(4'h2), .o_text(o_text2), .Rkey(Rkey2), .done(done2));
aes aes3 (.clock(clock), .resetn(resetn), .enable(enable3), .i_text(i_text3), .key(key3), .round(4'h3), .o_text(o_text3), .Rkey(Rkey3), .done(done3));
aes aes4 (.clock(clock), .resetn(resetn), .enable(enable4), .i_text(i_text4), .key(key4), .round(4'h4), .o_text(o_text4), .Rkey(Rkey4), .done(done4));
aes aes5 (.clock(clock), .resetn(resetn), .enable(enable5), .i_text(i_text5), .key(key5), .round(4'h5), .o_text(o_text5), .Rkey(Rkey5), .done(done5));
aes aes6 (.clock(clock), .resetn(resetn), .enable(enable6), .i_text(i_text6), .key(key6), .round(4'h6), .o_text(o_text6), .Rkey(Rkey6), .done(done6));
aes aes7 (.clock(clock), .resetn(resetn), .enable(enable7), .i_text(i_text7), .key(key7), .round(4'h7), .o_text(o_text7), .Rkey(Rkey7), .done(done7));
aes aes8 (.clock(clock), .resetn(resetn), .enable(enable8), .i_text(i_text8), .key(key8), .round(4'h8), .o_text(o_text8), .Rkey(Rkey8), .done(done8));
aes aes9 (.clock(clock), .resetn(resetn), .enable(enable9), .i_text(i_text9), .key(key9), .round(4'h9), .o_text(o_text9), .Rkey(Rkey9), .done(done9));


//`SEQ_CONNECT(clock, resetn, ctr, ctr_next, iren, enable, i_text, key, iempty, fifo_text, Rkey, done, ofull)
`SEQ_CONNECT(clock, resetn, ctr1, ctr1_next, oren0, enable1, i_text1, key1, oempty0, from_ofifo0, Rkey0, done1, ofull1, Rkey)
`SEQ_CONNECT(clock, resetn, ctr2, ctr2_next, oren1, enable2, i_text2, key2, oempty1, from_ofifo1, Rkey1, done2, ofull2, Rkey)
`SEQ_CONNECT(clock, resetn, ctr3, ctr3_next, oren2, enable3, i_text3, key3, oempty2, from_ofifo2, Rkey2, done3, ofull3, Rkey)
`SEQ_CONNECT(clock, resetn, ctr4, ctr4_next, oren3, enable4, i_text4, key4, oempty3, from_ofifo3, Rkey3, done4, ofull4, Rkey)
`SEQ_CONNECT(clock, resetn, ctr5, ctr5_next, oren4, enable5, i_text5, key5, oempty4, from_ofifo4, Rkey4, done5, ofull5, Rkey)
`SEQ_CONNECT(clock, resetn, ctr6, ctr6_next, oren5, enable6, i_text6, key6, oempty5, from_ofifo5, Rkey5, done6, ofull6, Rkey)
`SEQ_CONNECT(clock, resetn, ctr7, ctr7_next, oren6, enable7, i_text7, key7, oempty6, from_ofifo6, Rkey6, done7, ofull7, Rkey)
`SEQ_CONNECT(clock, resetn, ctr8, ctr8_next, oren7, enable8, i_text8, key8, oempty7, from_ofifo7, Rkey7, done8, ofull8, Rkey)
`SEQ_CONNECT(clock, resetn, ctr9, ctr9_next, oren8, enable9, i_text9, key9, oempty8, from_ofifo8, Rkey8, done9, ofull9, Rkey)


//STUB
//assign oempty = 1'b0;
//assign from_ofifo = text3;

assign owen0 = done0 & (~ofull0);
assign owen1 = done1 & (~ofull1);
assign owen2 = done2 & (~ofull2);
assign owen3 = done3 & (~ofull3);
assign owen4 = done4 & (~ofull4);
assign owen5 = done5 & (~ofull5);
assign owen6 = done6 & (~ofull6);
assign owen7 = done7 & (~ofull7);
assign owen8 = done8 & (~ofull8);
assign owen9 = done9 & (~ofull9);

//Intermediate Stage Buffer (Depth of 1)
synch_reg OREG0(.clock(clock), .resetn(resetn), .wen(owen0), .ren(oren0), .wdata(o_text0), .rdata(from_ofifo0), .full(ofull0), .empty(oempty0));
synch_reg OREG1(.clock(clock), .resetn(resetn), .wen(owen1), .ren(oren1), .wdata(o_text1), .rdata(from_ofifo1), .full(ofull1), .empty(oempty1));
synch_reg OREG2(.clock(clock), .resetn(resetn), .wen(owen2), .ren(oren2), .wdata(o_text2), .rdata(from_ofifo2), .full(ofull2), .empty(oempty2));
synch_reg OREG3(.clock(clock), .resetn(resetn), .wen(owen3), .ren(oren3), .wdata(o_text3), .rdata(from_ofifo3), .full(ofull3), .empty(oempty3));
synch_reg OREG4(.clock(clock), .resetn(resetn), .wen(owen4), .ren(oren4), .wdata(o_text4), .rdata(from_ofifo4), .full(ofull4), .empty(oempty4));
synch_reg OREG5(.clock(clock), .resetn(resetn), .wen(owen5), .ren(oren5), .wdata(o_text5), .rdata(from_ofifo5), .full(ofull5), .empty(oempty5));
synch_reg OREG6(.clock(clock), .resetn(resetn), .wen(owen6), .ren(oren6), .wdata(o_text6), .rdata(from_ofifo6), .full(ofull6), .empty(oempty6));
synch_reg OREG7(.clock(clock), .resetn(resetn), .wen(owen7), .ren(oren7), .wdata(o_text7), .rdata(from_ofifo7), .full(ofull7), .empty(oempty7));
synch_reg OREG8(.clock(clock), .resetn(resetn), .wen(owen8), .ren(oren8), .wdata(o_text8), .rdata(from_ofifo8), .full(ofull8), .empty(oempty8));
//Last Stage Buffer (FIFO variable Depth)
synch_fifo OFIF09(.clock(clock), .resetn(resetn), .wen(owen9), .ren(oren9), .wdata(o_text9), .rdata(from_ofifo9), .full(ofull9), .empty(oempty9));


assign cipher_available = ~oempty9;

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


assign oren9 = (ocounter == 2'h3) & cipher_text_read & (~oempty9);
assign waitrequest1 = cipher_text_read & oempty9;


//Reading Out Cipher
always @(ocounter or cipher_text_read or cipher_status_read or from_ofifo9 or oempty9) begin
	readdata = 32'h0;

	if(cipher_text_read) begin
		case(ocounter)
		2'h0 : begin readdata = from_ofifo9[127:96]; end
		2'h1 : begin readdata = from_ofifo9[95:64]; end
		2'h2 : begin readdata = from_ofifo9[63:32]; end
		2'h3 : begin readdata = from_ofifo9[31:0]; end
		endcase
	end

	else if(cipher_status_read) begin
		readdata = {31'h0, ~oempty9};
	end

end



endmodule
