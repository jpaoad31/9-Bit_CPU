import instr_pack ::*;

module register_file_r(
	input clk, movp, start, alu_en, loadEn, storEn,
	input reg_OP reg_op,
	input register reg_src, reg_dst, 
	input [3:0] instr_o,
	input [7:0] rr, rs, loadData,
	output logic [7:0] ra, rb, rx, ry, rm, storData=0,
	output logic [9:0] rp=0);

logic [7:0] rc, rd, rn, ri, rj, rk, rl, rz;
logic [9:0] start_address=0;
logic [7:0] npc=0, temp;

logic [7:0] mx=0, res=0;
reg_arithmetic rALU(.x(mx), .v(instr_o[2:0]), .*);
reg_arithmetic pcALU(.x(rp[7:0]), .v(3'b0), .incr(1), .decr(0), .jizr(0), .jnzr(0), .res(npc));

logic	branch, othr, mov, incr, decr,
		bizr, bnzr, jizr, jnzr,
		lj0, lj1, lj2, lj3;

logic eql;
assign eql = (reg_src == reg_dst);

// register operations
always_comb begin
	mov		=0;
	incr	=0;
	decr	=0;

	jizr	=0;
	jnzr	=0;
	bizr	=0;
	bnzr	=0;

	lj0	=0;
	lj1	=0;
	lj2	=0;
	lj3	=0;

	othr	=0;

	case (reg_op)
		movEn:	mov		= 1;
		incrEn:	incr	= 1;
		decrEn:	decr	= 1;

		jizrEn: jizr	= 1;
		jnzrEn: jnzr	= 1;
		bizrEn: bizr	= 1;
		bnzrEn: bnzr	= 1;

		ljp0: lj0	= 1;
		ljp1: lj1	= 1;
		ljp2: lj2	= 1;
		ljp3: lj3	= 1;

		default: othr = 1;
	endcase
end

// program counter update
always_ff @(posedge clk) begin
	if (!start) begin

		if (branch) begin
			if (jizr||jnzr)			rp[7:0] = res;
			else if (bizr||bnzr)	rp[7:0] = rz;
		end

		else if (movp)				
			case (reg_src)
			r: rp[7:0] = rr;
			s: rp[7:0] = rs;
			c: rp[7:0] = rc;
			d: rp[7:0] = rd;
			m: rp[7:0] = rm;
			n: rp[7:0] = rn;
			x: rp[7:0] = rx;
			y: rp[7:0] = ry;
			a: rp[7:0] = ra;
			b: rp[7:0] = rb;
			i: rp[7:0] = ri;
			j: rp[7:0] = rj;
			k: rp[7:0] = rk;
			l: rp[7:0] = rl;
			z: rp[7:0] = rz;
			default: rp = 10'b0;
			endcase

		else if (ljp0) begin
				rp = {2'b00, rz};
		end
		else if (ljp1) begin
				rp = {2'b01, rz};
		end
		else if (ljp2) begin
				rp = {2'b10, rz};
		end
		else if (ljp3) begin
				rp = {2'b11, rz};
		end
		else	rp[7:0] = npc;
	end
	else rp = start_address;
end

always_comb begin
	if ((incr||decr||mov||bizr||bnzr)&&!movp) begin
		case (reg_src)
			r: temp = rr;
			s: temp = rs;
			c: temp = rc;
			d: temp = rd;
			m: temp = rm;
			n: temp = rn;
			x: temp = rx;
			y: temp = ry;
			a: temp = ra;
			b: temp = rb;
			i: temp = ri;
			j: temp = rj;
			k: temp = rk;
			l: temp = rl;
			z: temp = rz;
			p: temp = rp[7:0];
		endcase
		if (eql && mov) temp = 8'b0;
		mx = temp;
	end else begin
		temp = 8'b0;
		mx = temp;
	end
end


always_ff @(negedge clk) begin
	branch = 0;
	case (reg_op)
		lit_lo: rl[3:0] = instr_o;
		lit_hi: rl[7:4] = instr_o;
		movEn: begin
			case (reg_dst)
					c: rc = temp;
					d: rd = temp;
					m: rm = temp;
					n: rn = temp;
					x: rx = temp;
					y: ry = temp;
					a: ra = temp;
					b: rb = temp;
					i: ri = temp;
					j: rj = temp;
					k: rk = temp;
					l: rl = temp;
					z: rz = temp;
			endcase
			end
		incrEn, decrEn: begin
			case (reg_dst)
					c: rc = res;
					d: rd = res;
					m: rm = res;
					n: rn = res;
					x: rx = res;
					y: ry = res;
					a: ra = res;
					b: rb = res;
					i: ri = res;
					j: rj = res;
					k: rk = res;
					l: rl = res;
					z: rz = res;
			endcase
			end
		jizrEn: begin
			if (!instr_o[3] && !rr) branch = 1;
			else if (!rs) branch = 1;
			end
		jnzrEn: begin
			if (!instr_o[3] && rr) branch = 1;
			else if (rs) branch = 1;
			end
		bizrEn: begin
			if (!temp) branch = 1;
			end
		bnzrEn: begin
			if (temp) branch = 1;
			end
		sethEn: begin
			case (instr_o[3:0])
				4'b0: rm[0] = 1'b1;
			endcase
			end
	endcase
end
endmodule

/*
	// check for pc brach conditions
	if (jizr||jnzr) begin
		mx = rp[7:0];
		if (jizr) begin
			if (!instr_o[3]) begin
				if (!rr) branch = 1;
			end else
				if (!rs) branch = 1;
		end
		else if (jnzr) begin
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
		
	end
end
*/


/*
case (reg_src)
					r:
					s:
					c:
					d:
					m:
					n:
					x:
					y:
					a:
					b:
					i:
					j:
					k:
					l:
					z:
					p:
					endcase
*/