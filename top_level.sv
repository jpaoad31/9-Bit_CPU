import instr_pack ::*;

module top_level(
	input clk, start,
	output done);

// registers
wire [9:0] pc;									// program counter
wire [7:0] ra, rb, rx, ry, rm, rr, rs;			// specialty registers

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
		address = rb;
	else
		address = ra;
end

control_logic ctrlr(.*);

arithmetic_logic alu(.r_out(rr), .s_out(rs), .x(rx), .y(ry), .m(rm), .*);

register_file_r regFile(.rp(pc), .*);

data_memory #(.size(64)) dm1 (.clk, .*);

instr_memory #(.size(64)) im (.*);

endmodule