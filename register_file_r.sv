import instr_pack ::*;

module register_file_r(
	input clk, start, alu_en, loadEn, storEn,
	input reg_OP reg_op,
	input register reg_src, reg_dst, 
	input [3:0] instr_o,
	input [7:0] rr, rs, loadData,
	output logic [7:0] ra=8, rb=9, rx=6, ry=7, rm=4, storData=0,
	output logic [9:0] rp=0);

logic [7:0] rc=2, rd=3, rn=5, ri=10, rj=11, rk=12, rv=13, rz=14;
logic [9:0] start_address=0, rl=15, npc;
wire [9:0] subroutine;
logic [9:0] temp=0;

logic [9:0] mx=0, res=0;
reg_arithmetic rALU(.x(mx), .v(instr_o[2:0]), .*);

logic	branch=0, othr=0, mov=0, incr=0, decr=0, flip=0,
		bizr=0, bnzr=0, jizr=0, jnzr=0,
		lj0=0, lj1=0, lj2=0, lj3=0,
		jump2sub=0, retFsub=0;

logic eql;

subroutine_LUT sLUT(.*);

program_counter pc_reg(.*);

assign eql = (reg_src == reg_dst);

// register operation flags
always_comb begin

	jump2sub=0;
	retFsub	=0;

	mov		=0;
	incr	=0;
	decr	=0;
	flip	=0;

	jizr	=0;
	jnzr	=0;
	bizr	=0;
	bnzr	=0;

	lj0		=0;
	lj1		=0;
	lj2		=0;
	lj3		=0;

	othr	=0;

	case (reg_op)

		j2sr:	jump2sub=1;
		rFsr:	retFsub	=1;

		movEn:	mov		= 1;
		incrEn:	incr	= 1;
		decrEn:	decr	= 1;
		flipEn:	flip	= 1;

		jizrEn: jizr	= 1;
		jnzrEn: jnzr	= 1;
		bizrEn: bizr	= 1;
		bnzrEn: bnzr	= 1;

		ljp0: lj0		= 1;
		ljp1: lj1		= 1;
		ljp2: lj2		= 1;
		ljp3: lj3		= 1;

		default: othr = 1;
	endcase
end

// branch checking
always_comb begin
	branch = 0;
	if (incr||decr||mov||bizr||bnzr||flip) begin
		case (reg_src)
			regr: temp = {2'b0, rr};
			regs: temp = {2'b0, rs};
			regc: temp = {2'b0, rc};
			regd: temp = {2'b0, rd};
			regm: temp = {2'b0, rm};
			regn: temp = {2'b0, rn};
			regx: temp = {2'b0, rx};
			regy: temp = {2'b0, ry};
			rega: temp = {2'b0, ra};
			regb: temp = {2'b0, rb};
			regi: temp = {2'b0, ri};
			regj: temp = {2'b0, rj};
			regk: temp = {2'b0, rk};
			regv: temp = {2'b0, rv};
			regz: temp = {2'b0, rz};
			regl: temp = rl;
			default: temp = 10'b0;
		endcase
		if (eql && mov) temp = 10'b0;
	end else if (jizr||jnzr) begin
		temp = rp; 
	end else begin
		temp = 10'b0;
	end
	mx = temp;
	case (reg_op)
		jizrEn: begin
			if (!instr_o[3] && !rr) branch = 1;
			else if (instr_o[3] && !rs) branch = 1;
			end
		jnzrEn: begin
			if (!instr_o[3] && rr) branch = 1;
			else if (instr_o[3] && rs) branch = 1;
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
	else if (jump2sub) rl <= npc;

	else
	case (reg_op)
		val_lo: rv[3:0] <= instr_o;
		val_hi: rv[7:4] <= instr_o;
		movEn: begin
			case (reg_dst)
				regc: rc <= temp[7:0];
				regd: rd <= temp[7:0];
				regm: rm <= temp[7:0];
				regn: rn <= temp[7:0];
				regx: rx <= temp[7:0];
				regy: ry <= temp[7:0];
				rega: ra <= temp[7:0];
				regb: rb <= temp[7:0];
				regi: ri <= temp[7:0];
				regj: rj <= temp[7:0];
				regk: rk <= temp[7:0];
				regv: rv <= temp[7:0];
				regz: rz <= temp[7:0];
				regl: rl[7:0] <= temp[7:0];
			endcase
			end
		incrEn, decrEn: begin
			case (reg_dst)
				regc: rc <= res[7:0];
				regd: rd <= res[7:0];
				regm: rm <= res[7:0];
				regn: rn <= res[7:0];
				regx: rx <= res[7:0];
				regy: ry <= res[7:0];
				rega: ra <= res[7:0];
				regb: rb <= res[7:0];
				regi: ri <= res[7:0];
				regj: rj <= res[7:0];
				regk: rk <= res[7:0];
				regv: rv <= res[7:0];
				regz: rz <= res[7:0];
				regl: rl <= res;
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
			case (temp[3:0])
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