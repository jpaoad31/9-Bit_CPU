module subroutine_LUT(input [3:0] instr_o, output logic [9:0] subroutine);

always_comb begin
	case (instr_o)
	0 : subroutine = 10'd100;
	1 :	subroutine = 10'd60;
	2 :	subroutine = 10'd70;
	/*
	3 :
	4 :
	5 :
	6 :
	7 :
	8 :
	9 :
	10:
	11:
	12:
	13:
	14:
	15:
	*/
	default: subroutine = 10'b0000000000;
	endcase
end

endmodule