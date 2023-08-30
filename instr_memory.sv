import instr_pack ::*;
module instr_memory #(size=1024) (
	input unsigned [9:0] pc,
	output [8:0] instr);
int q=0, fi;
logic [8:0] core[size];
assign instr = core[pc];
// program 1
initial begin

		fi = $fopen("p1mc.txt","w");

		for (int i = 0; i <= q; i++) begin
			$fdisplay(fi,"%b",core[i]);
		end

		$fclose(fi);
end

endmodule