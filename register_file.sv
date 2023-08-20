import instr_pack ::*;

module register_file(
	input clk,
	input reg_OP reg_op,
	input register reg_src, reg_dst, 
	input [3:0] instr_o,
	input [7:0] r, s, loadData,
	output logic [7:0] a, b, x, y, m, storData,
	output logic [9:0] p);

logic [7:0] regs[16];
logic [9:0] start_address;
logic [3:0] src, dst;
logic [7:0] n;

logic loadEn, storEn, incr, decr, bizr, bnzr, jmpf, jmpb;

always_latch begin
	lit_lo	=0;
	lit_hi	=0;
	mov		=0;
	loadEn	=0;
	storEn	=0;
	incr	=0;
	decr	=0;
	jizr	=0;
	jnzr	=0;
	bizr	=0;
	bnzr	=0;

	case (reg_op)
		 1: 
		 2:
		 3:
		 4: lit_lo	= 1;
		 5: lit_hi	= 1;
		 6: mov		= 1;

		 8: loadEn	= 1;
		 9: storEn	= 1;
		10: incr	= 1;
		11: decr	= 1;
		12: jizr	= 1;
		13: jnzr	= 1;
		14: bizr	= 1;
		15: bnzr	= 1;
		
	endcase
end

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

assign p[7:0] = regs[4'hf];

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