import instr_pack ::*;

module register_file_r(
	input clk, movp, start, alu_en, loadEn, storEn,
	input reg_OP reg_op,
	input register reg_src, reg_dst, 
	input [3:0] instr_o,
	input [7:0] rr, rs, loadData,
	output logic [7:0] ra=8, rb=9, rx=6, ry=7, rm=4, storData=0,
	output logic [9:0] rp=0);

logic [7:0] rc=2, rd=3, rn=5, ri=10, rj=11, rk=12, rl=13, rz=14;
logic [9:0] start_address=0;
logic [7:0] npc=0, temp=0;

logic [7:0] mx=0, res=0;
reg_arithmetic rALU(.x(mx), .v(instr_o[2:0]), .*);
reg_arithmetic pcALU(.x(rp[7:0]), .v(3'b0), .incr(1), .decr(0), .jizr(0), .jnzr(0), .res(npc));

logic	branch=0, othr=0, mov=0, incr=0, decr=0,
		bizr=0, bnzr=0, jizr=0, jnzr=0,
		lj0=0, lj1=0, lj2=0, lj3=0;

logic eql;


assign eql = (reg_src == reg_dst);

// register operation flags
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

		else if (lj0) begin
				rp = {2'b00, rz};
		end
		else if (lj1) begin
				rp = {2'b01, rz};
		end
		else if (lj2) begin
				rp = {2'b10, rz};
		end
		else if (lj3) begin
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
			default: temp = 8'b0;
		endcase
		if (eql && mov) temp = 8'b0;
		mx = temp;
	end else begin
		temp = 8'b0;
		mx = temp;
	end
end

always_comb
	if (storEn)
		case (reg_src)
		r: storData = rr;
		s: storData = rs;
		c: storData = rc;
		d: storData = rd;
		m: storData = rm;
		n: storData = rn;
		x: storData = rx;
		y: storData = ry;
		default: storData = 8'bz;
		endcase
	else storData = 8'bz;

always_latch
	if (reg_op == funcEn)
			case (instr_o)
				4'b1100: start_address[7:0] = l;
				4'b1101: start_address[1:0] = l[1:0];
			endcase

always_ff @(negedge clk) begin
	branch = 0;
	if (loadEn)
		case (reg_dst)
		c: rc = loadData;
		d: rd = loadData;
		m: rm = loadData;
		n: rn = loadData;
		x: rx = loadData;
		y: ry = loadData;
		endcase
	else
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
			case (instr_o)
				4'h0: rm[0] = 1'b1;
				4'h1: rm[1] = 1'b1;
				4'h2: rm[2] = 1'b1;
				4'h3: rm[3] = 1'b1;
				4'h4: rm[4] = 1'b1;
				4'h5: rm[5] = 1'b1;
				4'h6: rm[6] = 1'b1;
				4'h7: rm[7] = 1'b1;
				4'h8: rn[0] = 1'b1;
				4'h9: rn[1] = 1'b1;
				4'ha: rn[2] = 1'b1;
				4'hb: rn[3] = 1'b1;
				4'hc: rn[4] = 1'b1;
				4'hd: rn[5] = 1'b1;
				4'he: rn[6] = 1'b1;
				4'hf: rn[7] = 1'b1;
			endcase
			end
		lslcEn: begin
			case (instr_o)
				4'b0000: rm = rm;
				4'b0001: rm = {rm[6:0],rn[7]};
				4'b0010: rm = {rm[5:0],rn[7:6]};
				4'b0011: rm = {rm[4:0],rn[7:5]};
				4'b0100: rm = {rm[3:0],rn[7:4]};
				4'b0101: rm = {rm[2:0],rn[7:3]};
				4'b0110: rm = {rm[1:0],rn[7:2]};
				4'b0111: rm = {rm[0]  ,rn[7:1]};

				4'b1000: rn = rn;
				4'b1001: rn = {rn[6:0],rn[7]};
				4'b1010: rn = {rn[5:0],rn[7:6]};
				4'b1011: rn = {rn[4:0],rn[7:5]};
				4'b1100: rn = {rn[3:0],rn[7:4]};
				4'b1101: rn = {rn[2:0],rn[7:3]};
				4'b1110: rn = {rn[1:0],rn[7:2]};
				4'b1111: rn = {rn[0]  ,rn[7:1]};
			endcase
			end
		lsrcEn: begin
			case (instr_o[3:0])
				4'b0000: rm = rm;
				4'b0001: rm = {rn[0]  , rm[7:1]};
				4'b0010: rm = {rn[1:0], rm[7:2]};
				4'b0011: rm = {rn[2:0], rm[7:3]};
				4'b0100: rm = {rn[3:0], rm[7:4]};
				4'b0101: rm = {rn[4:0], rm[7:5]};
				4'b0110: rm = {rn[5:0], rm[7:6]};
				4'b0111: rm = {rn[6:0], rm[7]};

				4'b1000: rn = rn;
				4'b1001: rn = {rm[0]  , rn[7:1]};
				4'b1010: rn = {rm[1:0], rn[7:2]};
				4'b1011: rn = {rm[2:0], rn[7:3]};
				4'b1100: rn = {rm[3:0], rn[7:4]};
				4'b1101: rn = {rm[4:0], rn[7:5]};
				4'b1110: rn = {rm[5:0], rn[7:6]};
				4'b1111: rn = {rm[6:0], rn[7]};
			endcase
			end
		flipEn: begin
			case (instr_o)
				4'b0000: rm = rm ^ 8'b00000001;
				4'b0001: rm = rm ^ 8'b00000010;
				4'b0010: rm = rm ^ 8'b00000100;
				4'b0011: rm = rm ^ 8'b00001000;
				4'b0100: rm = rm ^ 8'b00010000;
				4'b0101: rm = rm ^ 8'b00100000;
				4'b0110: rm = rm ^ 8'b01000000;
				4'b0111: rm = rm ^ 8'b10000000;

				4'b1000: rn = rn ^ 8'b00000001;
				4'b1001: rn = rn ^ 8'b00000010;
				4'b1010: rn = rn ^ 8'b00000100;
				4'b1011: rn = rn ^ 8'b00001000;
				4'b1100: rn = rn ^ 8'b00010000;
				4'b1101: rn = rn ^ 8'b00100000;
				4'b1110: rn = rn ^ 8'b01000000;
				4'b1111: rn = rn ^ 8'b10000000;
			endcase
			end
	endcase
end
endmodule


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