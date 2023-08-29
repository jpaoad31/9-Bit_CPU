import instr_pack ::*;
module instr_memory #(size=1024) (
	input unsigned [9:0] pc,
	output [8:0] instr
);
logic [8:0] core[size];
assign instr = core[pc];

initial begin
/*init*/core[pc] = {vall, 4'b1101}; pc++;
		core[pc] = {valh, 4'b0001}; pc++;
		core[pc] = {mova, v}; pc++;					// a= 29
		core[pc] = {vall, 4'b1011}; pc++;
		core[pc] = {valh, 4'b0011}; pc++;
		core[pc] = {movb, v}; pc++;					// b= 59
/*load*/core[pc] = {load, sa, d[2:0]}; pc++;		// {d,c}= data
		core[pc] = {decr, a}; pc++;
		core[pc] = {load, sa, c[2:0]}; pc++;
		core[pc] = {decr, a}; pc++;		
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
/*p4*/	core[pc] = {movm, c}; pc++;
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
		core[pc] = {mthr, ror}; pc++;				// r = {0000,b1,000}
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
		core[pc] = {}; pc++;
	
	
end

endmodule