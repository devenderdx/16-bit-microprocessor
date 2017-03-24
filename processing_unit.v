`include "address_reg.v"
`include "alu_risc.v"
`include "D_flop.v"
`include "instruction_register.v"
`include "mux_3.v"
`include "mux_9.v"
`include "program_counter.v"
`include "register_unit.v"
//`include "control.v"

//this is the processing unit which creates the datapath
module processing_unit (instruction,Zflag,address,bus_1,mem_word,load_R0,load_R1,
			load_R2,load_R3,load_R4,load_R5,load_R6,load_R7,load_PC,
			inc_PC,sel_bus_1_MUX,load_IR,load_add_R,load_reg_Y,load_reg_Z,sel_bus_2_MUX,clk,rst);
//parameter decleraion
parameter word_size=16;
parameter op_size=5;
parameter sel1_size=4;
parameter sel2_size=2;

//input and output decleration
input [word_size-1:0] 	mem_word;
input [sel1_size-1:0] 	sel_bus_1_MUX;
input [sel2_size-1:0] 	sel_bus_2_MUX;
input 	load_R0,load_R1,load_R2,load_R3,load_R4,load_R5,load_R6,load_R7,load_PC,inc_PC;
input	load_IR,load_add_R,load_reg_Y,load_reg_Z;
input 	clk,rst;

output [word_size-1:0] instruction,address,bus_1;
output	Zflag;

//wires decleration
wire [word_size-1:0]	bus_2;
wire [word_size-1:0]	R0_out,R1_out,R2_out,R3_out,R4_out,R5_out,R6_out,R7_out;
wire [word_size-1:0]	PC_count,Y_value,alu_out;
wire [op_size-1:0]	opcode=instruction[word_size-1:word_size-op_size];
wire	load_R0,load_R1,load_R2,load_R3,load_R4,load_R5,load_R6,load_R7;
wire	alu_zero_flag;

//instance for registers from R0 to R7
register_unit R0 (R0_out,bus_2,load_R0,clk,rst);
register_unit R1 (R1_out,bus_2,load_R1,clk,rst);
register_unit R2 (R2_out,bus_2,load_R2,clk,rst);
register_unit R3 (R3_out,bus_2,load_R3,clk,rst);
register_unit R4 (R4_out,bus_2,load_R4,clk,rst);
register_unit R5 (R5_out,bus_2,load_R5,clk,rst);
register_unit R6 (R6_out,bus_2,load_R6,clk,rst);
register_unit R7 (R7_out,bus_2,load_R7,clk,rst);

//instance for register Y near alu
register_unit Reg_Y (Y_value,bus_2,load_reg_Y,clk,rst);

//instance for zero register using d-flip flop
D_flop Reg_Z (Zflag,alu_zero_flag,load_reg_Z,clk,rst);

//instance for address register
address_register Add_R (address,bus_2,load_add_R,clk,rst);

//instance for instruction register
instruction_register IR (instruction,bus_2,load_IR,clk,rst);

//instance for program counter
program_counter PC (PC_count,bus_2,load_PC,inc_PC,clk,rst);

//instance for multiplexer unit
multiplexer_9ch MUX_1 (bus_1,R0_out,R1_out,R2_out,R3_out,R4_out,R5_out,R6_out,R7_out,PC_count,sel_bus_1_MUX);
multiplexer_3ch MUX_2 (bus_2,alu_out,bus_1,mem_word,sel_bus_2_MUX);

//instance of alu unit
alu_risc ALU (alu_zero_flag,alu_out,Y_value,bus_1,opcode);

endmodule








