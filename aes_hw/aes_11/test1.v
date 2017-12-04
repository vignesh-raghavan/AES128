module tb;

reg resetn;
reg clk;

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


wire [127:0] cipher_text;

reg [127:0] plain_text;
reg plain_text_complete;

reg [4:0] ecounter;
reg [4:0] ecounter_next;

wire [3:0] round;



initial begin
	//$readmemh("SBOX.hex", mem);
	clk = 1'b0;
	forever #5 clk = ~clk;
end

initial begin
	resetn = 1'b0;
	#100;
	@(posedge clk);
	resetn = 1'b1;
	#50;
	@(posedge clk);
	plain_text = 128'hffeeddccbbaa99887766554433221100;
	plain_text_complete = 1'b1;
	@(posedge clk);
	plain_text_complete = 1'b1;
	plain_text = 128'hf47237c18b4c5a4059d1c3ab48966732;
	@(posedge clk);
	plain_text_complete = 1'b0;
	#100;
	$finish;
end



always @(posedge clk) begin
	if(!resetn) begin
		i_text0 <= 128'h0;
		key0 <= Rkey0;
	end
	else if(plain_text_complete) begin
		i_text0 <= plain_text ^ 128'h0f0e0d0c0b0a09080706050403020100;
		key0 <= 128'h0f0e0d0c0b0a09080706050403020100;
	end
end

always @(posedge clk) begin
	if(!resetn) begin
		enable0 <= 1'b0;
	end
	else if(plain_text_complete) begin
		enable0 <= 1'b1;
	end
	else begin
		enable0 <= 1'b0;
	end
end



always @(posedge clk) begin
	if(!resetn) begin
		i_text1 <= 128'h0;
		key1 <= Rkey1;
	end
	else if(done0) begin
		i_text1 <= o_text0;
		key1 <= Rkey0;
	end
end

always @(posedge clk) begin
	if(!resetn) begin
		enable1 <= 1'b0;
	end
	else if(done0) begin
		enable1 <= 1'b1;
	end
	else begin
		enable1 <= 1'b0;
	end
end



always @(posedge clk) begin
	if(!resetn) begin
		i_text2 <= 128'h0;
		key2 <= Rkey2;
	end
	else if(done1) begin
		i_text2 <= o_text1;
		key2 <= Rkey1;
	end
end

always @(posedge clk) begin
	if(!resetn) begin
		enable2 <= 1'b0;
	end
	else if(done1) begin
		enable2 <= 1'b1;
	end
	else begin
		enable2 <= 1'b0;
	end
end


aes s0 (.clock(clk), .resetn(resetn), .enable(enable0), .i_text(i_text0), .key(key0), .round(4'h0), .o_text(o_text0), .Rkey(Rkey0), .done(done0));
aes s1 (.clock(clk), .resetn(resetn), .enable(enable1), .i_text(i_text1), .key(key1), .round(4'h1), .o_text(o_text1), .Rkey(Rkey1), .done(done1));
aes s2 (.clock(clk), .resetn(resetn), .enable(enable2), .i_text(i_text2), .key(key2), .round(4'h2), .o_text(o_text2), .Rkey(Rkey2), .done(done2));


assign cipher_text = o_text2;

endmodule
