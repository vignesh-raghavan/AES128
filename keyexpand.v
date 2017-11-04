module keyexpand (
	
	input [127:0] ikey,
	input [3:0] round,

	output [127:0] okey
);

//reg [7:0] sbox_mem[0:255]; //SBOX
reg [7:0] Rcon[0:9]; //Round Constant

wire [7:0] o13;
wire [7:0] o14;
wire [7:0] o15;
wire [7:0] o12;

//wire [31:0] kkey;

genvar i;


//Initial statements.
initial begin
	//$readmemh("SBOX.hex", sbox_mem);
	Rcon[0] = 8'h01;
	Rcon[1] = 8'h02;
	Rcon[2] = 8'h04;
	Rcon[3] = 8'h08;
	Rcon[4] = 8'h10;
	Rcon[5] = 8'h20;
	Rcon[6] = 8'h40;
	Rcon[7] = 8'h80;
	Rcon[8] = 8'h1b;
	Rcon[9] = 8'h36;
end

//assign kkey[8*0+7 : 8*0] = sbox_mem [ ikey[8*13+7 : 8*13] ] ^ ikey[8*0+7 : 8*0] ^ Rcon[round];
//assign kkey[8*1+7 : 8*1] = sbox_mem [ ikey[8*14+7 : 8*14] ] ^ ikey[8*1+7 : 8*1];
//assign kkey[8*2+7 : 8*2] = sbox_mem [ ikey[8*15+7 : 8*15] ] ^ ikey[8*2+7 : 8*2];
//assign kkey[8*3+7 : 8*3] = sbox_mem [ ikey[8*12+7 : 8*12] ] ^ ikey[8*3+7 : 8*3];

assign okey[8*0+7 : 8*0] = o13 ^ ikey[8*0+7 : 8*0] ^ Rcon[round];
assign okey[8*1+7 : 8*1] = o14 ^ ikey[8*1+7 : 8*1];
assign okey[8*2+7 : 8*2] = o15 ^ ikey[8*2+7 : 8*2];
assign okey[8*3+7 : 8*3] = o12 ^ ikey[8*3+7 : 8*3];


sbox sbox0(.index(ikey[8*13+7 : 8*13]),

			  .o(o13)
	  		 );

sbox sbox1(.index(ikey[8*14+7 : 8*14]),

			  .o(o14)
	  		 );

sbox sbox2(.index(ikey[8*15+7 : 8*15]),

			  .o(o15)
	  		 );

sbox sbox3(.index(ikey[8*12+7 : 8*12]),

			  .o(o12)
	  		 );


//Key Expansion for Encryption
generate
	for(i = 4; i < 16; i = i+1) begin : key_expand
		assign okey[8*i+7 : 8*i] = ikey[8*i+7 : 8*i] ^ okey[8*(i-4)+7 : 8*(i-4)];
	end
endgenerate


endmodule
