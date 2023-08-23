module instr_memory #(size=1024) (
	input unsigned [9:0] p,
	output [8:0] instr
);

logic [8:0] core[size];

assign instr = core[p];

initial begin
	core[0]		= 9'b0_1101_1101;	// movl l
	core[1]		= 9'b00000_1100;	// litl 1100 (12)
	core[2]		= 9'b00001_0011;	// lith 0011 (3)
	core[3]		= 9'b0_0110_1101;	// movx l
	core[4]		= 9'b0_1101_1101;	// movl l
	core[5]		= 9'b00000_0010;	// litl 0010 (2)
	core[6]		= 9'b0_0111_1101;	// movy l
	core[7]		= 9'b11010_0111;	// mthr ror
	core[8]		= 9'b0_0100_0111;	// movm y
	core[9]		= 9'b0_0111_0000;	// movy r
	core[10]	= 9'b11011_0000;	// mths amp
	core[11]	= 9'b111111111;		// done
end

endmodule