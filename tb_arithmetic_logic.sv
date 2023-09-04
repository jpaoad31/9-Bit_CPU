import instr_pack ::*;

module tb_arithmetic_logic();

math math_op = no_mth;

logic alu_en=0, alu_rs=0;

logic [7:0] x=8'd0, y=8'd0, m=8'd4, s_ex=8'd1, r_ex=8'd0;
wire  [7:0] s_out, r_out;

wire correct;

assign correct = (r_out == r_ex) && (s_out == s_ex);

arithmetic_logic alu(.*);

always begin

	// logical and
	alu_en = 1;
	math_op = AMP;
	x = 8'b00111111;
	y = 8'b11111100;
	r_ex = 8'b00111100;

	#10ns

	x = 8'b10101111;
	y = 8'b10101010;
	r_ex = 8'b10101010;

	#10ns

	// logical or
	math_op = LOR;
	x = 8'b00111111;
	y = 8'b11111100;
	r_ex = 8'b11111111;

	#10ns

	x = 8'b10101111;
	y = 8'b10101010;
	r_ex = 8'b10101111;

	#10ns

	// logical not (x)
	math_op = FLP;
	x = 8'b00111111;
	r_ex = 8'b11000000;

	#10ns

	x = 8'b10101111;
	r_ex = 8'b01010000;

	#10ns

	// logical exclusive or
	math_op = EOR;
	x = 8'b00111111;
	y = 8'b11111100;
	r_ex = 8'b11000011;

	#10ns

	x = 8'b10101111;
	y = 8'b10101010;
	r_ex = 8'b00000101;

	#10ns

	// logical right shift with carry in
	math_op = RSC;
	x = 8'b00111111;
	y = 8'b11111100;
	r_ex = 8'b00011111;

	#10ns

	x = 8'b10101111;
	y = 8'b10101011;
	r_ex = 8'b11010111;

	#10ns

	// logical left shift with carry in
	math_op = LSC;
	x = 8'b00111111;
	y = 8'b11111100;
	r_ex = 8'b01111111;

	#10ns

	x = 8'b10101111;
	y = 8'b10101010;
	r_ex = 8'b01011111;

	#10ns

	// rotate x right
	math_op = ROR;
	x = 8'b00111111;
	y = 8'b00000011;
	r_ex = 8'b11100111;

	#10ns

	x = 8'b10101111;
	y = 8'b00000100;
	r_ex = 8'b11111010;

	#10ns

	alu_rs = 1;				// select s_out

	// addition
	math_op = ADD;
	x = 8'b00001111;
	y = 8'b00000011;
	s_ex = 8'b00010010;

	#10ns

	x = 8'b11110011;
	y = 8'b00000001;
	s_ex = 8'b11110100;

	#10ns

	// subtract
	math_op = SUB;
	x = 8'b00001111;
	y = 8'b00000011;
	s_ex = 8'b00001100;

	#10ns

	x = 8'b11110011;
	y = 8'b00000100;
	s_ex = 8'b11101111;

	#10ns

	// x equal y
	math_op = EQL8;
	x = 8'b00111111;
	y = 8'b11111100;
	s_ex = 8'b00000000;

	#10ns

	x = 8'b10101111;
	y = 8'b10101111;
	s_ex = 8'b00000001;

	#10ns

	// x[7:4] equal m[7:4]
	math_op = EQL5;
	x = 8'b00111111;
	m = 8'b11111100;
	s_ex = 8'b00000000;

	#10ns

	x = 8'b10101111;
	m = 8'b10101010;
	s_ex = 8'b00000001;

	#10ns

	// reverse x
	math_op = REVx;
	x = 8'b00111111;
	s_ex = 8'b11111100;

	#10ns

	x = 8'b11010001;
	s_ex = 8'b10001011;

	#10ns

	// reverse y
	math_op = REVy;
	y = 8'b00111111;
	s_ex = 8'b11111100;

	#10ns

	y = 8'b11010001;
	s_ex = 8'b10001011;

	#10ns

	// parity of x
	math_op = PARx;
	x = 8'b00111111;
	s_ex = 8'b00000000;

	#10ns

	x = 8'b11010000;
	s_ex = 8'b00000001;

	#10ns

	// paroty of y
	math_op = PARy;
	y = 8'b11001111;
	s_ex = 8'b00000000;

	#10ns

	y = 8'b01000000;
	s_ex = 8'b00000001;

	#10ns $stop;

end


endmodule