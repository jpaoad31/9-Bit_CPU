import instr_pack ::*;

module arithmetic_logic(
	input [7:0] x, y, m,				// input registers
	input math math_op,					// math operation to perform
	input alu_en, alu_rs,				// 0:r, 1:s

	output logic [7:0] s_out=0, r_out=0);	// output registers

	//output logic carry, zero, shift_out, equal

logic [7:0] yp, ny, s, c, cs, res;
logic add, sub, noop;

assign ny = ~y;

always_latch begin
	if (alu_en) begin
		if (alu_rs)
				s_out = res;
			else
				r_out = res;
	end
end

always_latch begin
	if (alu_en) begin
		case (math_op)
			0: begin			// add
				sub = 0;
				yp = y;
				res = s;
			end

			1: begin			// sub
				yp = 8'bz;
				sub = 1;
				res = s;
			end

			2: begin			// eql8
				res = (x == y);
			end

			3: begin			// eql5
				res = (x[4:0] == y[4:0]);
			end

			default: res = 8'b0;
		endcase
	end
end

// add block
full_adder fa0(.x(x[0]), .y(yp[0]), .ci(1'b0), .s(s[0]), .co(c[0]), .en(1'b1));
full_adder fa1(.x(x[1]), .y(yp[1]), .ci(c[0]), .s(s[1]), .co(c[1]), .en(1'b1));
full_adder fa2(.x(x[2]), .y(yp[2]), .ci(c[1]), .s(s[2]), .co(c[2]), .en(1'b1));
full_adder fa3(.x(x[3]), .y(yp[3]), .ci(c[2]), .s(s[3]), .co(c[3]), .en(1'b1));
full_adder fa4(.x(x[4]), .y(yp[4]), .ci(c[3]), .s(s[4]), .co(c[4]), .en(1'b1));
full_adder fa5(.x(x[5]), .y(yp[5]), .ci(c[4]), .s(s[5]), .co(c[5]), .en(1'b1));
full_adder fa6(.x(x[6]), .y(yp[6]), .ci(c[5]), .s(s[6]), .co(c[6]), .en(1'b1));
full_adder fa7(.x(x[7]), .y(yp[7]), .ci(c[6]), .s(s[7]), .co(c[7]), .en(1'b1));

// sub pre processing
full_adder sa0(.x(1'b1), .y(ny[0]), .ci(1'b0 ), .s(yp[0]), .co(cs[0]), .en(sub));
full_adder sa1(.x(1'b0), .y(ny[1]), .ci(cs[0]), .s(yp[1]), .co(cs[1]), .en(sub));
full_adder sa2(.x(1'b0), .y(ny[2]), .ci(cs[1]), .s(yp[2]), .co(cs[2]), .en(sub));
full_adder sa3(.x(1'b0), .y(ny[3]), .ci(cs[2]), .s(yp[3]), .co(cs[3]), .en(sub));
full_adder sa4(.x(1'b0), .y(ny[4]), .ci(cs[3]), .s(yp[4]), .co(cs[4]), .en(sub));
full_adder sa5(.x(1'b0), .y(ny[5]), .ci(cs[4]), .s(yp[5]), .co(cs[5]), .en(sub));
full_adder sa6(.x(1'b0), .y(ny[6]), .ci(cs[5]), .s(yp[6]), .co(cs[6]), .en(sub));
full_adder sa7(.x(1'b0), .y(ny[7]), .ci(cs[6]), .s(yp[7]), .co(cs[7]), .en(sub));


endmodule