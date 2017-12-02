module mixcolumns (
	input clock,
	input resetn,

	input enable,
	input [31:0] istate,

	output reg [31:0] ostate,
	output reg done
);

reg [3:0] counter;
reg [3:0] counter_next;

reg [31:0] tstate;
reg [7:0] i1_1;
reg [7:0] i1_2;
reg [7:0] i2_1;
reg [7:0] i2_2;
wire [7:0] o1;
wire [7:0] o2;

always @(posedge clock) begin
	if(!resetn) begin
		counter <= 4'h0;
		ostate <= 32'h0;
	end
	else if(enable) begin
		counter <= counter_next;
		ostate <= tstate;
	end
end


always @(counter or enable or istate or ostate or o1 or o2) begin

	if(enable) begin
		counter_next = counter + 4'h1;
	end
	else begin
		tstate = 32'h0;
		counter_next = 4'h0;
	end

	if((counter == 4'h0)) begin
		i1_1 = istate[15:8];
		i1_2 = istate[7:0]; 
		tstate[7:0] = o1;

		i2_1 = istate[31:24];
		i2_2 = istate[23:16];
		tstate[23:16] = o2;
		done = 1'b0;
	end
	else if((counter == 4'h1)) begin
		i1_1 = ostate[23:16];
		i1_2 = ostate[7:0];
		tstate[7:0] = o1; //a0 = a
		
		i2_1 = o1;
		i2_2 = istate[15:8];
		tstate[15:8] = o2; //a1 = a + a1
	end
	else if((counter == 4'h2)) begin
		i1_1 = ostate[7:0];
		i1_2 = istate[23:16];
		tstate[23:16] = o1; //a2 = a + a2

		i2_1 = ostate[7:0];
		i2_2 = istate[31:24];
		tstate[31:24] = o2; //a3 = a + a3
	end
	else if((counter == 4'h3)) begin
		i1_1 = ostate[7:0];
		i1_2 = istate[7:0];
		tstate[7:0] = o1; //a0 = a + a0

		i2_1 = {istate[6:0], 1'b0};
		i2_2 = {3'b000, istate[7], istate[7], 1'b0, istate[7], istate[7]};
	end
	else if((counter == 4'h4)) begin
		i1_1 = ostate[7:0];
		i1_2 = o2; 
		tstate[7:0] = o1; //a0 = a + a0 + 2a0
	end
	else if((counter == 4'h5)) begin
		i1_1 = ostate[31:24];
		i1_2 = o2;
		tstate[31:24] = o1; //a3 = a + a3 + 2a0
	end
	else if((counter == 4'h6)) begin
		i1_1 = {istate[14:8], 1'b0};
		i1_2 = {3'b000, istate[15], istate[15], 1'b0, istate[15], istate[15]};
		
		i2_1 = ostate[7:0];
		i2_2 = o1;
		tstate[7:0] = o2; // a0 = a + a0 + 2a1 + 2a0
	end
	else if((counter == 4'h7)) begin
		i2_1 = ostate[15:8];
		i2_2 = o1;
		tstate[15:8] = o2; //a1 = a + a1 + 2a1
	end
	else if((counter == 4'h8)) begin
		i1_1 = {istate[22:16], 1'b0};
		i1_2 = {3'b000, istate[23], istate[23], 1'b0, istate[23], istate[23]};

		i2_1 = ostate[23:16];
		i2_2 = o1;
		tstate[23:16] = o2; //a2 = a + a2 + 2a2
	end
	else if((counter == 4'h9)) begin
		i2_1 = ostate[15:8];
		i2_2 = o1;
		tstate[15:8] = o2; //a1 = a + a1 + 2a1 + 2a2
	end
	else if((counter == 4'hA)) begin
		i1_1 = {istate[30:24], 1'b0};
		i1_2 = {3'b000, istate[31], istate[31], 1'b0, istate[31], istate[31]};

		i2_1 = ostate[31:24];
		i2_2 = o1;
		tstate[31:24] = o2; //a3 = a + a3 + 2a0 + 2a3
	end
	else if((counter == 4'hB)) begin
		i2_1 = ostate[23:16];
		i2_2 = o1;
		tstate[23:16] = o2; //a2 = a + a2 + 2a2 + 2a3
	end
	else begin
		done = 1'b1;
		counter_next = 4'h0;
	end
end


cxor x1 (.i1(i1_1), .i2(i1_2), .o(o1));
cxor x2 (.i1(i2_1), .i2(i2_2), .o(o2));

endmodule




module cxor (
	input [7:0] i1,
	input [7:0] i2,

	output [7:0] o
);

assign o = i1 ^ i2;

endmodule
