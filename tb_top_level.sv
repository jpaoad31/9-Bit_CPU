import code_pack ::*;

module atb_top_level ();

logic clk=1, start=1;
wire done;

always begin
	#5ns clk=0;
	#5ns clk=1;
end

initial begin
	#12ns start = 0;
	#400ns $stop;
end

top_level cpu(.*);

int pc = 0;

initial begin
	cpu.im.core[pc] = {movv, v};
	pc++;
	cpu.im.core[pc] = {litl, 4'b1100};
	pc++;
	cpu.im.core[pc] = {lith, 4'b0011};
	pc++;
	cpu.im.core[pc] = {movx, v};
	pc++;
	cpu.im.core[pc] = {movv, v};
	pc++;
	cpu.im.core[pc] = {litl, 4'b0010};
	pc++;
	cpu.im.core[pc] = {movy, v};
	pc++;
	cpu.im.core[pc] = {mthr, ror};
	pc++;
	cpu.im.core[pc] = {mova, a};
	pc++;
	cpu.im.core[pc] = {stor, sa, r[2:0]};	//9 : mem[0] = 8'b00001111
	pc++;
	cpu.im.core[pc] = {incr, a};
	pc++;
	cpu.im.core[pc] = {movy, r};
	pc++;
	cpu.im.core[pc]	= {mths, amp};
	pc++;
	cpu.im.core[pc]	= {stor, sa, s[2:0]};	//13 : mem[1] = 8'b00001100
	pc++;
	cpu.im.core[pc] = {incr, a};
	pc++;
	cpu.im.core[pc] = {movx, x};
	pc++;
	cpu.im.core[pc] = {mths, amp};
	pc++;
	cpu.im.core[pc] = {movd, d};
	pc++;
	cpu.im.core[pc] = {jizr, ss, 3'b010};	//18 jump pc+4
	pc++;
		cpu.im.core[pc] = {litl, 4'b1111};
		pc++;
		cpu.im.core[pc] = {lith, 4'b1111};
		pc++;
		cpu.im.core[pc] = {movd, v};
		pc++;
	cpu.im.core[pc] = {stor, sa, d[2:0]};	//22 : mem[2] = 8'b00000000
	pc++;
	cpu.im.core[pc] = {incr, a};
	pc++;
	cpu.im.core[pc] = {movb, b};
	pc++;
	cpu.im.core[pc] = {load, sb, x[2:0]};
	pc++;
	cpu.im.core[pc] = {incr, b};
	pc++;
	cpu.im.core[pc] = {load, sb, y[2:0]};
	pc++;
	cpu.im.core[pc] = {mthr, add};
	pc++;
	cpu.im.core[pc] = {stor, sa, r[2:0]};	//29 : mem[3] = 8'b00011011
	pc++;
	cpu.im.core[pc] = {incr, a};
	pc++;
	cpu.im.core[pc] = {lith, 4'b1010};
	pc++;
	cpu.im.core[pc] = {litl, 4'b0000};
	pc++;
	cpu.im.core[pc] = {movm, v};
	pc++;
	cpu.im.core[pc] = {lith, 4'b0000};
	pc++;
	cpu.im.core[pc] = {litl, 4'b1111};
	pc++;
	cpu.im.core[pc] = {movn, v};
	pc++;
	cpu.im.core[pc] = {lslc, sn, 3'b100};
	pc++;
	cpu.im.core[pc] = {stor, sa, n[2:0]};
	pc++;
	cpu.im.core[pc] = {incr, a};							//38 : mem[4] = 8'b11111010 = {n[3:0],m[7:4]}
	pc++;
	cpu.im.core[pc] = {func, dne};
end

endmodule

/* Instructions tested
	litl
	- 
*/