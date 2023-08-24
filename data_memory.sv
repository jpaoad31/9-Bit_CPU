module data_memory #(size=256) (
	input clk, loadEn, storEn,
	input unsigned [7:0] address,
	input [7:0] storData,
	output logic [7:0] loadData);

	logic [7:0] core[size];

	always_comb
		if (loadEn) loadData = core[address];
		else loadData = 8'bz; 

	always_ff @(negedge clk) begin
		if (storEn)
			core[address] <= storData;
	end

endmodule