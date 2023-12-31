module reg_arithmetic (
	input [9:0] x,
	input [2:0] v,
	input incr, decr, jizr, jnzr,

	output [9:0] res);
logic sub=0;
logic [9:0] y, yp, ny;
wire [9:0] s, c, cs;

always_comb begin

	y = 8'b00000000;
	sub = 0;

	if (incr) begin
		y[0] = 1'b1;
	end

	else if(decr) begin
		y[0] = 1'b1;
		sub = 1;
	end

	else begin			// jizr | jnzr
		if(v)
			y[3:1] = v;
		else
			y[4:0] = 5'b10000;	// prevent 0-distance jumps
	end

end

always_comb begin
	yp = 8'bz;
	if (!sub)
		yp = y;
end

assign ny = ~y;
assign res = s;

// add block
full_adder fa0(.x(x[0]), .y(yp[0]), .ci(1'b0), .s(s[0]), .co(c[0]), .en(1'b1));
full_adder fa1(.x(x[1]), .y(yp[1]), .ci(c[0]), .s(s[1]), .co(c[1]), .en(1'b1));
full_adder fa2(.x(x[2]), .y(yp[2]), .ci(c[1]), .s(s[2]), .co(c[2]), .en(1'b1));
full_adder fa3(.x(x[3]), .y(yp[3]), .ci(c[2]), .s(s[3]), .co(c[3]), .en(1'b1));
full_adder fa4(.x(x[4]), .y(yp[4]), .ci(c[3]), .s(s[4]), .co(c[4]), .en(1'b1));
full_adder fa5(.x(x[5]), .y(yp[5]), .ci(c[4]), .s(s[5]), .co(c[5]), .en(1'b1));
full_adder fa6(.x(x[6]), .y(yp[6]), .ci(c[5]), .s(s[6]), .co(c[6]), .en(1'b1));
full_adder fa7(.x(x[7]), .y(yp[7]), .ci(c[6]), .s(s[7]), .co(c[7]), .en(1'b1));
full_adder fa8(.x(x[8]), .y(yp[8]), .ci(c[7]), .s(s[8]), .co(c[8]), .en(1'b1));
full_adder fa9(.x(x[9]), .y(yp[9]), .ci(c[8]), .s(s[9]), .co(c[9]), .en(1'b1));

// sub pre processing
full_adder sa0(.x(1'b1), .y(ny[0]), .ci(1'b0 ), .s(yp[0]), .co(cs[0]), .en(sub));
full_adder sa1(.x(1'b0), .y(ny[1]), .ci(cs[0]), .s(yp[1]), .co(cs[1]), .en(sub));
full_adder sa2(.x(1'b0), .y(ny[2]), .ci(cs[1]), .s(yp[2]), .co(cs[2]), .en(sub));
full_adder sa3(.x(1'b0), .y(ny[3]), .ci(cs[2]), .s(yp[3]), .co(cs[3]), .en(sub));
full_adder sa4(.x(1'b0), .y(ny[4]), .ci(cs[3]), .s(yp[4]), .co(cs[4]), .en(sub));
full_adder sa5(.x(1'b0), .y(ny[5]), .ci(cs[4]), .s(yp[5]), .co(cs[5]), .en(sub));
full_adder sa6(.x(1'b0), .y(ny[6]), .ci(cs[5]), .s(yp[6]), .co(cs[6]), .en(sub));
full_adder sa7(.x(1'b0), .y(ny[7]), .ci(cs[6]), .s(yp[7]), .co(cs[7]), .en(sub));
full_adder sa8(.x(1'b0), .y(ny[8]), .ci(cs[7]), .s(yp[8]), .co(cs[8]), .en(sub));
full_adder sa9(.x(1'b0), .y(ny[9]), .ci(cs[8]), .s(yp[9]), .co(cs[9]), .en(sub));


endmodule