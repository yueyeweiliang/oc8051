`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    16:44:17 09/01/09
// Design Name:    
// Module Name:    KD_CPU
// Project Name:   
// Target Device:  
// Tool versions:  
// Description:
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module KD_CPU(state, F_adr, M_RW, F_data,clk, reset,o_set,Debug_reg, REGSEL,c_flag, z_flag, DBAV, NDAV);
  
	 inout [15:0] F_data; 
	 output [15:0] F_adr;
	 output M_RW; 
	 output [15:0] Debug_reg; reg [15:0]Debug_reg;
	 input [5:0] REGSEL; 
	 input clk;									 
    input reset;		
	 input o_set;
	 output z_flag;
	 output c_flag;
	 output DBAV;
	 output NDAV;
	 output [2:0] state;
	
	
	 wire [7:0] data_out;					 
    wire [7:0] address_out;												 
    wire [7:0] data_in;					 
	 wire RW;
	 assign M_RW=~RW;
	 wire  c_set;
	 
	 wire [7:0] data_bus;					 
	 wire [7:0]	ALU_out;						 
	 wire [7:0]	GR_out;						 
	 wire [7:0]	IR_out;						 
	 wire [7:0]	AC_out;	
	 wire [7:0] CX_out;
	 wire [7:0] SP_out;
	 wire is_zero;	
	 wire iszero;
	 wire Z_in;
	 wire C_out;								
	 wire C_in;									 
	 wire Z_out;								 

	 wire [7:0]	AR_address;					 
	 wire [7:0]	PC_address;					 
	 wire [2:0] GR_address;					
	 wire [4:0]	ALU_OP;						
	 wire [4:0] mul_op;
	 wire [1:0]	mux_C_sel;	
	 wire mux_Z_sel;
	 wire [3:0]	mux_DB_sel;					
	 wire  mux_AB_sel;
	 wire [7:0] HIGH_out;
	 wire [7:0] HIGH_in;
	 wire [7:0] LOW_out;
	 wire [7:0] LOW_in;

	 wire [7:0] divident_high;
	 wire [7:0] divident_low;
    wire [7:0] result_high;
	 wire [7:0] result_low;
	 wire [7:0] residual;

	 wire CLE;									
	 wire ZLE;								 
	 wire IRLE;									
	 wire ARLE;									
	 wire ACLE;									 
	 wire GRLE;									
	 wire GRME;
	 wire GRDE;
	 wire PCLE;									
	 wire PCCE;									
	 wire ALU_C;
	 wire CXLE;
	 wire CXCE;
	 wire c_clear;
	 wire o_clear;
	 wire IF_set;
	 wire IF_clear;
	 wire c_out;
	 wire o_out;
	 wire IF_out;
	 wire c_shield_out; 
	 wire o_shield_out;
	 wire c_allow;
	 wire o_allow;
	 wire c_ban;
	 wire o_ban;
	
	 
	 
	 wire [2:0]int_num;
	 wire [7:0]int_address;
	 assign data_out = data_bus;			
	 assign is_zero = (ALU_out == 'b0)?'b1:'b0;	 
	 
	 assign F_data = M_RW? 16'hzzzz : {8'h00,data_bus};
	 assign data_in = F_data[7:0];
	 assign F_adr = {8'h00,address_out};
	 assign c_flag = C_out; 
	 assign z_flag = Z_out; 
	 always @(REGSEL or PC_address or IR_out or AC_out or state)
		begin
			case (REGSEL)
				6'b000100: Debug_reg <= {8'h88, AC_out};
				6'b000101: Debug_reg <= {8'h99,5'h00, state};
				6'b111110: Debug_reg <= {8'h00, PC_address}; 
				6'b111111: Debug_reg <= {8'h00, IR_out}; 
			default: Debug_reg <= 16'h00_00;
			endcase
		end
	 

	 register #(1) C(.register_out(C_out),.register_in(C_in),.clk(clk),
	 						.reset(reset),.load_enable(CLE));
	 register #(1)	Z(.register_out(Z_out),.register_in(Z_in),.clk(clk),	  
	 						.reset(reset),.load_enable(ZLE));
	 register #(8) IR(.register_out(IR_out),.register_in(data_bus),.clk(clk),
	 						.reset(reset),.load_enable(IRLE));
	 register #(8)	AR(.register_out(AR_address),.register_in(data_bus),.clk(clk),
	 						.reset(reset),.load_enable(ARLE));
	 register #(8)	AC(.register_out(AC_out),.register_in(data_bus),.clk(clk),
	 						.reset(reset),.load_enable(ACLE));
    
	 mux21 mux_Z(.mux2_out(Z_in),.m0_in(is_zero),.m1_in(iszero),.sel_in(mux_Z_sel));
	 mux41 mux_C(.mux41_out(C_in),.m0_in(ALU_C),.m1_in(AC_out[0]),
	 				 .m2_in(AC_out[7]),.m3_in(1'b0),.sel_in(mux_C_sel));
    										  
	 mux16 mux_DB(.mux16_out(data_bus),.m0_in(AC_out),.m1_in(ALU_out),
	 				 .m2_in(data_in),.m3_in(SP_out),.m4_in(GR_out),.m5_in(PC_address),.m6_in(CX_out),.m7_in(int_address),.m8_in(8'b0),
					 .m9_in(8'b0),.m10_in(8'b0),.m11_in(8'b0),.m12_in(8'b0),.m13_in(8'b0),.m14_in(8'b0),.m15_in(8'b0),
					 .sel_in(mux_DB_sel));

	 mux2 mux_AB(.mux2_out(address_out),.m0_in(PC_address),
	 				 .m1_in(AR_address),.sel_in(mux_AB_sel));
	 
	 GR GR(.GR_out(GR_out),.GR_in(data_bus), .mul_enable(GRME),.div_enable(GRDE),.clk(clk),.reset(reset),
				.GR_address(GR_address),.load_enable(GRLE),.HIGH_in(HIGH_out),.LOW_in(LOW_out),.residual(residual),
				.divident_high(divident_high),.divident_low(divident_low),.result_high(result_high),.result_low(result_low));
				
	 SP SP(.SP_out(SP_out),.SP_in(data_bus),.clk(clk),.reset(reset),.push_enable(PULE),.pop_enable(POLE),.SP_empty(E_SP_E),
						.SP_full(E_SP_F));
	 
	 CX CX(.CX_out(CX_out),.CX_count_enable(CXCE),.CX_in(data_bus),.clk(clk),.reset(reset),.CX_load_enable(CXLE),.iszero(iszero));
	
	 ALU ALU(.ALU_O(ALU_out),.ALU_C(ALU_C),.C_in(C_out),.op(ALU_OP),
	 			.AC_in(AC_out),.GR_in(GR_out));
				
	 mul1 mul1(.q1(LOW_out),.q2(HIGH_out),.a(AC_out),.b(GR_out),.mul_op(mul_op)); 			
	 
	 div div(.divident_high(divident_high),.divident_low(divident_low),.dividor(AC_out),.GRDE(GRDE),.result_high(result_high),
	 .result_low(result_low),.residual(residual),.dividor_zero(E_D_Z));
	
	 PC PC(.pc_out(PC_address),.pc_in(data_bus),.clk(clk),
	 		 .reset(reset),.load_enable(PCLE),.count_enable(PCCE));
	 CU  CU(.data_bus(data_bus),.CLE(CLE),.ZLE(ZLE),.ALU_OP(ALU_OP),.mul_op(mul_op),.ACLE(ACLE),
	 			.GR_address(GR_address),.GRLE(GRLE),.GRME(GRME),.GRDE(GRDE),.PULE(PULE),.POLE(POLE),.IRLE(IRLE),
				.ARLE(ARLE),.PCLE(PCLE),.PCCE(PCCE),.CXCE(CXCE),.CXLE(CXLE),.DBAV(DBAV),.NDAV(NDAV),.mux_C_sel(mux_C_sel),.mux_Z_sel(mux_Z_sel),
				.mux_DB_sel(mux_DB_sel),.mux_AB_sel(mux_AB_sel),.RW(RW),
				.clk(clk),.reset(reset),.E_SP_E(E_SP_E),.E_SP_F(E_SP_F),.E_D_Z(E_D_Z),.C_in(C_out),.Z_in(Z_out),.IR_in(IR_out),.int_num(int_num),
				.c_clear(c_clear),.o_clear(o_clear),.IF_set(IF_set),.IF_clear(IF_clear),
				 .c_shield_out(c_shield_out),.o_shield_out(o_shield_out),.IF_out(IF_out),.c_ban(c_ban),.c_allow(c_allow),.o_ban(o_ban),.o_allow(o_allow),.state(state));	
	 
	 int_chart int_chart(.int_num(int_num),.int_address(int_address));
	 
	 IF IF(.clk(clk),.reset(reset),.set(IF_set),.clear(IF_clear),.IF_out(IF_out));
	 
	 int_reg clk_int(.clk(clk),.reset(reset),.set(c_set),.clear(c_clear),.reg_out(c_out));
	 
	 int_reg out_int(.clk(clk),.reset(reset),.set(o_set),.clear(o_clear),.reg_out(o_out));
	 
	 shield c_shield(.clk(clk),.reset(reset),.allow(c_allow),.ban(c_ban),.reg_out(c_out),.shield_out(c_shield_out));
	 
	 shield o_shield(.clk(clk),.reset(reset),.allow(o_allow),.ban(o_ban),.reg_out(o_out),.shield_out(o_shield_out));
	 
	 time_counter time_counter(.clk(clk),.reset(reset),.time_int(c_set),.state(state));
    
endmodule
