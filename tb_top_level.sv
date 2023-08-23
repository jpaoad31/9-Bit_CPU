module tb_top_level ();

logic clk=0, start=0;
wire done;

always begin
	#5ns clk=1;
	#5ns clk=0;
end

initial begin
	#130ns $stop;
end

top_level cpu(.*);

endmodule