module reg_arithmetic (
	input [7:0] x,
	input [2:0] v,
	input incr, decr, jizr, jnzr,

	output [7:0] res);
logic add, sub;
logic [7:0] y, yp, ny, s, c, cs;

always_comb begin

	y = 8'b00000000;
	add = 0;
	sub = 0;

	if (incr) begin
		y[0] = 1'b1;
		add = 1;
	end

	else if(decr) begin
		y[0] = 1'b1;
		sub = 1;
	end

	else begin			// jizr | jnzr
		y[3:1] = v;
		add = 1;
	end

end

always_comb begin
	yp = 8'bz;
	if (add)
		yp = y;
end

assign ny = ~y;
assign res = s;

// add block
full_adder fa0(.x(x[0]), .y(yp[0]), .ci(1'b0), .s(s[0]), .co(c[0]), .en(add|sub));
full_adder fa1(.x(x[1]), .y(yp[1]), .ci(c[0]), .s(s[1]), .co(c[1]), .en(add|sub));
full_adder fa2(.x(x[2]), .y(yp[2]), .ci(c[1]), .s(s[2]), .co(c[2]), .en(add|sub));
full_adder fa3(.x(x[3]), .y(yp[3]), .ci(c[2]), .s(s[3]), .co(c[3]), .en(add|sub));
full_adder fa4(.x(x[4]), .y(yp[4]), .ci(c[3]), .s(s[4]), .co(c[4]), .en(add|sub));
full_adder fa5(.x(x[5]), .y(yp[5]), .ci(c[4]), .s(s[5]), .co(c[5]), .en(add|sub));
full_adder fa6(.x(x[6]), .y(yp[6]), .ci(c[5]), .s(s[6]), .co(c[6]), .en(add|sub));
full_adder fa7(.x(x[7]), .y(yp[7]), .ci(c[6]), .s(s[7]), .co(c[7]), .en(add|sub));

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