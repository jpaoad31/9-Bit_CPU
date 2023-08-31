import instr_pack ::*;
module instr_memory #(size=1024) (
	input unsigned [9:0] pc,
	output [8:0] instr);
int q=0, fi;
logic [8:0] core[size];
assign instr = core[pc];
logic [1:0] run_program=3;	// SELECT PROGRAM HERE
// load program into memory
initial begin
case (run_program)
1: begin
	/*init*/core[q] = {vall, 4'b1110}; q++;
			core[q] = {valh, 4'b0001}; q++;
			core[q] = {mova, v}; q++;					// a= 30 (decr > load)
			core[q] = {vall, 4'b1011}; q++;
			core[q] = {valh, 4'b0011}; q++;
			core[q] = {movb, v}; q++;					// b= 59 (stor > decr)
			core[q] = {vall, 4'b1001}; q++;
			core[q] = {valh, 4'b0000}; q++;
			core[q] = {movz, v}; q++;					// z= 8'b00001001 = 9 (branch target)
	/*load*/core[q] = {decr, a}; q++;
			core[q] = {load, sa, d[2:0]}; q++;			// {d,c}= data
			core[q] = {decr, a}; q++;
			core[q] = {load, sa, c[2:0]}; q++;		
	/*p8*/	core[q] = {movm, c}; q++;
			core[q] = {movn, d}; q++;					// {c,d} => {n,m} bitwise
			core[q] = {lslc, sn, 3'd4}; q++;			// n= {0,b11,b10,b9,b8,b7,b6,b5}
			core[q] = {movm, m}; q++;					// m= 8'b0
			core[q] = {lslc, sn, 3'd1}; q++;			// n= {b11,b10,b9,b8,b7,b6,b5,0}
			core[q] = {movx, n}; q++;
			core[q] = {mthr, parx}; q++;				// r= {0000_000, p8}
			core[q] = {movy, r}; q++;
			core[q] = {mths, lor}; q++;					// s= {b11,b10,b9,b8,b7,b6,b5,p8}
			core[q] = {movd, s}; q++;					// s => d
	/*plce*/core[q] = {movm, c}; q++;
			core[q] = {movn, n}; q++;
			core[q] = {lslc, sm, 3'd4}; q++;			// m= {b4,b3,b2,b1,0000}
			core[q] = {vall, 4'b0000}; q++;
			core[q] = {valh, 4'b0001}; q++;				// v= 8'b0001_0000
			core[q] = {movx, v}; q++;
			core[q] = {movy, m}; q++;					// {0001_0000} & {b4,b3,b2,b1,0000} => r
			core[q] = {mthr, amp}; q++;					// r= {000,b1,0000}
			core[q] = {valh, 4'b1110}; q++;				// v= 1110_0000
			core[q] = {movx, v}; q++;					// {1110_0000} & {b4,b3,b2,b1,0000} => s
			core[q] = {mths, amp}; q++;					// s= {b4, b3, b2, 0_0000}
			core[q] = {vall, 4'b0001}; q++;
			core[q] = {valh, 4'b0000}; q++;
			core[q] = {movx, r}; q++;
			core[q] = {movy, v}; q++;
			core[q] = {mthr, ror}; q++;					// r= {0000,b1,000}
			core[q] = {movx, r}; q++;
			core[q] = {movy, s}; q++;					// {0000,b1,000} & {b4, b3, b2, 0_0000}
			core[q] = {mthr, lor}; q++;					// r= {b4,b3,b2,0,b1,000}
			core[q] = {movc, r}; q++;					// r => c
	/*p4*/	core[q] = {vall, 4'b0000}; q++;
			core[q] = {valh, 4'b1111}; q++;				// mask = 11110000
			core[q] = {jtsr, 4'd0}; q++;				// subroutine 0 r= {0000_000,p4}
			core[q] = {movx, r}; q++;
			core[q] = {vall, 4'b0100}; q++;
			core[q] = {valh, 4'b0000}; q++;
			core[q] = {movy, v}; q++;					// y= 0000_0100
			core[q] = {mthr, ror}; q++;					// r= {000,p4,0000}
			core[q] = {movx, r}; q++;
			core[q] = {movy, c}; q++;					// {000,p4,0000} | {b4, b3, b2, 0, b1, 000}
			core[q] = {mthr, lor}; q++;					// r= {b4,b3,b2,p4,b1,000}
			core[q] = {movc, r}; q++;
	/*p2*/	core[q] = {vall, 4'b1100}; q++;
			core[q] = {valh, 4'b1100}; q++;				// mask = 11001100
			core[q] = {jtsr, 4'd0}; q++;				// subroutine 0 r= {0000_000,p2}
			core[q] = {movx, r}; q++;
			core[q] = {vall, 4'b0110}; q++;
			core[q] = {valh, 4'b0000}; q++;
			core[q] = {movy, v}; q++;					// y= 0000_0110
			core[q] = {mthr, ror}; q++;					// r= {0000_0,p2,00}
			core[q] = {movx, r}; q++;
			core[q] = {movy, c}; q++;					// {0000_0,p2,00} | {b4,b3,b2,p4,b1,000}
			core[q] = {mthr, lor}; q++;					// r= {b4,b3,b2,p4,b1,p2,00}
			core[q] = {movc, r}; q++;
	/*p1*/	core[q] = {vall, 4'b1010}; q++;
			core[q] = {valh, 4'b1010}; q++;				// mask = 10101010
			core[q] = {jtsr, 4'd0}; q++;				// subroutine 0 -> r= {0000_000,p1}
			core[q] = {movx, r}; q++;
			core[q] = {vall, 4'b0111}; q++;
			core[q] = {valh, 4'b0000}; q++;
			core[q] = {movy, v}; q++;					// y= 0000_0111
			core[q] = {mthr, ror}; q++;					// r= {0000_00,p1,0}
			core[q] = {movx, r}; q++;
			core[q] = {movy, c}; q++;					// {0000_00,p1,0} | {b4,b3,b2,p4,b1,p2,00}
			core[q] = {mthr, lor}; q++;					// r= {b4,b3,b2,p4,b1,p2,p1,0}
			core[q] = {movc, r}; q++;
	/*p0*/	core[q] = {vall, 4'b1111}; q++;
			core[q] = {valh, 4'b1111}; q++;				// mask = 11111111
			core[q] = {jtsr, 4'd0}; q++;				// subroutine 0 -> r= {0000_000,p0}
			core[q] = {movx, r}; q++;
			core[q] = {movy, c}; q++;					// {0000_000,p0} | {b4,b3,b2,p4,b1,p2,p1,0}
			core[q] = {mthr, lor}; q++;					// r= {b4,b3,b2,p4,b1,p2,p1,p0}
			core[q] = {movc, r}; q++;
	/*stor*/core[q] = {stor, sb, d[2:0]}; q++;
			core[q] = {decr, b}; q++;
			core[q] = {stor, sb, c[2:0]}; q++;
			core[q] = {decr, b}; q++;
	/*comp*/core[q] = {bnzr, a}; q++;					// if a!=0, go to line 9.
			core[q] = {func, done}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
	/*sub0*/core[q] = {movx, v}; q++;					// subroutine calc parity using mask in v, store in r,
			core[q] = {movy, c}; q++;
			core[q] = {mthr, amp}; q++;					// mask c
			core[q] = {movy, d}; q++;
			core[q] = {mths, amp}; q++;					// mask d
			core[q] = {movx, r}; q++;
			core[q] = {movy, s}; q++;
			core[q] = {mthr, parx}; q++;				// calculate byte parity
			core[q] = {mths, pary}; q++;
			core[q] = {movx, r}; q++;
			core[q] = {movy, s}; q++;
			core[q] = {mthr, eor}; q++;					// calculate total parity
			core[q] = {func, rfsr}; q++;
end
2: begin
	/*init*/core[q] = {vall, 4'b1110}; q++;
			core[q] = {valh, 4'b0001}; q++;
			core[q] = {mova, v}; q++;					// a= 30 (decr > load)
			core[q] = {vall, 4'b1100}; q++;
			core[q] = {valh, 4'b0011}; q++;
			core[q] = {movb, v}; q++;					// b= 60 (decr > stor)
			core[q] = {vall, 4'b1001}; q++;
			core[q] = {valh, 4'b0000}; q++;
			core[q] = {movz, v}; q++;					// z= 8'b00001001 = 9 (branch target)
			core[q] = {decr, b}; q++;
			core[q] = {load, sb, d[2:0]}; q++;
			core[q] = {decr, b}; q++;
			core[q] = {load, sb, c[2:0]}; q++;			// {d,c}= data
			core[q] = {movm, m}; q++;					// m= 00000000 (will hold parity bits)
			core[q] = {movn, n}; q++;					// n= 00000000
	/*p8*/	core[q] = {movx, d}; q++;
			core[q] = {mthr, parx}; q++;
			core[q] = {movn, r}; q++;
			core[q] = {lsrc, sm, 3'b001}; q++;			// m= {p8,000_0000}
	/*p4*/	core[q] = {vall, 4'b0000}; q++;
			core[q] = {valh, 4'b1111}; q++;				// mask = 11110000
			core[q] = {jtsr, 4'd0}; q++;				// r= {0000_000,p4}
			core[q] = {movn, r}; q++;
			core[q] = {lsrc, sm, 3'b001}; q++;			// m= {p4,p8,00_0000}
	/*p2*/	core[q] = {vall, 4'b1100}; q++;
			core[q] = {valh, 4'b1100}; q++;				// mask = 11001100
			core[q] = {jtsr, 4'd0}; q++;				// r= {0000_000,p2}
			core[q] = {movn, r}; q++;
			core[q] = {lsrc, sm, 3'b001}; q++;			// m= {p2,p4,p8,0_0000}
	/*p1*/	core[q] = {vall, 4'b1010}; q++;
			core[q] = {valh, 4'b1010}; q++;				// mask = 10101010
			core[q] = {jtsr, 4'd0}; q++;				// r= {0000_000,p1}
			core[q] = {movn, r}; q++;
			core[q] = {lsrc, sm, 3'b001}; q++;			// m= {p1,p2,p4,p8,0000}
	/*p0*/	core[q] = {vall, 4'b1111}; q++;
			core[q] = {valh, 4'b1111}; q++;				// mask = 11111111
			core[q] = {jtsr, 4'd0}; q++;				// r= {0000_000,p0}
	/*orgz*/core[q] = {movx, m}; q++;
			core[q] = {mths, revx}; q++;				// s= {0000,p8,p4,p2,p1}
			core[q] = {movm, c}; q++;
			core[q] = {movn, d}; q++;					// {n,m}= data
			core[q] = {movx, x}; q++;					// x= 8'b00000000 (jump condition)
			core[q] = {vall, 4'b0000}; q++;				// v= 8'b????0000
	/*ifp0*/core[q] = {jizr, sr, 3'b011}; q++;
				core[q] = {valh, 4'b0100}; q++;			// if p=1, 1 error
				core[q] = {flip, s}; q++;				// correct {n,m} by r[3:0]
				core[q] = {mthr, revx}; q++;
				core[q] = {jizr, sr, 3'b100}; q++;
				core[q] = {func, noop}; q++;
	/*elif*/core[q] = {jizr, ss, 3'b010}; q++;
				core[q] = {valh, 4'b1100}; q++;			// if p=0 && (p1:8!=0) 2 errors
				core[q] = {mthr, revx}; q++;
				core[q] = {jizr, sr, 3'b001}; q++;
	/*othr*/core[q] = {valh, 4'b0000}; q++;				// if p=0 && p1:8=0
			core[q] = {movk, v}; q++;
			core[q] = {movk, v}; q++;					// k= {F1,F0,00_0000}
			core[q] = {movc, m}; q++;
			core[q] = {movd, n}; q++;					// {d,c} = corrected data
	/*deco*/core[q] = {vall, 4'b1000}; q++;
			core[q] = {valh, 4'b1110}; q++;
			core[q] = {movx, v}; q++;
			core[q] = {movy, c}; q++;					// {1110_1000} & {b4, b3, b2, p4, b1, p2, p1, p0}
			core[q] = {mthr, amp}; q++;					// r= {b4,b3 b2,0,b1,000}
			core[q] = {movm, r}; q++;					// r => m
			core[q] = {movn, n}; q++;
			core[q] = {lsrc, sm, 3'b011}; q++;			// m= {000,b4,b3,b2,0,b1}
			core[q] = {lsrc, sn, 3'b001}; q++;			// n= {b1,000_0000}
			core[q] = {lsrc, sm, 3'b010}; q++;			// m= {00000,b4,b3,b2}
			core[q] = {lslc, sm, 3'b101}; q++;			// m= {b4,b3,b2,b1,0000}
			core[q] = {movx, d}; q++;
			core[q] = {vall, 4'b0001}; q++;
			core[q] = {valh, 4'b0000}; q++;
			core[q] = {movy, v}; q++;					// {b11,b10,b9,b8,b7,b6,b5,p8} ror {00000001}
			core[q] = {mthr, ror}; q++;					// r= {p8,b11,b10,b9,b8,b7,b6,b5}
			core[q] = {movn, r}; q++;					// r => n
			core[q] = {lsrc, sm, 3'b100}; q++;			// m= {b8,b7,b6,b5,b4,b3,b2,b1}
			core[q] = {movc, m}; q++;					// m => c
			core[q] = {movm, m}; q++;					// m= 00000000
			core[q] = {lslc, sn, 3'b001}; q++;			// n = {b11,b10,b9,b8,b7,b6,b5,0}
			core[q] = {lsrc, sn, 3'b101}; q++;			// n = {0000_0,b11,b10,b9}
			core[q] = {movx, n}; q++;
			core[q] = {movy, k}; q++;
			core[q] = {mthr, lor}; q++;					// r= {F1,F0,00_0,b11,b10,b9}
			core[q] = {movd, r}; q++;					// r => d
	/*stor*/core[q] = {decr, a}; q++;
			core[q] = {stor, sa, d[2:0]}; q++;
			core[q] = {decr, a}; q++;
			core[q] = {stor, sa, c[2:0]}; q++;
	/*comp*/core[q] = {bnzr, a}; q++;
			core[q] = {func, done}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
	/*sub0*/core[q] = {movx, v}; q++;					//subroutine: calculate parity using bitmask in v, store parity in r 
			core[q] = {movy, c}; q++;
			core[q] = {mthr, amp}; q++;					// mask c
			core[q] = {movy, d}; q++;
			core[q] = {mths, amp}; q++;					// mask d
			core[q] = {movx, r}; q++;
			core[q] = {movy, s}; q++;
			core[q] = {mthr, parx}; q++;				// calculate byte parity
			core[q] = {mths, pary}; q++;
			core[q] = {movx, r}; q++;
			core[q] = {movy, s}; q++;
			core[q] = {mthr, eor}; q++;					// r= parity {d,c}-mask
			core[q] = {func, rfsr}; q++;
end
3: begin
	/*init*/core[q] = {vall, 4'b1111}; q++;
			core[q] = {valh, 4'b0000}; q++;
			core[q] = {movz, v}; q++;				// branch target 15
			core[q] = {vall, 4'b0000}; q++;
			core[q] = {valh, 4'b0010}; q++;
			core[q] = {movc, c}; q++;				// c: occurences in byte
			core[q] = {movd, d}; q++;				// d: occurences across byte
			core[q] = {movk, k}; q++;				// k: bytes containing occurence
			core[q] = {movb, v}; q++;				// b= 32 (count down)
			core[q] = {mova, a}; q++;				// a= 0 (count up)
			core[q] = {load, sb, x[2:0]}; q++;		// x= pattern
			core[q] = {load, sa, m[2:0]}; q++;		// m= bit sequence 01234567
			core[q] = {incr, a}; q++;
			core[q] = {decr, b}; q++;
			core[q] = {func, noop}; q++;
	/*load*/core[q] = {movj, j}; q++;				// j: occurred in byte
			core[q] = {load, sa, n[2:0]}; q++;		// n= bit sequence 89abcdef
			core[q] = {incr, a}; q++;
			core[q] = {decr, b}; q++;
	/*cmp*/	core[q] = {jtsr, 4'd1}; q++;
			core[q] = {jtsr, 4'd1}; q++;
			core[q] = {jtsr, 4'd1}; q++;
			core[q] = {jtsr, 4'd1}; q++;
			core[q] = {jtsr, 4'd2}; q++;
			core[q] = {jtsr, 4'd2}; q++;
			core[q] = {jtsr, 4'd2}; q++;
			core[q] = {jtsr, 4'd2}; q++;
			core[q] = {movy, j}; q++;
			core[q] = {mths, revy}; q++;			// y = j[0:7]
			core[q] = {jizr, ss, 3'b001}; q++;
				core[q] = {incr, k}; q++;
	/*comp*/core[q] = {bnzr, b}; q++;
	/*last*/core[q] = {movj, j}; q++;
			core[q] = {movn, n}; q++;
			core[q] = {jtsr, 4'd1}; q++;
			core[q] = {jtsr, 4'd1}; q++;
			core[q] = {jtsr, 4'd1}; q++;
			core[q] = {jtsr, 4'd1}; q++;
			core[q] = {movy, j}; q++;
			core[q] = {mths, revy}; q++;			// y = j[0:7]
			core[q] = {jizr, ss, 3'b001}; q++;
				core[q] = {incr, k}; q++;
	/*stor*/core[q] = {incr, v}; q++;				// v= 33
			core[q] = {movb, v}; q++;				// v => b
			core[q] = {stor, sb, c[2:0]}; q++;		// mem[33] <= c
			core[q] = {incr, b}; q++;
			core[q] = {movm, k}; q++;
			core[q] = {stor, sb, m[2:0]}; q++;		// mem[34] <= m <= k
			core[q] = {incr, b}; q++;
			core[q] = {movx, c}; q++;
			core[q] = {movy, d}; q++;
			core[q] = {mthr, add}; q++;				// r= c + d
			core[q] = {stor, sb, r[2:0]}; q++;			// mem[35] <= c + d
			core[q] = {func, done}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
	/*sub1*/core[q] = {mthr, eql5}; q++;		// check for in-byte occurrence
			core[q] = {jizr, sr, 3'b010}; q++;
				core[q] = {incr, c}; q++;
				core[q] = {incr, j}; q++;
				core[q] = {func, noop}; q++;
			core[q] = {lslc, sm, 3'b001}; q++;
			core[q] = {lslc, sn, 3'b001}; q++;	// shift in next bit
			core[q] = {func, rfsr}; q++;
			core[q] = {func, noop}; q++;
			core[q] = {func, noop}; q++;
	/*sub2*/core[q] = {mthr, eql5}; q++;		// check for across-byte occurrence
			core[q] = {jizr, sr, 3'b001}; q++;
				core[q] = {incr, d}; q++;
			core[q] = {lslc, sm, 3'b001}; q++;
			core[q] = {lslc, sn, 3'b001}; q++;	// shift in next bit
			core[q] = {func, rfsr}; q++;
end
endcase
end
endmodule