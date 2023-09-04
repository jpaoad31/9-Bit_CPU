module tb_program_counter();

logic	clk=0, start=0, bizr=0, bnzr=0, jizr=0, jnzr=0, jump2sub=0, retFsub=0,
		branch=0, lj0=0, lj1=0, lj2=0, lj3=0;

logic [7:0] rz = 8'b11110000, rv=8'b00101111;
logic [9:0] start_address=10'b0100000000, subroutine=10'b1000011100, rl=10'b1010100000, res=10'b0011001100, rp_ex=10'b0000000000;

wire [9:0] rp, npc;

wire correct;

assign correct = rp == rp_ex;

program_counter pc(.*);

always begin

// standard increment
#10ns

clk=1;
rp_ex = 10'b0000000001;

#10ns

clk=0;

#10ns

clk=1;
rp_ex = 10'b0000000010;

#10ns

clk=0;

// start address

start = 1;
#10ns

clk=1;
rp_ex = 10'b0100000000;

#10ns

clk=0;

// jizr/jnzr
start = 0;
branch = 1;
jizr = 1;

#10ns

clk=1;
rp_ex = 10'b0011001100;

#10ns

// bizr/bnzr
jizr = 0;
bnzr = 1;
clk=0;

#10ns

clk=1;
rp_ex = 10'b0011110000;

#10ns

// jump to subroutine
branch = 0;
bnzr = 0;
jump2sub=1;
clk=0;

#10ns

clk=1;
rp_ex = 10'b1000011100;

#10ns

// return from subroutine
jump2sub = 0;
retFsub = 1;
clk=0;

#10ns

clk=1;
rp_ex = 10'b1010100000;

#10ns

clk=0;

// long jump 0
retFsub = 0;
lj0 = 1;
#10ns

clk=1;
rp_ex = 10'b0000101111;

#10ns

clk=0;

// long jump 1
lj0 = 0;
lj1 = 1;
#10ns

clk=1;
rp_ex = 10'b0100101111;

#10ns

clk=0;

// long jump 2
lj1 = 0;
lj2 = 1;
#10ns

clk=1;
rp_ex = 10'b1000101111;

#10ns

clk=0;

// long jump 3
lj2 = 0;
lj3 = 1;
#10ns

clk=1;
rp_ex = 10'b1100101111;

#10ns

clk=0;

#10ns $stop;
end

endmodule