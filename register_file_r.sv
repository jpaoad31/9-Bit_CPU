import instr_pack ::*;

module register_file_r(
	input clk, start, alu_en, loadEn, storEn, jump2sub,
	input reg_OP reg_op,
	input register reg_src, reg_dst, 
	input [3:0] instr_o,
	input [7:0] rr, rs, loadData,
	output logic [7:0] ra=8, rb=9, rx=6, ry=7, rm=4, storData=0,
	output logic [9:0] rp=0);

logic [7:0] rc=2, rd=3, rn=5, ri=10, rj=11, rk=12, rv=13, rz=14;
logic [9:0] start_address=0, rl=15;
wire [9:0] subroutine;
logic [7:0] temp=0;

logic [7:0] mx=0, res=0;
reg_arithmetic rALU(.x(mx), .v(instr_o[2:0]), .*);

logic	branch=0, othr=0, mov=0, incr=0, decr=0,
		bizr=0, bnzr=0, jizr=0, jnzr=0,
		lj0=0, lj1=0, lj2=0, lj3=0;

logic eql;

subroutine_LUT sLUT(.*);

program_counter pc_reg(.*);

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

// branch checking
always_comb begin
	branch = 0;
	if (incr||decr||mov||bizr||bnzr) begin
		case (reg_src)
			regr: temp = rr;
			regs: temp = rs;
			regc: temp = rc;
			regd: temp = rd;
			regm: temp = rm;
			regn: temp = rn;
			regx: temp = rx;
			regy: temp = ry;
			rega: temp = ra;
			regb: temp = rb;
			regi: temp = ri;
			regj: temp = rj;
			regk: temp = rk;
			regv: temp = rv;
			regz: temp = rz;
			regl: temp = rl[7:0];
			default: temp = 8'b0;
		endcase
		if (eql && mov) temp = 8'b0;
	end else if (jizr||jnzr) begin
		temp = rp[7:0]; 
	end else begin
		temp = 8'b0;
	end
	mx = temp;
	case (reg_op)
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
		default: branch = 0;
	endcase
end

always_comb
	if (storEn)
		case (reg_src)
		regr: storData = rr;
		regs: storData = rs;
		regc: storData = rc;
		regd: storData = rd;
		regm: storData = rm;
		regn: storData = rn;
		regx: storData = rx;
		regy: storData = ry;
		default: storData = 8'bz;
		endcase
	else storData = 8'bz;

always_latch
	if (reg_op == funcEn)
			case (instr_o)
				4'b1100: start_address[7:0] = rv;
				4'b1101: start_address[1:0] = rv[1:0];
				default: start_address = start_address;
			endcase

