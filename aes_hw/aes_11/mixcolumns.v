module mixcolumns (
	input [127:0] istate,
	input bypass,

	output [127:0] ostate
);

wire [127:0] buf1;
wire [127:0] buf3;
wire [127:0] buf4;

genvar i;

generate
for(i = 0; i < 16; i= i+4) begin : mix_columns0

	assign buf1[ 8*i+31 : 8*i ] = { istate[ 8*i+7 : 8*i ], istate[ 8*i+31 : 8*i+8 ] } ^ { istate[ 8*i+15 : 8*i ], istate[ 8*i+31 : 8*i+16 ] } ^ { istate[ 8*i+23 : 8*i ], istate[ 8*i+31 : 8*i+24 ] };
	
	assign buf3[ 8*i+31 : 8*i] = istate[ 8*i+31 : 8*i ] ^ { istate[ 8*i+7 : 8*i ], istate[ 8*i+31 : 8*i+8 ] };

	//Galois Multiplication
	assign buf4[ 8*(i)+7 : 8*(i) ]     = buf3[ 8*(i)+7 ]   ? ( { buf3[ 8*(i)+6 : 8*(i) ], 1'b0 } ^ 8'h1b )     : { buf3[ 8*(i)+6 : 8*(i) ], 1'b0 };
	assign buf4[ 8*(i+1)+7 : 8*(i+1) ] = buf3[ 8*(i+1)+7 ] ? ( { buf3[ 8*(i+1)+6 : 8*(i+1) ], 1'b0 } ^ 8'h1b ) : { buf3[ 8*(i+1)+6 : 8*(i+1) ], 1'b0 };
	assign buf4[ 8*(i+2)+7 : 8*(i+2) ] = buf3[ 8*(i+2)+7 ] ? ( { buf3[ 8*(i+2)+6 : 8*(i+2) ], 1'b0 } ^ 8'h1b ) : { buf3[ 8*(i+2)+6 : 8*(i+2) ], 1'b0 };
	assign buf4[ 8*(i+3)+7 : 8*(i+3) ] = buf3[ 8*(i+3)+7 ] ? ( { buf3[ 8*(i+3)+6 : 8*(i+3) ], 1'b0 } ^ 8'h1b ) : { buf3[ 8*(i+3)+6 : 8*(i+3) ], 1'b0 };

	//bypass option for last round of encryption
	assign ostate[ 8*i+31 : 8*i ] = bypass ? istate[ 8*i+31 : 8*i ] : buf1[ 8*i+31 : 8*i ] ^ buf4[ 8*i+31 : 8*i ];

end
endgenerate

endmodule
