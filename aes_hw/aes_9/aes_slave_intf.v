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
	output [31:0] readdata,
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


assign plain_text_write = chipselect & write & (address == 4'h0);



always @(posedge clock) begin
	if(!resetn) begin
		icounter <= 2'h0;
	end
	else if(plain_text_write & (~waitrequest)) begin
		icounter <= icounter + 2'h1;
	end
end

reg [127:0] temp_wdata;
always @(posedge clock) begin
	if(!resetn) begin
		temp_wdata <= 128'h0;
	end
	else begin
		temp_wdata <= to_ififo;
	end
end



always @(icounter or plain_text_write or writedata or temp_wdata) begin

	if((icounter == 2'h0)) begin
		to_ififo = {temp_wdata[95:0], writedata};
	end
	else if((icounter == 2'h1) & plain_text_write) begin
		to_ififo = {temp_wdata[95:0], writedata};
	end
	else if((icounter == 2'h2) & plain_text_write) begin
		to_ififo = {temp_wdata[95:0], writedata};
	end
	else if((icounter == 2'h3) & plain_text_write) begin
		to_ififo = {temp_wdata[95:0], writedata};
	end
	else begin
		to_ififo = temp_wdata;
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


reg [127:0] t_text;
always @(posedge clock) begin
	if(!resetn) begin
		t_text <= 128'h0;
	end
	else begin
		t_text <= i_text;
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
//always @(ecounter or iempty or ofull or o_text or plain_text or Rkey or done) begin
//
//	//iren = 1'b0;
//
//	if( (ecounter == 5'h0) ) begin // READ plaintext from IFIFO0.
//		if(~iempty) begin
//			enable = 1'b1;
//			i_text = plain_text ^ Rkey;
//			ecounter_next = 5'h1;
//			iren = 1'b1;
//		end
//		else begin
//			enable = 1'b0;
//			i_text = 128'h0;
//			ecounter_next = ecounter;
//			iren = 1'b0;
//		end
//	end
//	else if( (ecounter == 5'h13) ) begin
//		enable = 1'b0;
//		iren = 1'b0;
//		if(done) begin
//			ecounter_next = 5'h14;
//		end
//	end
//	else if( (ecounter == 5'h14) ) begin // WRITE ciphertext into OFIFO0.
//		enable = 1'b0;
//		iren = 1'b0;
//		if(~ofull) begin
//			ecounter_next = 5'h0;
//		end
//	end
//	else if( (ecounter[0]) ) begin // ODD states except 5'h13.
//		enable = 1'b0;
//		iren = 1'b0;
//		if(done) begin
//			ecounter_next = ecounter + 5'h1;
//		end
//	end
//	else if( (!ecounter[0]) )begin // Even states except 5'h0, 5'h14.
//		enable = 1'b1;
//		i_text = o_text;
//		ecounter_next = ecounter + 5'h1;
//		iren = 1'b0;
//	end
//
//end

always @(ecounter or iempty or ofull or o_text or plain_text or Rkey or done or t_text) begin

	if((ecounter == 5'h0)) begin
		//cipher_text = o_text;
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
			iren = 1'b0;
		end
	end
	else if((ecounter == 5'h1)) begin
		if(done) begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter + 5'h1;
			iren = 1'b0;
		end
		else begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter;
			iren = 1'b0;
		end
	end
	else if((ecounter == 5'h2)) begin
		enable = 1'b1;
		i_text = o_text;
		ecounter_next = ecounter + 5'h1;
		iren = 1'b0;
	end
	else if((ecounter == 5'h3)) begin
		if(done) begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter + 5'h1;
			iren = 1'b0;
		end
		else begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter;
			iren = 1'b0;
		end
	end
	else if((ecounter == 5'h4)) begin
		enable = 1'b1;
		i_text = o_text;
		ecounter_next = ecounter + 5'h1;
		iren = 1'b0;
	end
	else if((ecounter == 5'h5)) begin
		if(done) begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter + 5'h1;
			iren = 1'b0;
		end
		else begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter;
			iren = 1'b0;
		end
	end
	else if((ecounter == 5'h6)) begin
		enable = 1'b1;
		i_text = o_text;
		ecounter_next = ecounter + 5'h1;
		iren = 1'b0;
	end
	else if((ecounter == 5'h7)) begin
		if(done) begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter + 5'h1;
			iren = 1'b0;
		end
		else begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter;
			iren = 1'b0;
		end
	end
	else if((ecounter == 5'h8)) begin
		enable = 1'b1;
		i_text = o_text;
		ecounter_next = ecounter + 5'h1;
		iren = 1'b0;
	end	
	else if((ecounter == 5'h9)) begin
		if(done) begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter + 5'h1;
			iren = 1'b0;
		end
		else begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter;
			iren = 1'b0;
		end
	end
	else if((ecounter == 5'hA)) begin
		enable = 1'b1;
		i_text = o_text;
		ecounter_next = ecounter + 5'h1;
		iren = 1'b0;
	end	
	else if((ecounter == 5'hB)) begin
		if(done) begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter + 5'h1;
			iren = 1'b0;
		end
		else begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter;
			iren = 1'b0;
		end
	end
	else if((ecounter == 5'hC)) begin
		enable = 1'b1;
		i_text = o_text;
		ecounter_next = ecounter + 5'h1;
		iren = 1'b0;
	end	
	else if((ecounter == 5'hD)) begin
		if(done) begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter + 5'h1;
			iren = 1'b0;
		end
		else begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter;
			iren = 1'b0;
		end
	end
	else if((ecounter == 5'hE)) begin
		enable = 1'b1;
		i_text = o_text;
		ecounter_next = ecounter + 5'h1;
		iren = 1'b0;
	end	
	else if((ecounter == 5'hF)) begin
		if(done) begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter + 5'h1;
			iren = 1'b0;
		end
		else begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter;
			iren = 1'b0;
		end
	end
	else if((ecounter == 5'h10)) begin
		enable = 1'b1;
		i_text = o_text;
		ecounter_next = ecounter + 5'h1;
		iren = 1'b0;
	end	
	else if((ecounter == 5'h11)) begin
		if(done) begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter + 5'h1;
			iren = 1'b0;
		end
		else begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter;
			iren = 1'b0;
		end
	end
	else if((ecounter == 5'h12)) begin
		enable = 1'b1;
		i_text = o_text;
		ecounter_next = ecounter + 5'h1;
		iren = 1'b0;
	end	
	else if((ecounter == 5'h13)) begin
		if(done) begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter + 5'h1;
			iren = 1'b0;
		end
		else begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter;
			iren = 1'b0;
		end
	end
	else begin
		if(~ofull) begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = 5'h0;
			iren = 1'b0;
		end
		else begin
			enable = 1'b0;
			i_text = t_text;
			ecounter_next = ecounter;
			iren = 1'b0;
		end
	end
	
	
	
	//else if( (ecounter[0]) ) begin
	//	enable = 1'b0;
	//	if(done) begin
	//		ecounter_next = ecounter + 5'h1;
	//	end
	//end
	//else if( (!ecounter[0]) )begin
	//	enable = 1'b1;
	//	i_text = o_text;
	//	ecounter_next = ecounter + 5'h1;
	//end

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

reg [31:0] from_reg;

//Reading Out Cipher
always @(ocounter or cipher_text_read or cipher_status_read or from_ofifo or oempty) begin
	//from_reg = 32'h0;

	if(cipher_text_read & (~oempty)) begin
		case(ocounter)
		2'h0 : begin from_reg = from_ofifo[127:96]; end
		2'h1 : begin from_reg = from_ofifo[95:64]; end
		2'h2 : begin from_reg = from_ofifo[63:32]; end
		2'h3 : begin from_reg = from_ofifo[31:0]; end
		endcase
	end
	else if(cipher_status_read) begin
		from_reg = {31'h0, ~oempty};
	end
	else begin
		from_reg = 32'hF;
	end

end

assign readdata = from_reg;
assign waitrequest1 = cipher_text_read & oempty;


////Reading Out Cipher
//always @(ocounter or cipher_text_read or cipher_status_read or from_ofifo or oempty) begin
//	//readdata = 32'h0;
//
//	if(cipher_text_read) begin
//		case(ocounter)
//		2'h0 : begin readdata = from_ofifo[127:96]; end
//		2'h1 : begin readdata = from_ofifo[95:64]; end
//		2'h2 : begin readdata = from_ofifo[63:32]; end
//		2'h3 : begin readdata = from_ofifo[31:0]; end
//		endcase
//	end
//
//	else if(cipher_status_read) begin
//		readdata = {31'h0, ~oempty};
//	end
//	else begin
//		readdata = 32'h0;
//	end
//
//end



endmodule
