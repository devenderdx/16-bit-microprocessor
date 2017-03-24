// multiplexer unit for alu_out,mem_out and bus_1
module multiplexer_3ch (mux_out,data_a,data_b,data_c,sel);

//parameter declaration
parameter word_size=16;
parameter sel_size=2;

//input and output declaration
input [word_size-1:0] data_a,data_b,data_c;
input [sel_size-1:0] sel;
output [word_size-1:0] mux_out;

assign mux_out=	(sel==0)?data_a:(sel==1)
		?data_b:(sel==2)
		?data_c: 16'bx;
endmodule


