module full_adder (
	input x, y, ci, en,
	output logic s, co);

	always_comb begin
		if (en) begin 
			s = (x^^y)^^ci;
			co = x&y|(ci&(x|y));
		end
		else begin
			s = 1'b0;
			co = 1'b0;
		end
	end

endmodule