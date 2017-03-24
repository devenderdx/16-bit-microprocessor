// multiplexer unit for register and program counter
module multiplexer_9ch (mux_out,data_a,data_b,data_c,data_d,data_e,data_f,data_g,data_h,data_i,sel);

//parameter declaration
parameter word_size=16;
parameter sel_size=4;

//input and output declaration
input [word_size-1:0] data_a,data_b,data_c,data_d,data_e,data_f,data_g,data_h,data_i;
input [sel_size-1:0] sel;
output [word_size-1:0] mux_out;

assign mux_out=	(sel==0)?data_a:(sel==1)
		?data_b:(sel==2)
		?data_c:(sel==3)
		?data_d:(sel==4)
		?data_e:(sel==5)
		?data_f:(sel==6)
		?data_g:(sel==7)
		?data_h:(sel==8)
		?data_i: 16'bx;
endmodule


