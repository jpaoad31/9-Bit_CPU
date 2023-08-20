import instr_pack ::*;

module control_logic (
	input [8:0] instr,
	input start,

	output logic mem_sel, alu_rs, done, alu_en,
	output register reg_src, reg_dst,
	output math math_op,
	output reg_OP reg_op,
	output logic [3:0] instr_o);

always_comb begin
	instr_o = instr[3:0];
	mem_sel = 1'bz;
	$cast(reg_src, 4'bz);
	$cast(reg_dst, 4'bz);

	case (instr[8:7])
	2: begin						// data & branch
		case (instr[6:5])
		0: begin
			mem_sel = instr[3];
			if (!instr[4]) begin	// load
				$cast(reg_dst, {1'b0,instr[2:0]});
				reg_op = loadEn;
			end
			else begin				// store
				$cast(reg_src, {1'b0,instr[2:0]});
				reg_op = storEn;
			end
		end
		1: begin
			if (!instr[4]) begin	// increment
				reg_op = incrEn;
				$cast(reg_dst, {instr[3:0]});
			end
			else begin				// decrement
				reg_op = decrEn;
				$cast(reg_dst, {instr[3:0]});
			end
		end
		2: begin
			if (!instr[4])			// jump if zero
				reg_op = jizrEn;
			else					// jump non zero
				reg_op = jnzrEn;
		end
		default: begin
			if(!instr[4]) begin		// branch if zero
				reg_op = bizrEn;
				$cast(reg_src, {instr[3:0]});
			end
			else begin				// branch non zero
				reg_op = bnzrEn;
				$cast(reg_src, {instr[3:0]});
			end
		end
		endcase
	end

	3: begin						// math & logic
		case (instr[6:5])
			
		0: begin					// seth (& unused operation)
			reg_op = sethEn;
		end

		1: begin					// alu math
			alu_rs = instr[4];
			$cast(math_op, instr5[3:0]);
		end

		2: begin
			if (!instr[4])			// lslc
				reg_op = lslcEn;
			else					// lsrc
				reg_op = lslcEn;
		end

		default: begin
			if (!instr[4])			// flip
				reg_op = flipEn;
			else				// func
				reg_op = funcEn;
		end
		endcase
	end

	default:						// move & literals
		if (!instr[6:5]) begin		// load literal
			instr_o = instr[3:0];	// set out register
			if (instr[4])
				reg_op = lit_hi;
			else
				reg_op = lit_lo;
		end

		else begin				// move operation
			reg_op = movEn;
			$cast(reg_dst, instr[7:4]);
			$cast(reg_src, instr[3:0]);
		end
	endcase
end
endmodule