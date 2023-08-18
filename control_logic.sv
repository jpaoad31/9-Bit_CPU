import instr_pack ::*;

module control_logic (
	input [8:0] instr,
	input start,

	output logic lit, nibble, mov, mem_sel, loadEn, storEn, alu_rs, incr, decr, done, alu_en,
	output register reg_src, reg_dst,
	output math math_op,
	output logic [2:0] branch,
	output logic [3:0] instr_o);

always_comb begin
	instr_o = 4'bz;
	lit = 0;
	nibble = 1'bz;
	mov = 0;
	mem_sel = 1'bz;
	loadEn = 0;
	storEn = 0;
	$cast(reg_src, 4'bz);
	$cast(reg_dst, 4'bz);

	case (instr[8:7])
	/*
	2: begin					// data & branch
		case (instr[6:5])

		0: begin				// load store
			if (instr[4]) begin
				storEn = 1;
				mem_sel = instr[3];
				$cast(reg_dst, {1'b0, instr[2:0]});
			end
			else begin
				loadEn = 1;
				mem_sel = instr[3];
				$cast(reg_src, {1'b0, instr[2:0]});
			end
		end
		
		1: begin				// conditional branch
			$cast(reg_src, instr[3:0]);
			if(instr[4]) bnzr = 1;
			else bizr = 1;
		end
		2:						// jump by value

		default:
			
			if (instr[4])		// custom functions
				case (instr[3:2])
				0: begin		// memory bank change

				1: begin		// ----
				end
				2: begin		// lut
				end
				endcase


			else				// no operation

		endcase
	end
			
	3: begin					// math stuff
		case (instr[6:5])
			
			0:					// standard opperations

			
			1:					// increment / decrement

			default:
				case (instr[5:4])
				0:
				1:
				2:
				default:

		endcase
	end
	*/
	default:					// move & literals
		if (!instr[6:5]) begin	// load literal
			lit = 1;
			instr_o = instr[3:0];	// set out register
			nibble = instr[4];	// 1: [7:4], 0:[3:0]
		end

		else begin				// move operation
			mov = 1;
			$cast(reg_dst, instr[7:4]);
			$cast(reg_src, instr[3:0]);
		end
	endcase
end
endmodule