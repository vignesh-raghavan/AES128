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
for(i = 0; i < 16; i = i+1) begin : mix_columns0
	
	
	if((i==0) || (i==4) || (i==8) || (i==12)) begin
		assign buf1[ 8*i+7 : 8*i ] = istate[ 8*i+7 : 8*i ] ^ istate[ 8*(i+1)+7 : 8*(i+1) ] ^ istate[ 8*(i+2)+7 : 8*(i+2) ] ^ istate[ 8*(i+3)+7 : 8*(i+3) ];
	end
	else begin
		assign buf1[ 8*i+7 : 8*i ] = buf1[ 8*(i-1)+7 : 8*(i-1) ];
	end

	if((i==3) || (i==7) || (i==11) || (i==15)) begin
		assign buf3[ 8*i+7 : 8*i ] = istate[ 8*i+7 : 8*i ] ^ istate[ 8*(i-3)+7 : 8*(i-3) ];
	end
	else begin
		assign buf3[ 8*i+7 : 8*i ] = istate[ 8*i+7 : 8*i ] ^ istate[ 8*(i+1)+7 : 8*(i+1) ];
	end

	assign buf4[ 8*i+7 : 8*i ] = buf3[ 8*i+7 ] ? ( { buf3[ 8*i+6 : 8*i ], 1'b0 } ^ 8'h1b ) : { buf3[ 8*i+6 : 8*i ], 1'b0 }; //Galois Multiplication

	assign ostate[ 8*i+7 : 8*i ] = bypass ? istate[ 8*i+7 : 8*i ] : ( istate[ 8*i+7 : 8*i ] ^ buf4[ 8*i+7 : 8*i ] ^ buf1[ 8*i+7 : 8*i ] ); //bypass option for last round of encryption

end
endgenerate


endmodule
