module tb;

reg resetn;
reg clk;

reg enable;
wire [7:0] com1;
wire [7:0] com2;

reg [7:0] cnt;
reg [7:0] mem[0:255];

wire error0;
wire error1;
wire error2;
wire error3;
wire error4;
wire error5;
wire error6;
wire error7;

initial begin
	$readmemh("SBOX.hex", mem);
	resetn = 1'b0;
	#10;
	resetn = 1'b1;
	clk = 1'b0;
	forever #5 clk = ~clk;
end

initial begin
	#50;
	enable = 1'b1;
	#3000;
	enable = 1'b0;
	$finish;
end


always @(posedge clk or negedge resetn) begin
	if(!resetn) begin
		cnt <= 8'h0;
	end
	else if(enable) begin
		cnt <= cnt + 8'h1;
	end
end

//always @(posedge clk or negedge resetn) begin
//	if(!resetn) begin
//		error <= 1'b0;
//	end
//	else begin
//		error <= (com1 != com2);
//	end
//end

assign error0 = (com1[0] != com2[0]);
assign error1 = (com1[1] != com2[1]);
assign error2 = (com1[2] != com2[2]);
assign error3 = (com1[3] != com2[3]);
assign error4 = (com1[4] != com2[4]);
assign error5 = (com1[5] != com2[5]);
assign error6 = (com1[6] != com2[6]);
assign error7 = (com1[7] != com2[7]);

sbox s0(.index(cnt), .o(com1));

//sbox s0 (.a(cnt[7]),
//         .b(cnt[6]),
//         .c(cnt[5]),
//         .d(cnt[4]),
//         .e(cnt[3]),
//         .f(cnt[2]),
//         .g(cnt[1]),
//         .h(cnt[0]),
//         
//         .o(com1)
//         );


assign com2 = mem[cnt];

endmodule
