//import instr_pack ::*;

package instr_pack;

	typedef enum logic[3:0] {
		regr, regs, regc, regd, regm, regn, regx, regy,
		rega, regb, regi, regj, regk, regv, regz, regl,
		no_reg = 4'bz
	} register;

	typedef enum logic[3:0] {
		AMP, LOR, FLP, EOR, RSC, LSC, ROL, ROR,
		ADD, SUB, EQL8,EQL5,REVx,REVy,PARx,PARy,
		no_mth = 4'bz
	} math;

	typedef enum logic[4:0] {
		j2sr,	rFsr,	non2,	non3,
		val_lo,	val_hi,	movEn,	non7,
		non8,	non9,	incrEn,	decrEn,
		jizrEn,	jnzrEn,	bizrEn,	bnzrEn,
		no16,	sethEn,	no18,	no19,
		lslcEn,	lsrcEn,	flipEn,	funcEn,
		ljp0,	ljp1,	ljp2,	ljp3,
		no_rop = 5'bz
	} reg_OP;


	// Code Pack

	// op codes
	logic [4:0]	vall = 5'b00000,
				valh = 5'b00001,
				movc = 5'b00010,
				movd = 5'b00011,
				movm = 5'b00100,
				movn = 5'b00101,
				movx = 5'b00110,
				movy = 5'b00111,

				mova = 5'b01000,
				movb = 5'b01001,
				movi = 5'b01010,
				movj = 5'b01011,
				movk = 5'b01100,
				movv = 5'b01101,
				movz = 5'b01110,
				movl = 5'b01111,

				load = 5'b10000,
				stor = 5'b10001,
				incr = 5'b10010,
				decr = 5'b10011,
				jizr = 5'b10100,
				jnzr = 5'b10101,
				bizr = 5'b10110,
				bnzr = 5'b10111,

				jtsr = 5'b11000,
				seth = 5'b11001,
				mthr = 5'b11010,
				mths = 5'b11011,
				lslc = 5'b11100,
				lsrc = 5'b11101,
				flip = 5'b11110,
				func = 5'b11111;
	
	// registers
	logic [3:0] r = 4'b0000,
				s = 4'b0001,
				c = 4'b0010,
				d = 4'b0011,
				m = 4'b0100,
				n = 4'b0101,
				x = 4'b0110,
				y = 4'b0111,

				a = 4'b1000,
				b = 4'b1001,
				i = 4'b1010,
				j = 4'b1011,
				k = 4'b1100,
				v = 4'b1101,
				z = 4'b1110,
				l = 4'b1111,

	// math operations
				amp = 4'b0000,
				lor = 4'b0001,
				flp = 4'b0010,
				eor = 4'b0011,
				rsc = 4'b0100,
				lsc = 4'b0101,
				rol = 4'b0110,
				ror = 4'b0111,

				add = 4'b1000,
				sub = 4'b1001,
				eql8= 4'b1010,
				eql5= 4'b1011,
				revx= 4'b1100,
				revy= 4'b1101,
				parx= 4'b1110,
				pary= 4'b1111,

	// functions
				lj0 = 4'b0000,
				lj1 = 4'b0001,
				lj2 = 4'b0010,
				lj3 = 4'b0011,
				noop = 4'b0100,

				srtl = 4'b1100,
				strh = 4'b1101,

				dne = 4'b1111;

	// register selection
	logic		sr = 1'b0,
				ss = 1'b1,
				sm = 1'b0,
				sn = 1'b1,
				sa = 1'b0,
				sb = 1'b1;
endpackage