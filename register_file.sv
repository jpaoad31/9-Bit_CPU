import instr_pack ::*;

module register_file(
	input clk, loadEn, storEn, mov, incr, decr, nibble, lit,
	input [2:0] branch,
	input register reg_src, reg_dst, 
	input [3:0] instr_o,
	input [7:0] r, s, loadData,
	output logic [7:0] a, b, x, y, m, storData,
	output logic [9:0] p);

logic [7:0] regs[16];
logic [9:0] start_address;
logic [3:0] src, dst;
logic [7:0] n;

always_comb begin
	$cast(src, reg_src);
	$cast(dst, reg_dst);
end

logic eql;
assign eql = (reg_src == reg_dst);

logic [7:0] mx, res;

reg_arithmetic rALU(.x(mx), .v(instr_o), .*);

assign a = regs[4'h8];
assign b = regs[4'h9];
assign m = regs[4'h4];
assign n = regs[4'h5];
assign x = regs[4'h6];
assign y = regs[4'h7];

logic bizr, bnzr, jmpf, jmpb;

assign p[7:0] = regs[4'hf];

always_comb begin
	bizr = 0;
	bnzr = 0;
	jmpf = 0;
	jmpb = 0;

	case (branch)
	4: jmpf = 1;
	5: jmpb = 1;
	6: bizr = 1;
	7: bnzr = 1;
	endcase
end

always_ff @(negedge clk) begin

	regs[4'h0] = r;
	regs[4'h1] = s;

	if (mov) begin
		if (eql)
			regs[src] = 8'b0;
		else
			regs[dst] = regs[src];
	end
	else if (loadEn)
		regs[dst] = loadData;
	else if (storEn)
		storData = regs[src];
	else if (bizr)
		if (!regs[src])
			regs[4'hf] = regs[4'he];
	else if (bnzr)
		if (regs[src])
			regs[4'hf] = regs[4'he];
/*
	else if (flip) begin
		case (instr_o[3])
			0:
			1:
		endcase
	end

	else begin
*/
end

endmodule