// memory unit of 255 address and 16 bit size
module memory_unit (data_out,data_in,address,clk,write);

//parameter decleration
parameter word_size=16;
parameter memory_size=256;

//input and output decleration
input [word_size-1:0] data_in;
input [word_size-1:0] address;
input	clk,write;
output [word_size-1:0] data_out;

//memory decleration
reg [word_size-1:0] memory [memory_size-1:0];

assign data_out = memory[address];

always@(posedge clk)
if(write==1)
memory[address] <= data_in;

endmodule
