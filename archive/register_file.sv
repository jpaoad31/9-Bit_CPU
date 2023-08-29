import instr_pack ::*;

module register_file(
	input clk, movp, start, alu_en,
	input reg_OP reg_op,
	input register reg_src, reg_dst, 
	input [3:0] instr_o,
	input [7:0] r, s, loadData,
	output logic [7:0] a, b, x, y, m, storData=0,
	output logic [9:0] p=0);

logic [7:0] regs[16];
logic [9:0] start_address=0;
logic [3:0] src=0, dst=0;
logic [7:0] n, npc=0;

logic	lit_lo, lit_hi, mov, branch,
		loadEn, storEn, incr, decr, bizr, bnzr, jizr, jnzr, seth,
		lslc, lsrc, flip, func, ljp0, ljp1, ljp2, ljp3;

always_comb begin
	$cast(src, reg_src);
	$cast(dst, reg_dst);
end

// register operations
always_comb begin
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
		 6: mov		= 1;

		 8: loadEn	= 1;
		 9: storEn	= 1;
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
		24: ljp0	= 1;
		25: ljp1	= 1;
		26: ljp2	= 1;
		27: ljp3	= 1;
		default: lit_lo = 1;
	endcase
end

logic eql;
assign eql = (reg_src == reg_dst);

logic [7:0] mx=0, res=0;
logic [1:0] p_hi=0;

