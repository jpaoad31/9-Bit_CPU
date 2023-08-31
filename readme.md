# John's TMR Architecture CPU

### ModelSim Design Files

These files are required for the processor to run.

- arithmetic_logic.sv
- control_logic.sv
- data_memory.sv
- full_adder.sv
- instr_memory.sv *
- instr_pack.sv
- pc_increment.sv
- program_counter.sv
- reg_arithmetic.sv
- register_file_r.sv
- subroutine_LUT.sv
- top_level.sv

### ModelSim Program TestBench Files

These are testbenches provided by the course instructors to test our processor's ability to complete basic tasks.
A testbench interfaces with the cpu using the `start` and `clk` pins, and can tell when the cpu has completed by
monitoring the `done` pin. This pin will go high for one clock cycle upon program completion. There are a few
no op cycles after the done instruction before the cpu may begin executing code from the subroutines (which are
located after the main program in the instruction rom).

- prog1_tb.sv
- prog2_tb.sv
- prog3_tb.sv

## Running the Test Benches

The testbenches are configured to run the processor in a generic manor (to avoid any suspicion of foul play), so the instruction memory must be configured directly by the user for each of the test benches. This is done by modifying a parameter inside the `instr_memory.sv` file. On line 8, set the value for `run_program=` to:

- `1` to run program 1
- `2` to run program 2
- `3` to run program 3.

*As a backup, there are alternative `instr_memory` modules that can be imported into model sim. These instruction memories are also configured to dump the contents of the instruction rom (in machine code) on execution.

- `im_prog1.sv` for program 1
- `im_prog2.sv` for program 2
- `im_prog3.sv` for program 3