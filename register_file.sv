import instr_pack ::*;

module register_file(
	input clk, func, movp,
	input reg_OP reg_op,
	input register reg_src, reg_dst, 
	input [3:0] instr_o,
	input [7:0] r, s, loadData,
	output logic [7:0] a=0, b=0, x=0, y=0, m=0, storData=0,
	output logic [9:0] p=0);

logic [7:0] regs[16];
logic [9:0] start_address=0;
logic [3:0] src=0, dst=0;
logic [7:0] n, npc=0;

logic	npc_en, lit_lo, lit_hi, mov, branch,
		loadEn, storEn, incr, decr, bizr, bnzr, jmpf, jmpb, seth,
		lslc, lsrc, flip, func, ljp0, ljp1, ljp2, ljp3;

always_comb begin
	$cast(src, reg_src);
	$cast(dst, reg_dst);
end

// register operations
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
	seth	=0;
	lslc	=0;
	lsrc	=0;
	flip	=0;
	func	=0;
	ljp0	=0;
	ljp1	=0;
	ljp2	=0;
	ljp3	=0;

	case (reg_op)
		 4: lit_lo	= 1;
		 5: lit_hi	= 1;
		 6: mov		= 1;//

		 8: loadEn	= 1;//
		 9: storEn	= 1;//
		10: incr	= 1;
		11: decr	= 1;
		12: jizr	= 1;
		13: jnzr	= 1;
		14: bizr	= 1;
		15: bnzr	= 1;

		17: seth	= 1;

		20: lslc	= 1;
		21: lsrc	= 1;
		22: flip	= 1;
		23: func	= 1;
		24: ljp0	= 1;//
		25: ljp1	= 1;//
		26: ljp2	= 1;//
		27: ljp3	= 1;//
	endcase
end

// special functions
always_latch
	if (func)
		case (instr_o)
		13: start_address[7:0] = regs[13][7:0];
		14: start_address[9:8] = regs[13][1:0];
		endcase

logic eql;
assign eql = (reg_src == reg_dst);

logic [7:0] mx, res;

reg_arithmetic rALU(.x(mx), .v(instr_o), .*);
pc_increment pcALU(.x(regs[4'hf]), .v(4'b0), .incr(1), .decr(0), .jizr(0), .jnzr(0), .res(npc), .r(8'b0), .s(8'b0));

assign a = regs[4'h8];
assign b = regs[4'h9];
assign m = regs[4'h4];
assign n = regs[4'h5];
assign x = regs[4'h6];
assign y = regs[4'h7];

always_comb

// program counter update
logic [1:0] p_hi;
always_ff @(posedge clk)
	if (!start) begin
		p_hi = p[9:8];
		if (branch) begin
			if (jizr||jnzr)			regs[4'hf] = res;
			else if (bizr||bnzr)	regs[4'hf] = regs[4'he];
		end
		else if (movp)				
			if(!eql)				regs[4'hf] = regs[src];
			else					regs[4'hf] = 8'b0;
		else if (ljp0) begin
									regs[4'hf] = regs[4'he];
									p_hi = 2'b00;
		end
		else if (ljp1) begin
									regs[4'hf] = regs[4'he];
									p_hi = 2'b01;
		end
		else if (ljp2) begin
									regs[4'hf] = regs[4'he];
									p_hi = 2'b10;
		end
		else if (ljp3) begin
									regs[4'hf] = regs[4'he];
									p_hi = 2'b11;
		end
		else						regs[4'hf] = npc;

		p = {p_hi, regs[4'hf]};
end

always_ff @(negedge clk) begin
	regs[4'h0] = r;
	regs[4'h1] = s;

	// check for pc brach conditions
	if (jizr||jnzr||bizr||bnzr) begin
		if (jizr) begin
		end else if (jnzr) begin
		end else if (bizr) begin
		end else if (bnzr) begin
		end
	end
	else begin
		if (mov&&(!movp)) begin
			if (eql)
				regs[src] = 8'b0;
			else
				regs[dst] = regs[src];
		end
		else if (loadEn)
			regs[dst] = loadData;
		else if (storEn)
			storData = regs[src];

		// increment pc
		regs[4'hf] = npc;
	end
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