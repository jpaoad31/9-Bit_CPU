import instr_pack ::*;

module control_logic (
	input [8:0] instr,
	input start,

	output logic mem_sel=1'bz, alu_rs=1'bz, done=0, alu_en=0, loadEn=0, storEn=0, noop=0;
	output register reg_src=no_reg, reg_dst=no_reg,
	output math math_op=no_mth,
	output reg_OP reg_op=no_rop,
	output logic [3:0] instr_o);

always_comb begin
	math_op = no_mth;
	reg_op = no_rop;
	instr_o = instr[3:0];
	mem_sel = 1'bz;
	done = 0;
	loadEn = 0;
	storEn = 0;
	alu_rs = 1'bz;
	alu_en = 0;
	reg_src = no_reg;
	reg_dst = no_reg;
	noop = 0;

	case (instr[8:7])
	2: begin						// data & branch
		case (instr[6:5])
		0: begin
			mem_sel = instr[3];
			if (!instr[4]) begin	// load
				$cast(reg_dst, {1'b0,instr[2:0]});
				loadEn = 1;
			end
			else begin				// store
				$cast(reg_src, {1'b0,instr[2:0]});
				storEn = 1;
			end
		end
		1: begin
			if (!instr[4]) begin	// increment
				reg_op = incrEn;
				$cast(reg_dst, {instr[3:0]});
				reg_src = reg_dst;
			end
			else begin				// decrement
				reg_op = decrEn;
				$cast(reg_dst, {instr[3:0]});
				reg_src = reg_dst;
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
			if (!instr[4]) reg_op = j2sr;
			else reg_op = sethEn;
		end

		1: begin					// alu math
			alu_en = 1;
			alu_rs = instr[4];
			$cast(math_op, instr[3:0]);
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
				case (instr[3:0])
				0: reg_op = ljp0;
				1: reg_op = ljp1;
				2: reg_op = ljp2;
				3: reg_op = ljp3;
				4: noop = 1;

				12: reg_op = funcEn;
				13: reg_op = funcEn;
				14: reg_op = rFsr;
				default: done = 1;

				endcase
		end
		endcase
	end

	0,1:						// move & literal values
		if (!instr[8:5]) begin		// load literal values
			instr_o = instr[3:0];	// set out register
			if (instr[4])
				reg_op = val_hi;
			else
				reg_op = val_lo;
		end

		else begin				// move operation
			reg_op = movEn;
			$cast(reg_dst, instr[7:4]);
			$cast(reg_src, instr[3:0]);
		end
	default: reg_op = no_rop;
	endcase
end
endmodule