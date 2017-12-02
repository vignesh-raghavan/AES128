module tb;

reg clk;
reg resetn;


reg [159:0] ptext;
wire [127:0] stext;
wire [159:0] dout;

wire sdone;
wire mdone;
wire [31:0] mout;
reg men;
reg [127:0] s;

wire done;
reg enable;

initial begin
	clk = 1'b0;
	forever #5 clk = ~clk;
end

initial begin
	resetn = 1'b0;
	enable = 1'b0;
	#100;
	resetn = 1'b1;
	#50;
	ptext = 128'hffeeddccbbaa99887766554433221100 ^ 128'h0f0e0d0c0b0a09080706050403020100;
	enable = 1'b1;
	#2560;
	enable = 1'b0;
	#100;
	men = 1'b1;
	#400;
	men = 1'b0;
	#100;
	$finish;
end


sbox s0 (.clk(clk), .resetn(resetn), .enable(enable), .index(ptext), .sbout(dout), .done(sdone));
//Shift Rows for Encryption
shiftrows U2 (.istate(dout[127:0]), .ostate(stext));

always @(posedge clk) begin
	if(!resetn) begin
		s <= 128'h0;
	end
	else if(sdone) begin
		s <= stext;
	end
end

//Mix Columns for Encryption
mixcolumns U3 (.clock(clk), .resetn(resetn), .enable(men), .istate(s), .ostate(mout), .done(mdone));

endmodule
