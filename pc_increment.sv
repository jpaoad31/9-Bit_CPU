module pc_increment (
	input [9:0] rp,

	output [9:0] npc);

wire [9:0] c;

// add block
full_adder fa0(.x(rp[0]), .y(1'b1), .ci(1'b0), .s(npc[0]), .co(c[0]), .en(1'b1));
full_adder fa1(.x(rp[1]), .y(1'b0), .ci(c[0]), .s(npc[1]), .co(c[1]), .en(1'b1));
full_adder fa2(.x(rp[2]), .y(1'b0), .ci(c[1]), .s(npc[2]), .co(c[2]), .en(1'b1));
full_adder fa3(.x(rp[3]), .y(1'b0), .ci(c[2]), .s(npc[3]), .co(c[3]), .en(1'b1));
full_adder fa4(.x(rp[4]), .y(1'b0), .ci(c[3]), .s(npc[4]), .co(c[4]), .en(1'b1));
full_adder fa5(.x(rp[5]), .y(1'b0), .ci(c[4]), .s(npc[5]), .co(c[5]), .en(1'b1));
full_adder fa6(.x(rp[6]), .y(1'b0), .ci(c[5]), .s(npc[6]), .co(c[6]), .en(1'b1));
full_adder fa7(.x(rp[7]), .y(1'b0), .ci(c[6]), .s(npc[7]), .co(c[7]), .en(1'b1));
full_adder fa8(.x(rp[8]), .y(1'b0), .ci(c[6]), .s(npc[8]), .co(c[8]), .en(1'b1));
full_adder fa9(.x(rp[9]), .y(1'b0), .ci(c[6]), .s(npc[9]), .co(c[9]), .en(1'b1));

endmodule