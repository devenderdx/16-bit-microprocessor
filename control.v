//control unit for 16 bit microprocessor
module control_unit (	load_R0,load_R1,load_R2,load_R3,load_R4,load_R5,load_R6,load_R7,
			load_PC,inc_PC,
			sel_bus_1_MUX,sel_bus_2_MUX,
			load_IR,load_add_R,load_reg_Y,load_reg_Z,
			write,instruction,zero,clk,rst);
//parameters are declaration is started :-
	// parameters for size are declared
	parameter word_size=16,op_size=5,state_size=4;
	parameter src_size=3,dest_size=3,sel1_size=4,sel2_size=2;
	
	//parameter for state_codes
	parameter s_idle=0,s_fet1=1,s_fet2=2,s_dec=3,s_ex1=4,s_rd1=5;
	parameter s_rd2=6,s_wr1=7,s_wr2=8,s_br1=9,s_br2=10,s_halt=11;
	
	//opcodes
	parameter NOP=0,ADD=1,SUB=2,AND=3,NOT=4,OR=5,XOR=6;
	parameter XNOR=7,NAND=8,NOR=9,RD=10,WR=11,BR=12,BRZ=13;
	
	//source and destination registers
	parameter R0=0,R1=1,R2=2,R3=3;
	parameter R4=4,R5=5,R6=6,R7=7;
//parameter declation is over

//outputs and inputs declaration :-
	output load_R0,load_R1,load_R2,load_R3,load_R4,load_R5,load_R6,load_R7;
	output load_PC,inc_PC;
	output [sel1_size-1:0] sel_bus_1_MUX;
	output [sel2_size-1:0] sel_bus_2_MUX;
	output load_IR,load_add_R;
	output load_reg_Y,load_reg_Z;
	output write;
	
	input [word_size-1:0] instruction;
	input zero;
	input clk,rst;
//output and inpu declaration is over

//reg and wire declaration :-
	reg [state_size-1:0] state,next_state;
	reg load_R0,load_R1,load_R2,load_R3,load_R4,load_R5,load_R6,load_R7;
	reg load_PC,inc_PC;
	reg load_IR,load_add_R;
	reg load_reg_Y,load_reg_Z;
	reg sel_alu,sel_bus_1,sel_mem;
	reg sel_R0,sel_R1,sel_R2,sel_R3;
	reg sel_R4,sel_R5,sel_R6,sel_R7;
	reg sel_PC,write,err_flag;

	wire [op_size-1:0] opcode=instruction[word_size-1:word_size-op_size];
	wire [src_size-1:0] src=instrucion[src_size+dest_size:dest_size+1];
	wire [dest_size-1:0] dest=instruction[dest_size-1:0];
//reg and wire declaration is over

//mux_selectors :-
assign sel_bus_1_MUX[sel1_size-1:0]=	sel_R0 ? 0:
					sel_R1 ? 1:
					sel_R2 ? 2:
					sel_R3 ? 3:
					sel_R4 ? 4:
					sel_R5 ? 5:
					sel_R6 ? 6:
					sel_R7 ? 7:
					sel_PC ? 8: 4'bx;

assign sel_bus_2_MUX[sel2_size-1:0]= 	sel_alu ? 0:
					sel_bus_1 ? 1:
					sel_mem ? 2: 2'bx;
//mux_Selectors are over here

//state assignment is done below:-
always@(posedge clk or negedge rst)
begin : state_transtions
	if(rst==0) state <= s_idle;
	else state <= next_state;
end			
//state transition is over

//state machine is started here:--*******************************
always@(state or opcode or src or dest or zero)
begin 
	sel_R0=0;
	sel_R1=0;
	sel_R2=0;
	sel_R3=0;
	sel_R4=0;
	sel_R5=0;
	sel_R6=0;
	sel_R7=0;
	sel_PC=0;
	sel_bus_1=0;
	sel_alu=0;
	sel_mem=0;
load_R0=0;
load_R1=0;
load_R2=0;
load_R3=0;
load_R4=0;
load_R5=0;
load_R6=0;
load_R7=0;
load_PC=0;
inc_PC=0;
load_IR=0;
load_add_R=0;
load_reg_Y=0;
load_reg_Z=0;
	write=0;
	err_flag=0;
	next_state=state;
