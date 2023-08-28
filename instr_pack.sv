//import instr_pack ::*;

package instr_pack;

	typedef enum logic[3:0] {
		regr, regs, regc, regd, regm, regn, regx, regy,
		rega, regb, regi, regj, regk, regv, regz, regl,
		no_reg = 4'bz
	} register;

	typedef enum logic[3:0] {
		amp, lor, flp, eor, rsc, lsc, rol, ror,
		add, sub, eql8,eql5,revx,revy,parx,pary,
		no_mth = 4'bz
	} math;

	typedef enum logic[1:0] {
		strl, strh, ndne, done 
	} functions;

	typedef enum logic[4:0] {
		non0,	non1,	non2,	non3,
		lit_lo,	lit_hi,	movEn,	non7,
		non8,	non9,	incrEn,	decrEn,
		jizrEn,	jnzrEn,	bizrEn,	bnzrEn,
		no16,	sethEn,	no18,	no19,
		lslcEn,	lsrcEn,	flipEn,	funcEn,
		ljp0,	ljp1,	ljp2,	ljp3,
		no_rop = 5'bz
	} reg_OP;
endpackage