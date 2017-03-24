module instruction_register(data_out,data_in,load,clk,rst);
parameter word_size=16;
output [word_size-1:0] data_out;
input [word_size-1:0] data_in;
input load,clk,rst;
reg data_out;

always@(posedge clk or negedge rst)
if(rst==0)
data_out <= 0;
else if(load)
data_out <= data_in;
endmodule