reg_arithmetic rALU(.x(mx), .v(instr_o[2:0]), .*);
pc_increment pcALU(.x(regs[4'hf]), .v(3'b0), .incr(1), .decr(0), .jizr(0), .jnzr(0), .res(npc));

assign a = regs[4'h8];
assign b = regs[4'h9];
assign m = regs[4'h4];
assign n = regs[4'h5];
assign x = regs[4'h6];
assign y = regs[4'h7];

// program counter update

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
	end else p = start_address;

//register update
always_ff @(negedge clk) begin
	if (incr)
		if (src != 4'hf)
			regs[src] = res;
	else if (decr)
		if (src != 4'hf)
			regs[src] = res;
end

always_ff @(negedge clk) begin
	branch = 0;
	mx = 0;

	// check for pc brach conditions
	if (jizr||jnzr||bizr||bnzr) begin
		if (jizr) begin
			mx = regs[15];
			if (!instr_o[3]) begin
				if (!regs[4'h0]) branch = 1;
			end else
				if (!regs[4'h1]) branch = 1;
		end
		else if (jnzr) begin
			mx = regs[15];
			if (!instr_o[3]) begin
				if (regs[4'h0]) branch = 1;
			end else
				if (regs[4'h1]) branch = 1;
		end
		else if (bizr) begin
			if (!regs[src])  branch = 1;
		end
		else if (bnzr) begin
			if (regs[src])  branch = 1;
		end
		
	end
	/*
	else begin
		if (alu_en) begin
			regs[4'h0] = r;
			regs[4'h1] = s;
		end
		else if (lit_lo) regs[4'hd][3:0] = instr_o;
		else if (lit_hi) regs[4'hd][7:4] = instr_o;
		
		else if ((mov&&!movp) && (dst > 4'h1)) begin
			if (eql) begin
				if ((src != 0) && (src != 1))
				regs[src] = 8'b0;
			end
			else
				regs[dst] = regs[src];
		end
		
		else if (loadEn) begin
			if ((dst != 0) && (dst != 1))
				regs[dst] = loadData;
		end
		
		else if (storEn)
			storData = regs[src];
		else if (incr) begin
			if ((src != 4'hf) && (src > 4'h1)) begin
				mx = regs[src];
			end
		end
		else if (decr) begin
			if ((src != 4'hf) && (src > 4'h1)) begin
				mx = regs[src];
			end
		end
		
		else if (seth) begin
			if (!instr_o[3])
				regs[4'h4][instr_o[2:0]] = 1'b1;
			else
				regs[4'h5][instr_o[2:0]] = 1'b1;
		end
		else if (lslc) begin
			if (!instr_o[3])			// m
				case (instr_o[2:0])
				1: regs[4'h4] = {regs[4'h4][6:0], regs[4'h5][7]};
				2: regs[4'h4] = {regs[4'h4][5:0], regs[4'h5][7:6]};
				3: regs[4'h4] = {regs[4'h4][4:0], regs[4'h5][7:5]};
				4: regs[4'h4] = {regs[4'h4][3:0], regs[4'h5][7:4]};
				5: regs[4'h4] = {regs[4'h4][2:0], regs[4'h5][7:3]};
				6: regs[4'h4] = {regs[4'h4][1:0], regs[4'h5][7:2]};
				7: regs[4'h4] = {regs[4'h4][0]  , regs[4'h5][7:1]};
				default: regs[4'h4] = regs[4'h4];
				endcase
			else						// n
				case (instr_o[2:0])
				1: regs[4'h5] = {regs[4'h5][6:0], regs[4'h4][7]};
				2: regs[4'h5] = {regs[4'h5][5:0], regs[4'h4][7:6]};
				3: regs[4'h5] = {regs[4'h5][4:0], regs[4'h4][7:5]};
				4: regs[4'h5] = {regs[4'h5][3:0], regs[4'h4][7:4]};
				5: regs[4'h5] = {regs[4'h5][2:0], regs[4'h4][7:3]};
				6: regs[4'h5] = {regs[4'h5][1:0], regs[4'h4][7:2]};
				7: regs[4'h5] = {regs[4'h5][0]  , regs[4'h4][7:1]};
				default: regs[4'h5] = regs[4'h5];
				endcase
		end
		else if (lsrc) begin
			if (!instr_o[3])			// m
				case (instr_o[2:0])
				1: regs[4'h4] = {regs[4'h5][0]  , regs[4'h4][7:1]};
				2: regs[4'h4] = {regs[4'h5][1:0], regs[4'h4][7:2]};
				3: regs[4'h4] = {regs[4'h5][2:0], regs[4'h4][7:3]};
				4: regs[4'h4] = {regs[4'h5][3:0], regs[4'h4][7:4]};
				5: regs[4'h4] = {regs[4'h5][4:0], regs[4'h4][7:5]};
				6: regs[4'h4] = {regs[4'h5][5:0], regs[4'h4][7:6]};
				7: regs[4'h4] = {regs[4'h5][6:0], regs[4'h4][7]};
				default: regs[4'h4] = regs[4'h4];
				endcase
			else						// n
				case (instr_o[2:0])
				1: regs[4'h5] = {regs[4'h4][0]  , regs[4'h5][7:1]};
				2: regs[4'h5] = {regs[4'h4][1:0], regs[4'h5][7:2]};
				3: regs[4'h5] = {regs[4'h4][2:0], regs[4'h5][7:3]};
				4: regs[4'h5] = {regs[4'h4][3:0], regs[4'h5][7:4]};
				5: regs[4'h5] = {regs[4'h4][4:0], regs[4'h5][7:5]};
				6: regs[4'h5] = {regs[4'h4][5:0], regs[4'h5][7:6]};
				7: regs[4'h5] = {regs[4'h4][6:0], regs[4'h5][7]};
				default: regs[4'h4] = regs[4'h4];
				endcase
		end
		else if (flip) begin
			if (!instr_o[3])
				case (instr_o[2:0])
				0: regs[4'h4] = regs[4'h4] ^ 8'b00000001;
				1: regs[4'h4] = regs[4'h4] ^ 8'b00000010;
				2: regs[4'h4] = regs[4'h4] ^ 8'b00000100;
				3: regs[4'h4] = regs[4'h4] ^ 8'b00001000;
				4: regs[4'h4] = regs[4'h4] ^ 8'b00010000;
				5: regs[4'h4] = regs[4'h4] ^ 8'b00100000;
				6: regs[4'h4] = regs[4'h4] ^ 8'b01000000;
				default: regs[4'h4] = regs[4'h4] ^ 8'b10000000;
				endcase
			else
				case (instr_o[2:0])
				0: regs[4'h5] = regs[4'h5] ^ 8'b00000001;
				1: regs[4'h5] = regs[4'h5] ^ 8'b00000010;
				2: regs[4'h5] = regs[4'h5] ^ 8'b00000100;
				3: regs[4'h5] = regs[4'h5] ^ 8'b00001000;
				4: regs[4'h5] = regs[4'h5] ^ 8'b00010000;
				5: regs[4'h5] = regs[4'h5] ^ 8'b00100000;
				6: regs[4'h5] = regs[4'h5] ^ 8'b01000000;
				default: regs[4'h5] = regs[4'h5] ^ 8'b10000000;
				endcase
		end
		else begin			// func
			case (instr_o)
			13: start_address[7:0] = regs[13][7:0];
			default: start_address[9:8] = regs[13][1:0];
			endcase
		end
		
	end*/
end

endmodule