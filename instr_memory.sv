module instr_memory #(size=1024) (
	input unsigned [9:0] pc,
	output [8:0] instr
);

logic [8:0] core[size];

assign instr = core[pc];

endmodule