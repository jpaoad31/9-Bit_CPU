import instr_pack ::*;

module top_level(
	input clk, start,
	output done);

// registers
wire [9:0] p;									// program counter
wire [7:0] a, b, x, y, m, r, s;					// specialty registers

wire [8:0] instr;								// current instruction

wire [7:0] storData, loadData;					// data to/from memory

wire	mem_sel, loadEn, storEn,				// control sig (data memory)
		alu_en, alu_rs,							// control sig (alu enable & output sel)
		jump2sub;								// subroutine jump flag
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

register_file_r regFile(.rr(r), .rs(s), .rx(x), .ry(y), .ra(a), .rb(b), .rm(m), .rp(p), .*);

data_memory #(.size(64)) dm1 (.*);

instr_memory #(.size(64)) im (.*);

endmodule