always_ff @(posedge clk) begin
	if (loadEn)
		case (reg_dst)
		regc: rc <= loadData;
		regd: rd <= loadData;
		regm: rm <= loadData;
		regn: rn <= loadData;
		regx: rx <= loadData;
		regy: ry <= loadData;
		endcase
	else
	case (reg_op)
		val_lo: rv[3:0] <= instr_o;
		val_hi: rv[7:4] <= instr_o;
		movEn: begin
			case (reg_dst)
				regc: rc <= temp;
				regd: rd <= temp;
				regm: rm <= temp;
				regn: rn <= temp;
				regx: rx <= temp;
				regy: ry <= temp;
				rega: ra <= temp;
				regb: rb <= temp;
				regi: ri <= temp;
				regj: rj <= temp;
				regk: rk <= temp;
				regv: rv <= temp;
				regz: rz <= temp;
			endcase
			end
		incrEn, decrEn: begin
			case (reg_dst)
				regc: rc <= res;
				regd: rd <= res;
				regm: rm <= res;
				regn: rn <= res;
				regx: rx <= res;
				regy: ry <= res;
				rega: ra <= res;
				regb: rb <= res;
				regi: ri <= res;
				regj: rj <= res;
				regk: rk <= res;
				regv: rv <= res;
				regz: rz <= res;
			endcase
			end
		sethEn: begin
			case (instr_o)
				4'h0: rm[0] <= 1'b1;
				4'h1: rm[1] <= 1'b1;
				4'h2: rm[2] <= 1'b1;
				4'h3: rm[3] <= 1'b1;
				4'h4: rm[4] <= 1'b1;
				4'h5: rm[5] <= 1'b1;
				4'h6: rm[6] <= 1'b1;
				4'h7: rm[7] <= 1'b1;
				4'h8: rn[0] <= 1'b1;
				4'h9: rn[1] <= 1'b1;
				4'ha: rn[2] <= 1'b1;
				4'hb: rn[3] <= 1'b1;
				4'hc: rn[4] <= 1'b1;
				4'hd: rn[5] <= 1'b1;
				4'he: rn[6] <= 1'b1;
				4'hf: rn[7] <= 1'b1;
			endcase
			end
		lslcEn: begin
			case (instr_o)
				4'b0000: rm <= rn;
				4'b0001: rm <= {rm[6:0],rn[7]};
				4'b0010: rm <= {rm[5:0],rn[7:6]};
				4'b0011: rm <= {rm[4:0],rn[7:5]};
				4'b0100: rm <= {rm[3:0],rn[7:4]};
				4'b0101: rm <= {rm[2:0],rn[7:3]};
				4'b0110: rm <= {rm[1:0],rn[7:2]};
				4'b0111: rm <= {rm[0]  ,rn[7:1]};

				4'b1000: rn <= rm;
				4'b1001: rn <= {rn[6:0],rm[7]};
				4'b1010: rn <= {rn[5:0],rm[7:6]};
				4'b1011: rn <= {rn[4:0],rm[7:5]};
				4'b1100: rn <= {rn[3:0],rm[7:4]};
				4'b1101: rn <= {rn[2:0],rm[7:3]};
				4'b1110: rn <= {rn[1:0],rm[7:2]};
				4'b1111: rn <= {rn[0]  ,rm[7:1]};
			endcase
			end
		lsrcEn: begin
			case (instr_o[3:0])
				4'b0000: rm <= rn;
				4'b0001: rm <= {rn[0]  , rm[7:1]};
				4'b0010: rm <= {rn[1:0], rm[7:2]};
				4'b0011: rm <= {rn[2:0], rm[7:3]};
				4'b0100: rm <= {rn[3:0], rm[7:4]};
				4'b0101: rm <= {rn[4:0], rm[7:5]};
				4'b0110: rm <= {rn[5:0], rm[7:6]};
				4'b0111: rm <= {rn[6:0], rm[7]};

				4'b1000: rn <= rm;
				4'b1001: rn <= {rm[0]  , rn[7:1]};
				4'b1010: rn <= {rm[1:0], rn[7:2]};
				4'b1011: rn <= {rm[2:0], rn[7:3]};
				4'b1100: rn <= {rm[3:0], rn[7:4]};
				4'b1101: rn <= {rm[4:0], rn[7:5]};
				4'b1110: rn <= {rm[5:0], rn[7:6]};
				4'b1111: rn <= {rm[6:0], rn[7]};
			endcase
			end
		flipEn: begin
			case (instr_o)
				4'b0000: rm <= rm ^ 8'b00000001;
				4'b0001: rm <= rm ^ 8'b00000010;
				4'b0010: rm <= rm ^ 8'b00000100;
				4'b0011: rm <= rm ^ 8'b00001000;
				4'b0100: rm <= rm ^ 8'b00010000;
				4'b0101: rm <= rm ^ 8'b00100000;
				4'b0110: rm <= rm ^ 8'b01000000;
				4'b0111: rm <= rm ^ 8'b10000000;

				4'b1000: rn <= rn ^ 8'b00000001;
				4'b1001: rn <= rn ^ 8'b00000010;
				4'b1010: rn <= rn ^ 8'b00000100;
				4'b1011: rn <= rn ^ 8'b00001000;
				4'b1100: rn <= rn ^ 8'b00010000;
				4'b1101: rn <= rn ^ 8'b00100000;
				4'b1110: rn <= rn ^ 8'b01000000;
				4'b1111: rn <= rn ^ 8'b10000000;
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
					v:
					z:
					l:
					endcase
*/