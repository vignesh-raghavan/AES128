module tb;

reg resetn;
reg clk;

reg cs = 1'b0;
reg [3:0] a;
reg [31:0] d;
reg wen;
reg ren;
wire halt;
wire [31:0] out;

initial begin
	clk = 1'b0;
	forever #5 clk = ~clk;
end

initial begin
	resetn = 1'b0;
	#200;
	resetn = 1'b1;
	repeat(10)@(posedge clk);
	wr(4'h0, 32'h0);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'h1);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'h2);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'h3);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'h4);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'h5);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'h6);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'h7);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'h8);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'h9);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'hA);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'hB);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'hC);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'hD);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'hE);
	repeat(10)@(posedge clk);
	wr(4'h0, 32'hF);
	repeat(10)@(posedge clk);
	rd(4'h4);
	repeat(10)@(posedge clk);
	rd(4'h5);
	repeat(10)@(posedge clk);
	rd(4'h6);
	repeat(10)@(posedge clk);
	rd(4'h7);
	repeat(10)@(posedge clk);
	rd(4'h4);
	repeat(10)@(posedge clk);
	rd(4'h5);
	repeat(10)@(posedge clk);
	rd(4'h6);
	repeat(10)@(posedge clk);
	rd(4'h7);
	repeat(10)@(posedge clk);	
	rd(4'h4);
	repeat(10)@(posedge clk);
	rd(4'h5);
	repeat(10)@(posedge clk);
	rd(4'h6);
	repeat(10)@(posedge clk);
	rd(4'h7);
	repeat(10)@(posedge clk);
	rd(4'h4);
	repeat(10)@(posedge clk);
	rd(4'h5);
	repeat(10)@(posedge clk);
	rd(4'h6);
	repeat(10)@(posedge clk);
	rd(4'h7);
	repeat(10)@(posedge clk);	
	$finish;
end

task wr;
	input [3:0] addr;
	input [31:0] data;
begin
	cs = 1'b1;
	wen = 1'b1;
	a = addr;
	d = data;
	@(posedge clk);
	cs = 1'b0;
	wen = 1'b0;
end
endtask

task rd;
	input [3:0] addr;
begin
	cs = 1'b1;
	ren = 1'b1;
	a = addr;
	@(posedge clk);
	cs = 1'b0;
	ren = 1'b0;
end
endtask

aes_slave_intf a0 (.clock(clk), .resetn(resetn), .chipselect(cs), .address(a), .writedata(d), .readdata(out), .write(wen), .read(ren), .waitrequest(halt));

endmodule
