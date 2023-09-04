import instr_pack ::*;

module arithmetic_logic(
	input [7:0] x, y, m,				// input registers
	input math math_op,					// math operation to perform
	input alu_en, alu_rs,				// 0:r, 1:s

	output logic [7:0] s_out=1, r_out=0);	// output registers

	//output logic carry, zero, shift_out, equal

logic [7:0] yp, ny, res;
wire [7:0] c, cs, s, ss;
logic subEn=0;

assign ny = ~y;

always_latch begin
	if (alu_en) begin
		if (alu_rs)
				s_out = res;
			else
				r_out = res;
	end
end

always_comb begin
	subEn = 0;
	yp = 8'b0;
	res = 8'b0;

	if (alu_en) begin
		case (math_op)
			// basic logic
			AMP: res = x&y;					// and
			LOR: res = x|y;					// or
			FLP: res = ~x;					// not
			EOR: res = x^y;					// xor

			// shift & rotate
			RSC: res = {y[0], x[7:1]};		// right shift x w/ carry
			LSC: res = {x[6:0], y[7]};		// left shift x w/ carry
			/* ROL: */						// unused rotate left instruction, can be repurposed
			ROR: begin						// rotate x right by y[2:0]
				case (y[2:0])				// yes I know this is a very redundant
				0: res = x;					// it is included for compatibility
				1: res = {x[0],  x[7:1]};
				2: res = {x[1:0],x[7:2]};
				3: res = {x[2:0],x[7:3]};
				4: res = {x[3:0],x[7:4]};
				5: res = {x[4:0],x[7:5]};
				6: res = {x[5:0],x[7:6]};
				7: res = {x[6:0],x[7]};
				endcase
			end

			// math
			ADD: begin						// add
				yp = y;
				res = s;
			end
			SUB: begin						// sub
				subEn = 1;
				res = s;
			end
			EQL8: res = (x == y);			// eql8
			EQL5: res = (x[7:3] == m[7:3]);	// eql5

			// parity and reverse
			REVx: res = {x[0],x[1],x[2],x[3],x[4],x[5],x[6],x[7]};
			REVy: res = {y[0],y[1],y[2],y[3],y[4],y[5],y[6],y[7]};
			PARx: res = {7'b0, ^x};
			PARy: res = {7'b0, ^y};

			default: res = 8'b0;
		endcase
	end
end

// add block
full_adder fa0(.x(x[0]), .y(yp[0]||ss[0]), .ci(1'b0), .s(s[0]), .co(c[0]), .en(1'b1));
full_adder fa1(.x(x[1]), .y(yp[1]||ss[1]), .ci(c[0]), .s(s[1]), .co(c[1]), .en(1'b1));
full_adder fa2(.x(x[2]), .y(yp[2]||ss[2]), .ci(c[1]), .s(s[2]), .co(c[2]), .en(1'b1));
full_adder fa3(.x(x[3]), .y(yp[3]||ss[3]), .ci(c[2]), .s(s[3]), .co(c[3]), .en(1'b1));
full_adder fa4(.x(x[4]), .y(yp[4]||ss[4]), .ci(c[3]), .s(s[4]), .co(c[4]), .en(1'b1));
full_adder fa5(.x(x[5]), .y(yp[5]||ss[5]), .ci(c[4]), .s(s[5]), .co(c[5]), .en(1'b1));
full_adder fa6(.x(x[6]), .y(yp[6]||ss[6]), .ci(c[5]), .s(s[6]), .co(c[6]), .en(1'b1));
full_adder fa7(.x(x[7]), .y(yp[7]||ss[7]), .ci(c[6]), .s(s[7]), .co(c[7]), .en(1'b1));

// sub pre processing
full_adder sa0(.x(1'b1), .y(ny[0]), .ci(1'b0 ), .s(ss[0]), .co(cs[0]), .en(subEn));
full_adder sa1(.x(1'b0), .y(ny[1]), .ci(cs[0]), .s(ss[1]), .co(cs[1]), .en(subEn));
full_adder sa2(.x(1'b0), .y(ny[2]), .ci(cs[1]), .s(ss[2]), .co(cs[2]), .en(subEn));
full_adder sa3(.x(1'b0), .y(ny[3]), .ci(cs[2]), .s(ss[3]), .co(cs[3]), .en(subEn));
full_adder sa4(.x(1'b0), .y(ny[4]), .ci(cs[3]), .s(ss[4]), .co(cs[4]), .en(subEn));
full_adder sa5(.x(1'b0), .y(ny[5]), .ci(cs[4]), .s(ss[5]), .co(cs[5]), .en(subEn));
full_adder sa6(.x(1'b0), .y(ny[6]), .ci(cs[5]), .s(ss[6]), .co(cs[6]), .en(subEn));
full_adder sa7(.x(1'b0), .y(ny[7]), .ci(cs[6]), .s(ss[7]), .co(cs[7]), .en(subEn));


endmodule