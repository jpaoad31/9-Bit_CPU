module subroutine_LUT(input [3:0] instr_o, output logic [9:0] subroutine);

always_comb begin
	case (instr_o)
	/*
	0 :
	1 :
	2 :
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