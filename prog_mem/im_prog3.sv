import instr_pack ::*;
module instr_memory #(size=1024) (
	input unsigned [9:0] pc,
	output [8:0] instr);
int q=0, fi;
logic [8:0] core[size];
assign instr = core[pc];
// program 3
initial begin
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

		fi = $fopen("prog3_machine.txt","w");

		for (int i = 0; i < q; i++) begin
			$fdisplay(fi,"%b",core[i]);
		end

		$fclose(fi);
end

endmodule