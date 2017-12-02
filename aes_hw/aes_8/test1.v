module tb;

reg resetn;
reg clk;

reg enable;

reg [127:0] i_text;
wire [127:0] o_text;
wire [127:0] Rkey;

reg [127:0] plain_text;
reg plain_text_complete;

reg [3:0] ecounter;
reg [3:0] ecounter_next;

reg [3:0] round;

wire done;


initial begin
	//$readmemh("SBOX.hex", mem);
	clk = 1'b0;
	forever #5 clk = ~clk;
end

initial begin
	resetn = 1'b0;
	#100;
	resetn = 1'b1;
	#50;
	plain_text = 128'hffeeddccbbaa99887766554433221100;
	plain_text_complete = 1'b1;
	//enable = 1'b1;
	#160;
	//enable = 1'b0;
	//itext = 128'hf47237c18b4c5a4059d1c3ab48966732;
	//enable = 1'b1;
	#9000;
	$finish;
end


always @(posedge clk) begin
	if(!resetn) begin
		ecounter <= 4'h0;
	end
	else begin
		ecounter <= ecounter_next;
	end
end

//Multiple rounds - 10 for 128bit encryption.
always @(ecounter or plain_text_complete or plain_text or o_text or Rkey or done) begin
	ecounter_next = ecounter; //Keep the same state.
	enable = 1'b0;
	round = 4'h0;
	i_text = 128'h0;

	if( (ecounter == 4'h0) || (ecounter == 4'hA)) begin
		if(plain_text_complete) begin
			if(done) begin
				ecounter_next = 4'h1;
			end
			enable = 1'b1;
			round = 4'h0;
			i_text = plain_text ^ Rkey; //First Addroundkey for Encryption. //XOR Initialization Vector here..
		end
	end
	else begin
		if(done) begin
			ecounter_next = ecounter + 4'h1;
		end
		enable = 1'b1;
		round = ecounter;
		i_text = o_text;
	end
end

aes s0 (.clock(clk), .resetn(resetn), .enable(enable), .i_text(i_text), .key(Rkey), .round(round), .o_text(o_text), .Rkey(Rkey), .done(done));


endmodule
