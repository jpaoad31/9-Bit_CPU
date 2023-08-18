module tb_arithmetic();

logic	add=0, sub=0, amp=0, lor=0, flp=0, eor=0, lsx=0, lsy=0,
		prc0=0, prc1=0, prc2=0, prc4=0, prc8=0, prgl=0, prgh=0, eql=0;

logic [7:0] x, y, m, e_res;
wire  [7:0] res;

arithmetic_logic alu(.*);

always begin
	// test add & sub
	#10ns
	x=8'b00000001;
	y=8'b00000001;
	add=1;
	e_res = 8'b00000010;

	#10ns
	x=8'd13;
	y=8'd12;
	e_res = 8'd25;

	#10ns
	x=8'd165;
	y=8'b11111111;
	e_res = 8'd164;

	#10ns
	add=0;
	sub=1;
	x=8'd77;
	y=8'd27;
	e_res=8'd50;

	#10ns
	sub=0;
	amp=1;
	x=8'b11111100;
	y=8'b00111111;
	e_res = 8'b00111100;

	#10ns
	$stop;
end


endmodule