//alu unit 
module alu_risc (alu_zero_flag,alu_out,data_1,data_2,sel);

//size parameters
parameter word_size = 16;
parameter op_size = 5;

//opcodes paramters
parameter NOP	=5'b00000;
parameter ADD	=5'b00001;
parameter SUB	=5'b00010;
parameter AND	=5'b00011;
parameter NOT	=5'b00100;
parameter OR	=5'b00101;
parameter XOR	=5'b00110;
parameter XNOR	=5'b00111;
parameter NAND	=5'b01000;
parameter NOR	=5'b01001;
parameter RD	=5'b01010;
parameter WR	=5'b01011;
parameter BR	=5'b01100;
parameter BRZ	=5'b01101;

//input and output parameter
input[word_size-1:0] data_1,data_2;
input[op_size-1:0] sel;
output[word_size-1:0] alu_out;
output alu_zero_flag;
reg alu_out;

assign alu_zero_flag = ~|alu_out;

always@(sel or data_1 or data_2)
case (sel)

NOP:	alu_out = 0;
ADD:	alu_out = data_1 + data_2;
SUB:	alu_out = data_1 - data_2;
AND:	alu_out = data_1 & data_2;
NOT:	alu_out = ~ data_2;
OR:	alu_out = data_1 | data_2;
XOR:	alu_out = data_1 ^ data_2;
XNOR:	alu_out = !(data_1 ^ data_2);
NAND:	alu_out = !(data_1 & data_2);
NOR:	alu_out = !(data_1 | data_2);
default alu_out=0;
endcase
endmodule
