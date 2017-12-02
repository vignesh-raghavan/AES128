module sbox (
	input clk,
	input resetn,

	input [159:0] index,
	input enable,

	output reg [159:0] sbout,
	output done
);

reg [7:0] p;
wire [7:0] p_next;

reg [7:0] q;
wire [7:0] q_next;

wire [7:0] aff;

reg [19:0] complete;

genvar i;


always @(posedge clk) begin
	if(!resetn) begin
		p <= 8'h1;
		q <= 8'h1;
	end
	else if(!enable) begin
		p <= 8'h1;
		q <= 8'h1;
	end
	else begin
		p <= p_next;
		q <= q_next;
	end
end

/* Multiply by 03 in Galois Field GF(256)
 * p = p ^ (p<<1) ^ (p & 0x80 ? 0x1b : 0x00);
 * */
assign p_next = {p[7]^p[6], p[6]^p[5], p[5]^p[4], p[4]^p[3]^p[7], p[3]^p[2]^p[7], p[2]^p[1], p[1]^p[0]^p[7], p[0]^p[7]};

/* Inverse of p in Galois Field GF(256)
 * q ^= q<<1;
 * q ^= q<<2;
 * q ^= q<<4;
 * q ^= q & 0x80 ? 0x09 : 0x00;
 * */
assign q_next[0] = q[0] ^ q_next[7];
assign q_next[1] = q[1] ^ q[0];
assign q_next[2] = q[2] ^ q_next[1];
assign q_next[3] = q[7] ^ q[6] ^ q[5] ^ q[4];
assign q_next[4] = q[4] ^ q[3] ^ q_next[2];
assign q_next[5] = q[5] ^ q_next[4];
assign q_next[6] = q[6] ^ q_next[5];
assign q_next[7] = q[7] ^ q_next[6];


/* Compute Affine Transformation
 * b'(i) = b(i) ^ b(i+4 % 8) ^ b(i+5 % 8) ^ b(i+6 % 8) ^ b(i+7 % 8) ^ c(i);
 * c = 0x63;
 */
assign aff[0] = ~(q[0] ^ q_next[3]);              //q[0] ^ q[4] ^ q[5] ^ q[6] ^ q[7] ^ 1'b1;
assign aff[1] = ~(q_next[1] ^ q_next[3] ^ q[4]);  //q[1] ^ q[5] ^ q[6] ^ q[7] ^ q[0] ^ 1'b1;
assign aff[2] = q_next[2] ^ q[6] ^ q[7];          //q[2] ^ q[6] ^ q[7] ^ q[0] ^ q[1] ^ 1'b0;
assign aff[3] = q_next[4] ^ q[4] ^ q[7];          //q[3] ^ q[7] ^ q[0] ^ q[1] ^ q[2] ^ 1'b0;
assign aff[4] = q_next[4];                        //q[4] ^ q[0] ^ q[1] ^ q[2] ^ q[3] ^ 1'b0;
assign aff[5] = ~(q_next[5] ^ q[0]);              //q[5] ^ q[1] ^ q[2] ^ q[3] ^ q[4] ^ 1'b1;
assign aff[6] = ~(q_next[6] ^ q_next[1]);         //q[6] ^ q[2] ^ q[3] ^ q[4] ^ q[5] ^ 1'b1;
assign aff[7] = q_next[7] ^ q_next[2];            //q[7] ^ q[3] ^ q[4] ^ q[5] ^ q[6] ^ 1'b0;


generate
	for(i = 0; i < 20; i = i+1) begin : sbox_sample
		always @(enable or aff or index or p) begin
			if(enable) begin
				if(index[8*i+7:8*i] == 8'h0) begin
					complete[i] = 1'b1;
				end
				else if(index[8*i+7:8*i] == p) begin
					sbout[8*i+7:8*i] = aff;
					complete[i] = 1'b1;
				end
			end
			else begin
				sbout[8*i+7:8*i] = 8'h63;
				complete[i] = 1'b0;
			end
		end
	end

endgenerate


assign done = &(complete[19:0]);

endmodule
