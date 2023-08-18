import instr_pack ::*;

module tb_control();

logic [8:0] instr;

wire lit, nibble, mov, mem_sel, loadEn, storEn;
wire [3:0] reg_src, reg_dst, instr_o;

control_logic ctrl(.*);

initial begin
	instr = {litl, 4'b1010};
	#1ns
	instr = {lith, 4'b0011};
	#1ns
	instr = {movx, l};
	#1ns $stop;
end

endmodule