//case is started here 

case(state)
	s_idle : next_state=s_fet1;
	s_fet1 : begin 
			next_state=s_fet2;
			sel_PC=1;
			sel_bus_1=1;
			load_add_R=1;
		 end
	s_fet2 : begin
			next_state=s_dec;
			sel_mem=1;
			load_IR=1;
			inc_PC=1;
		 end	
	s_dec : 
		case(opcode) // opcode state machine is starting here
			NOP : next_state = s_fet1;

			ADD,SUB,AND,OR,XOR,XNOR,NAND,NOR :
				begin
				next_state = s_ex1;
				sel_bus_1 = 1;
				load_reg_Y = 1;
				case(src)
				R0 : sel_R0=1;
				R1 : sel_R1=1;
				R2 : sel_R2=1;
				R3 : sel_R3=1;
				R4 : sel_R4=1;
				R5 : sel_R5=1;
				R6 : sel_R6=1;
				R7 : sel_R7=1;
				default err_flag=1;
				endcase	
				end // add,sub,and,or.....
			
			NOT : begin
				next_state=s_fet1;
				load_reg_Z=1;
				sel_alu=1;
				case(src)
				R0 : sel_R0=1;
				R1 : sel_R1=1;
				R2 : sel_R2=1;
				R3 : sel_R3=1;
				R4 : sel_R4=1;
				R5 : sel_R5=1;
				R6 : sel_R6=1;
				R7 : sel_R7=1;
				default err_flag=1;
				endcase
				case(dest)
				R0 : load_R0=1;
				R1 : load_R1=1;
				R2 : load_R2=1;
				R3 : load_R3=1;
				R4 : load_R4=1;
				R5 : load_R5=1;
				R6 : load_R6=1;
				R7 : load_R7=1;
				default err_flag=1;
				endcase	
				end // not

			RD : begin
				next_state=s_rd1;
				sel_PC=1;
				sel_bus_1=1;
				load_add_R=1;
				end // rd
			WR : begin
				next_state=s_wr1;
				sel_PC=1;
				sel_bus_1=1;
				load_add_R=1;
				end // wr
			BR : begin
				next_state=s_br1;
				sel_PC=1;
				sel_bus_1=1;
				load_add_R=1;
				end // br
			BRZ : if(zero==1)
			      begin
				next_state=s_br1;
				sel_PC=1;
				sel_bus_1=1;
				load_add_R=1;
				end
			      else
				begin
				  next_state=s_fet1;
				  inc_PC=1;
				end
		default next_state=s_halt;
		endcase //opcode cases are ended here

	s_rd1 : begin
			next_state=s_rd2;
			sel_mem=1;
			inc_PC=1;
		end // case s_rd1
	s_rd2 : begin
			next_state=s_fet1;
			sel_mem=1;
			case(dest)
			R0 : load_R0=1;
			R1 : load_R1=1;
			R2 : load_R2=1;				
			R3 : load_R3=1;
			R4 : load_R4=1;
			R5 : load_R5=1;
			R6 : load_R6=1;
			R7 : load_R7=1;
			default err_flag=1;
			endcase
		end // case s_rd2
	s_wr1 : begin 
			next_state=s_wr2;
			sel_mem=1;
			load_add_R=1;
			inc_PC=1;		
		 end // case s_wr1
	s_wr2 : begin
			next_state=s_fet1;
			write=1;
			case(src)
			R0 : sel_R0=1;
			R1 : sel_R1=1;
			R2 : sel_R2=1;
			R3 : sel_R3=1;
			R4 : sel_R4=1;
			R5 : sel_R5=1;
			R6 : sel_R6=1;
			R7 : sel_R7=1;
			default err_flag=1;
			endcase
		 end // csae s_wr2
	s_br1 : begin
			next_state=s_br2;
			sel_mem=1;
		end
	s_br2 : begin
			next_state=s_fet1;
			sel_mem=1;
			load_PC=1;
		end
	s_halt : next_state=s_halt;
	default  next_state=s_idle;	
endcase
end
endmodule

// end of state machine





















