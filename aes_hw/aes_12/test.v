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

reg [31:0] d1;
reg [31:0] d2;
reg [31:0] d3;
reg [31:0] d4;


initial begin
	clk = 1'b0;
	forever #5 clk = ~clk;
end

initial begin
	#10;
	resetn = 1'b1;
	#10;
	resetn = 1'b0;
	#200;
	resetn = 1'b1;
	cs = 1'b0;
	wen = 1'b0;
	a = 4'h0;
	d = 32'h0;
	repeat(30)@(posedge clk);
	//ptwrite(128'h11111111111111111111111111111111);
	//ptwrite(128'h22222222222222222222222222222222);
	//ptwrite(128'h33333333333333333333333333333333);
	//ptwrite(128'h44444444444444444444444444444444);
	//ptwrite(128'h55555555555555555555555555555555);
	//ptwrite(128'h66666666666666666666666666666666);
	//ptwrite(128'h77777777777777777777777777777777);
	//ptwrite(128'h88888888888888888888888888888888);
	ptwrite(128'hffeeddccbbaa99887766554433221100);
	//repeat(100)@(posedge clk);
	ptwrite(128'hf47237c18b4c5a4059d1c3ab48966732);
	//repeat(100)@(posedge clk);
	ptwrite(128'hffeeddccbbaa99887766554433221100);
	ptwrite(128'hf47237c18b4c5a4059d1c3ab48966732);
	//ptwrite(128'hffeeddccbbaa99887766554433221100);
	//ptwrite(128'hf47237c18b4c5a4059d1c3ab48966732);
	//ptwrite(128'hffeeddccbbaa99887766554433221100);
	//ptwrite(128'hf47237c18b4c5a4059d1c3ab48966732);
	repeat(100)@(posedge clk);
	ptread;
	ptread;

	repeat(300)@(posedge clk);	
	$finish;
end


task ptwrite;
	input [127:0] ptext;
begin
	//repeat(1)@(posedge clk);
	wr(4'h0, ptext[127:96]);
	//repeat(1)@(posedge clk);
	wr(4'h0, ptext[95:64]);
	//repeat(1)@(posedge clk);
	wr(4'h0, ptext[63:32]);
	//repeat(1)@(posedge clk);
	wr(4'h0, ptext[31:0]);
	//repeat(10)@(posedge clk);
end
endtask

task ptread;
begin
	rd(4'h4);
	d1 = out;
	rd(4'h4);
	d2 = out;
	rd(4'h4);
	d3 = out;
	rd(4'h4);
	d4 = out;

	$display("%h %h %h %h", d1, d2, d3, d4);
end
endtask


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

aes_slave_intf a0 (.clock(clk), .resetn(resetn), .chipselect(cs), .address(a), .writedata(d), .readdata(out), .write(wen), .chipselect1(cs), .address1(a), .read(ren), .waitrequest(halt));

wire [31:0] cipher;
assign cipher = ren ? out : 32'hz;

endmodule
