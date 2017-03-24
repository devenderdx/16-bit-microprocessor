`include "processing_unit.v"
`include "control.v"
`include "memory.v"


module RISC_PROCESSOR(clk,rst);

parameter word_size=16;
parameter sel1_size=4;
parameter sel2_size=2;
wire [sel1_size-1:0] 	sel_bus_1_MUX;
wire [sel2_size-1:0] 	sel_bus_2_MUX;
input clk,rst;

//data nets
wire zero;
wire [word_size-1:0] 	instruction,address,bus_1,mem_word;

//control nets
wire load_R0,load_R1,load_R2,load_R3,load_R4,load_R5,load_R6,load_R7,load_PC,inc_PC,load_IR;
wire Load_add_R,load_reg_Y,load_reg_Z;
wire write;

//instance of processing unit
processing_unit M0 (instruction,zero,address,bus_1,mem_word,load_R0,load_R1,
		    load_R2,load_R3,load_R4,load_R5,load_R6,load_R7,load_PC,
		    inc_PC,sel_bus_1_MUX,load_IR,load_add_R,load_reg_Y,load_reg_Z,sel_bus_2_MUX,clk,rst);

control_unit M1    (load_R0,load_R1,load_R2,load_R3,load_R4,load_R5,load_R6,load_R7,
		    load_PC,inc_PC,
		    sel_bus_1_MUX,sel_bus_2_MUX,
		    load_IR,load_add_R,load_reg_Y,load_reg_Z,
		    write,instruction,zero,clk,rst);

memory_unit M2	   (mem_word,bus_1,address,clk,write);

endmodule
