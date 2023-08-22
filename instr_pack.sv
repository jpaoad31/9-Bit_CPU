//import instr_pack ::*;

package instr_pack;

	typedef enum logic[4:0] {
		litl, lith, movc, movd, movm, movn, movx, movy,
		mova, movb, movi, movj, movk, movl, movz, movp,
		load, stor, incr, decr, jizr, jnzr, bizr, bnzr,
		zzzz, seth, mthr, mths, lslc, lsrc, flip, func
	} OP;

	typedef enum logic[3:0] {
		r, s, c, d, m, n, x, y,
		a, b, i, j, k, l, z, p
	} register;

	typedef enum logic[3:0] {
		amp, lor, flp, eor, rsc, lsc, rol, ror,
		add, sub, eql8,eql5,revx,revy,parx,pary
	} math;

	typedef enum logic[1:0] {
		strl, strh, ndne, done 
	} functions;

	typedef enum logic[4:0] {
		non0,	non1,	non2,	non3,
		lit_lo,	lit_hi,	movEn,	non7,
		loadEn,	storEn,	incrEn,	decrEn,
		jizrEn,	jnzrEn,	bizrEn,	bnzrEn,
		no16,	sethEn,	no18,	no19,
		lslcEn,	lsrcEn,	flipEn,	funcEn,
		ljp0,	ljp1,	ljp2,	ljp3
	} reg_OP;
endpackage