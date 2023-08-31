import instr_pack ::*;
module instr_memory #(size=1024) (
	input unsigned [9:0] pc,
	output [8:0] instr);
int q=0, fi;
logic [8:0] core[size];
assign instr = core[pc];
// program 1
initial begin
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
/*sub0*/core[q] = {movx, v}; q++;					// 100 subroutine calculate parity using bitmask in v, store parity in r, s not preserved
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

		fi = $fopen("p1mc.txt","w");

		for (int i = 0; i <= q; i++) begin
			$fdisplay(fi,"%b",core[i]);
		end

		$fclose(fi);
end

endmodule