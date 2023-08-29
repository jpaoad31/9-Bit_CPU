import instr_pack ::*;
module instr_memory #(size=1024) (
	input unsigned [9:0] pc,
	output [8:0] instr
);
logic [8:0] core[size];
assign instr = core[pc];

initial begin
/*init*/core[pc] = {vall, 4'b1110}; pc++;
		core[pc] = {valh, 4'b0001}; pc++;
		core[pc] = {mova, v}; pc++;					// a= 30 (decr > load)
		core[pc] = {vall, 4'b1011}; pc++;
		core[pc] = {valh, 4'b0011}; pc++;
		core[pc] = {movb, v}; pc++;					// b= 59 (stor > decr)
		core[pc] = {vall, 4'b1001}; pc++;
		core[pc] = {valh, 4'b0000}; pc++;
		core[pc] = {movz, v}; pc++;					// z= 8'b00001001 = 9 (branch target)
/*load*/core[pc] = {decr, a}; pc++;
		core[pc] = {load, sa, d[2:0]}; pc++;		// {d,c}= data
		core[pc] = {decr, a}; pc++;
		core[pc] = {load, sa, c[2:0]}; pc++;		
/*p8*/	core[pc] = {movm, c}; pc++;
		core[pc] = {movn, d}; pc++;					// {c,d} => {n,m} bitwise
		core[pc] = {lslc, sn, 3'd4}; pc++;			// n= {0,b11,b10,b9,b8,b7,b6,b5}
		core[pc] = {movm, m}; pc++;					// m= 8'b0
		core[pc] = {lslc, 3'd1}; pc++;				// n= {b11,b10,b9,b8,b7,b6,b5,0}
		core[pc] = {movx, m}; pc++;
		core[pc] = {mthr, parx}; pc++;				// r= {0000_000, p8}
		core[pc] = {movy, r}; pc++;
		core[pc] = {mths, lor}; pc++;				// s= {b11,b10,b9,b8,b7,b6,b5,p8}
		core[pc] = {movd, s}; pc++;					// s => d
/*plce*/core[pc] = {movm, c}; pc++;
		core[pc] = {movn, n}; pc++;
		core[pc] = {lslc, sm, 3'd4}; pc++;			// m= {b4,b3,b2,b1,0000}
		core[pc] = {vall, 4'b0000}; pc++;
		core[pc] = {valh, 4'b0001}; pc++;			// v= 8'b0001_0000
		core[pc] = {movx, v}; pc++;
		core[pc] = {movy, m}; pc++;					// {0001_0000} & {b4,b3,b2,b1,0000} => r
		core[pc] = {mthr, amp}; pc++;				// r= {000,b1,0000}
		core[pc] = {valh, 4'b1110}; pc++;			// v= 1110_0000
		core[pc] = {movx, v}; pc++;					// {1110_0000} & {b4,b3,b2,b1,0000} => s
		core[pc] = {mths, amp}; pc++;				// s= {b4, b3, b2, 0_0000}
		core[pc] = {vall, 4'b0001}; pc++;
		core[pc] = {valh, 4'b0000}; pc++;
		core[pc] = {movx, r}; pc++;
		core[pc] = {movy, v}; pc++;
		core[pc] = {mthr, ror}; pc++;				// r= {0000,b1,000}
		core[pc] = {movx, r}; pc++;
		core[pc] = {movy, s}; pc++;					// {0000,b1,000} & {b4, b3, b2, 0_0000}
		core[pc] = {mthr, lor}; pc++;				// r= {b4,b3,b2,0,b1,000}
		core[pc] = {movc, r}; pc++;					// r => c
/*p4*/	core[pc] = {vall, 4'b0000}; pc++;
		core[pc] = {valh, 4'b1111}; pc++;			// mask = 11110000
		core[pc] = {jtsr, 4'd0}; pc++;				// subroutine 0 r= {0000_000,p4}
		core[pc] = {movx, r}; pc++;
		core[pc] = {vall, 4'b0100}; pc++;
		core[pc] = {valh, 4'b0000}; pc++;
		core[pc] = {movy, v}; pc++;					// y= 0000_0100
		core[pc] = {mthr, ror}; pc++;				// r= {000,p4,0000}
		core[pc] = {movx, r}; pc++;
		core[pc] = {movy, c}; pc++;					// {000,p4,0000} | {b4, b3, b2, 0, b1, 000}
		core[pc] = {mthr, lor}; pc++;				// r= {b4,b3,b2,p4,b1,000}
		core[pc] = {movc, r}; pc++;
/*p2*/	core[pc] = {vall, 4'b1100}; pc++;
		core[pc] = {valh, 4'b1100}; pc++;			// mask = 11001100
		core[pc] = {jtsr, 4'd0}; pc++;				// subroutine 0 r= {0000_000,p2}
		core[pc] = {movx, r}; pc++;
		core[pc] = {vall, 4'b0110}; pc++;
		core[pc] = {valh, 4'b0000}; pc++;
		core[pc] = {movy, v}; pc++;					// y= 0000_0110
		core[pc] = {mthr, ror}; pc++;				// r= {0000_0,p2,00}
		core[pc] = {movx, r}; pc++;
		core[pc] = {movy, c}; pc++;					// {0000_0,p2,00} | {b4,b3,b2,p4,b1,000}
		core[pc] = {mthr, lor}; pc++;				// r= {b4,b3,b2,p4,b1,p2,00}
		core[pc] = {movc, r}; pc++;
/*p1*/	core[pc] = {vall, 4'b1010}; pc++;
		core[pc] = {valh, 4'b1010}; pc++;			// mask = 10101010
		core[pc] = {jtsr, 4'd0}; pc++;				// subroutine 0 -> r= {0000_000,p1}
		core[pc] = {movx, r}; pc++;
		core[pc] = {vall, 4'b0111}; pc++;
		core[pc] = {valh, 4'b0000}; pc++;
		core[pc] = {movy, v}; pc++;					// y= 0000_0111
		core[pc] = {mthr, ror}; pc++;				// r= {0000_00,p1,0}
		core[pc] = {movx, r}; pc++;
		core[pc] = {movy, c}; pc++;					// {0000_00,p1,0} | {b4,b3,b2,p4,b1,p2,00}
		core[pc] = {mthr, lor}; pc++;				// r= {b4,b3,b2,p4,b1,p2,p1,0}
		core[pc] = {movc, r}; pc++;
/*p0*/	core[pc] = {vall, 4'b1111}; pc++;
		core[pc] = {valh, 4'b1111}; pc++;			// mask = 11111111
		core[pc] = {jtsr, 4'd0}; pc++;				// subroutine 0 -> r= {0000_000,p0}
		core[pc] = {movx, r}; pc++;
		core[pc] = {movy, c}; pc++;					// {0000_000,p0} | {b4,b3,b2,p4,b1,p2,p1,0}
		core[pc] = {mthr, lor}; pc++;				// r= {b4,b3,b2,p4,b1,p2,p1,p0}
		core[pc] = {movc, r}; pc++;
/*stor*/core[pc] = {stor, sb, d[2:0]}; pc++;
		core[pc] = {decr, b}; pc++;
		core[pc] = {stor, sb, d[2:0]}; pc++;
		core[pc] = {decr, b}; pc++;
/*comp*/core[pc] = {bnzr, a}; pc++;					// if a!=0, go to line 9.
		core[pc] = {func, done}; pc++;
		core[pc] = {func, noop}; pc++;
		core[pc] = {func, noop}; pc++;
		core[pc] = {func, noop}; pc++;
		core[pc] = {func, noop}; pc++;
		core[pc] = {func, noop}; pc++;
		core[pc] = {func, noop}; pc++;
		core[pc] = {func, noop}; pc++;
		core[pc] = {func, noop}; pc++;
/*sub0*/core[pc] = {movx, v}; pc++;					// 100 subroutine calculate parity using bitmask in v, store parity in r, s not preserved
		core[pc] = {movy, c}; pc++;
		core[pc] = {mthr, amp}; pc++;				// mask c
		core[pc] = {movy, d}; pc++;
		core[pc] = {mths, amp}; pc++;				// mask d
		core[pc] = {movx, r}; pc++;
		core[pc] = {movy, s}; pc++;
		core[pc] = {mthr, parx}; pc++;				// calculate byte parity
		core[pc] = {mths, pary}; pc++;
		core[pc] = {movx, r}; pc++;
		core[pc] = {movy, s}; pc++;
		core[pc] = {mthr, eor}; pc++;				// calculate total parity
		core[pc] = {func, rfsr}; pc++;
end

endmodule