import instr_pack ::*;

module top_level(
	input clk, start,
	output done);

// registers
wire [9:0] p;									// program counter
wire [7:0] a, b, x, y, m, r, s;					// specialty registers

wire [8:0] instr;								// current instruction

wire [7:0] storData, loadData;					// data to/from memory

wire	mem_sel,								// control sig (data memory)
		alu_en, alu_rs;							// control sig (alu enable & output sel)
register reg_src, reg_dst;						// register selection (mov/load/stor)
math math_op;									// math operation (alu)
reg_OP reg_op;
wire [3:0] instr_o;								// intruction operand (other)

logic [7:0] address;

always_comb begin
	if (mem_sel)
		address = b;
	else
		address = a;
end

control_logic ctrlr(.*);

arithmetic_logic alu(.r_out(r), .s_out(s), .*);

register_file regFile(.*);

data_memory #(.size(256)) dm1 (.*);

instr_memory #(.size(1024)) im (.*);

endmodule