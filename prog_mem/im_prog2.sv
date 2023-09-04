import instr_pack ::*;
module instr_memory #(size=1024) (
	input unsigned [9:0] pc,
	output [8:0] instr);
int q=0, fi;
logic [8:0] core[size];
assign instr = core[pc];
// program 2
initial begin
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
			core[q] = {jizr, sr, 3'b101}; q++;
			core[q] = {func, noop}; q++;
/*elif*/core[q] = {jizr, ss, 3'b011}; q++;
			core[q] = {valh, 4'b1111}; q++;			// if p=0 && (p1:8!=0) 2 errors
			core[q] = {movk, v}; q++;
			core[q] = {vall, 4'b0011}; q++;
			core[q] = {valh, 4'b0101}; q++;
			core[q] = {func, lj0}; q++;				// skip decoding
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
		
		fi = $fopen("prog2_machine.txt","w");

		for (int i = 0; i < q; i++) begin
			$fdisplay(fi,"%b",core[i]);
		end

		$fclose(fi);
end

endmodule