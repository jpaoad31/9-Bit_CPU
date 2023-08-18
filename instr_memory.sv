module instr_memory #(size=1024) (
	input [9:0] p,
	output [8:0] instr
);

logic [8:0] core[size];

assign instr = core[p];

endmodule