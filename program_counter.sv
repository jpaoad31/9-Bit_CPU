module program_counter(
input	clk, start, bizr, bnzr, jizr, jnzr, jump2sub, retFsub,
		branch, lj0, lj1, lj2, lj3,
input [7:0] rz,
input [9:0] start_address, subroutine, rl, res,
output logic [9:0] rp=10'b0000000000,
output wire [9:0] npc
);

pc_increment pcincr(.*);

// program counter update
always_ff @(posedge clk) begin
	if (!start) begin

		if (branch) begin
			if (jizr||jnzr)			rp <= res;
			else if (bizr||bnzr)	rp[7:0] <= rz;
		end

		else if (jump2sub) begin
			rp <= subroutine;
		end

		else if (retFsub) begin
			rp <= rl;
		end

		else if (lj0) begin
				rp <= {2'b00, rz};
		end

		else if (lj1) begin
				rp <= {2'b01, rz};
		end

		else if (lj2) begin
				rp <= {2'b10, rz};
		end

		else if (lj3) begin
				rp <= {2'b11, rz};
		end

		else	rp <= npc;
	end
	else rp = start_address;
end

endmodule