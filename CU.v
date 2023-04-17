`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    23:28:43 08/27/09
// Design Name:    
// Module Name:    CU
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
module CU(data_bus, clk, reset, C_in, Z_in, IR_in, CLE, ZLE, ACLE, GRLE, GRME, GRDE, PULE, POLE, ARLE, IRLE, 
             PCLE, PCCE, DBAV, NDAV, E_SP_E, E_SP_F, E_D_Z, ALU_OP, GR_address, mux_C_sel, mux_Z_sel,mux_DB_sel, mux_AB_sel, 
				 mul_op, RW,CXLE,CXCE,c_clear,o_clear,IF_set,IF_clear,
				 c_shield_out,o_shield_out,IF_out,int_num,c_allow,c_ban,o_allow,o_ban,state);
	 parameter FIRST = 'b00, SECOND = 'b01, THIRD = 'b10, HLT = 'b11, FOUR='d4, FIVE='d5;
	 
	 input [7:0]data_bus;
	 input clk;					
    input reset;						
    input C_in;						 
    input Z_in;						 
    input [7:0] IR_in;	
	 input c_shield_out;
	 input o_shield_out;
	 input IF_out;
	 input E_SP_E;
	 input E_SP_F;
	 input E_D_Z;
	 
	 
	 output CLE;			reg CLE;			
	 output ZLE;			reg ZLE;			
	 output ACLE;			reg ACLE;		
    output GRLE;			reg GRLE;		
	 output GRME;			reg GRME;
	 output GRDE;			reg GRDE;
	 output PULE;			reg PULE;
	 output POLE;        reg POLE;
    output ARLE;			reg ARLE;		 
    output IRLE;			reg IRLE;		 
    output PCLE;			reg PCLE;
    output PCCE;			reg PCCE;
	 output CXLE;        reg CXLE;
	 output CXCE;        reg CXCE;
	 output DBAV;			reg DBAV;//data_bus available to CPU1
	 output NDAV;			reg NDAV;
	 output c_clear;     reg c_clear;
	 output o_clear;     reg o_clear;
 	 output IF_set;		reg IF_set;
	 output IF_clear;    reg IF_clear;
	 output c_allow;     reg c_allow;
	 output o_allow;     reg o_allow;
	 output c_ban;       reg c_ban;
	 output o_ban;	      reg o_ban;
	 
								reg exception;
	 

    output [4:0] ALU_OP;			 reg [4:0] ALU_OP;

	 output [4:0] mul_op;				 reg [4:0] mul_op;
    
	 
	 output [2:0] GR_address;		 reg [2:0] GR_address;


	 
    output [1:0] mux_C_sel;		 reg [1:0] mux_C_sel;

    output [3:0] mux_DB_sel;		 reg [3:0] mux_DB_sel;

	 output mux_AB_sel;				 reg  mux_AB_sel;
	 output mux_Z_sel;				 reg  mux_Z_sel;
	 output [2:0] int_num;		    reg [2:0] int_num;

    output RW;							 reg RW;



	 output [2:0]state; reg [2:0] state;		
	 always @ (posedge clk or negedge reset)				
	 		begin
				if(!reset) 
					begin
						state <= FIRST;
					end
				else 
					begin
						case(state)
						FIRST: if(exception)
									state <= FIVE;
								 else
									state <= SECOND;					
						SECOND: if(exception)
									state <= FIVE;
								  else
									state <= THIRD;              
						THIRD: if(IR_in[7:3] == 'b01111)		
						          state <= HLT;
								 else if(exception)
									 state <= FIVE;
								 else	if(IF_out&&(c_shield_out==1 || o_shield_out==1))
									 state <= FOUR;
								 else
								 	 state <= FIRST;				
					   HLT: state <= HLT;	
						FOUR: state <= FIVE;
						FIVE: state <= FIRST;
						endcase
					end
			end

		 always @ (state or C_in or Z_in or IR_in or c_shield_out or o_shield_out or data_bus)
	 		begin
	
			
      		CLE = 'b0;
				ZLE = 'b0;
      		ALU_OP = 'b0;
				ACLE = 'b0;
				GR_address = 'b0;
				GRLE = 'b0;
				IRLE = 'b0;
				ARLE = 'b0;
				PCLE = 'b0;
				PCCE = 'b0;
				mux_C_sel = 'b0;
				mux_Z_sel='b0;
				mux_DB_sel = 4'b0000;
				mux_AB_sel = 'b0;
				RW = 'b0;
				GRME = 'b0;
				CXLE = 'b0;
				CXCE = 'b0;
				GRDE = 'b0;
				PULE = 'b0;
				POLE = 'b0;
				DBAV = 'b1;
				NDAV = 'b1;
				c_clear=0;
				o_clear=0;
				IF_set=0;
				IF_clear=0;
				int_num=0;
				c_allow=0;
				c_ban=0;
				o_allow=0;
				o_ban=0;
				exception = 0;
				case(state)

				FIRST:begin	
							mux_AB_sel = 'b0;			
							mux_DB_sel = 'b0010;
							if	(data_bus[7:3] == 'b00000||data_bus[7:3] == 'b00001 ||
								data_bus[7:3] == 'b01100 || data_bus[7:3] == 'b01101 ||
								data_bus[7:3] == 'b01110 || data_bus[7:3] == 'b11001 ||
								data_bus[7:3] == 'b11010 || data_bus[7:3] == 'b11011)
								DBAV = 'b0;
							NDAV = 'b0;
							IRLE = 'b1;					 
							PCCE = 'b1;					 
						end

				SECOND:begin
							case(IR_in[7:3])

							'b00000,									
							'b00001:
								begin	
									mux_AB_sel = 'b0;		
									mux_DB_sel = 'b0010;
									DBAV = 'b0;
									NDAV = 'b0;
									PCCE = 'b1;		
									ARLE = 'b1;	
								end
						
							
							'b00010:begin									
											GR_address = IR_in[2:0];	 
											ALU_OP = IR_in[7:3];			
											mux_DB_sel = 'b0001;			 
											GRLE = 'b1;						
											CLE = 'b1;					
											ZLE = 'b1;												
											end
					
							'b00011,
							'b00100, 
							'b00101, 
							'b00110, 
							'b00111, 
							'b01000, 
							'b01001, 
							'b01010, 
							'b01011: 
								begin
									GR_address = IR_in[2:0];		
									ALU_OP = IR_in[7:3];			
									mux_DB_sel = 'b0001;			
									ACLE = 'b1;						
									CLE = 'b1; 												
									ZLE = 'b1;						


									if(IR_in[7:3] == 'b01010)		
										mux_C_sel = 'b10;				
									if(IR_in[7:3] == 'b01011)		
										mux_C_sel = 'b01;				
								end
							'b01100,
							'b01101, 
							'b01110:
								begin
									mux_AB_sel = 'b0;		
									mux_DB_sel = 'b0010;
									NDAV = 'b0;
									case(IR_in[4:3])
									'b00:PCLE = 'b1;			
									'b01:
											begin 
											PCLE = !Z_in;
											PCCE = 'b1;			
											end		
									'b10:
											begin 
											PCLE = C_in;		
											PCCE = 'b1;
										  end
									endcase
								end
							'b10000:
								begin
									GR_address = IR_in[2:0];
									mul_op = IR_in[7:3];
									GRME = 'b1;
								end
								
							'b10001:
								begin
									GRDE = 'b1;
								end
							'b10010:
								begin
									mux_DB_sel = 'b0101;
									PULE = 'b1;
									DBAV = 'b0;
									if(E_SP_F)
										exception = 'b1;
								end
							'b10011:
								begin
								mux_DB_sel = 'b0011;
								POLE = 'b1;
								if(E_SP_E)
									exception = 'b1;
								PCLE = 'b1;
								end
									
							'b10100,
							'b10101:
								begin
									if(IR_in[3] == 0)
										begin
											mux_DB_sel = 'b0000;
											PULE = 'b1;
											if(E_SP_F)
												exception = 'b1;
										end
									else 
										begin
											mux_DB_sel = 'b0011;
											ACLE = 'b1;
										end
								end
							'b10110:
								begin
									ZLE = 'b1;
									mux_Z_sel='b1;
									DBAV = 'b0;
								end
									
							'b10111,
							'b11000:
									begin
										case(IR_in[7:3])
										'b10111:begin
													mux_DB_sel = 'b0100;
													GR_address = IR_in[2:0];
													PULE = 'b1;
													if(E_SP_F)
														exception = 'b1;
													end
										'b11000:begin
													mux_DB_sel = 'b0011;
													GR_address = IR_in[2:0];
													GRLE='b1;
												 end
										endcase
									end
							'b11001:
								begin
								mux_AB_sel = 'b0;    
								mux_DB_sel = 'b0010;
								NDAV = 'b0;
								PCCE = 'b1;            
								CXLE = 'b1;
								end
							'b11010:
								begin
								mux_AB_sel = 'b0;     
								mux_DB_sel = 'b0010;
								PCCE = 'b1;                 
								GR_address = IR_in[2:0];       
								GRLE=1;
								NDAV = 'b0;
								end
							'b11011:
								begin
								mux_AB_sel = 'b0;   
								GR_address = IR_in[2:0];        
								mux_DB_sel = 'b0010;
								PCCE = 'b1;                    
								RW=1;
								NDAV = 'b0;	
								end
							'b11100:
								IF_set=1;
							'b11101:
								IF_clear=1;								
						endcase
					end
					THIRD:
					begin
							if(IR_in[7:3] == 'b01111)
								begin
									DBAV = 'b1;
									NDAV = 'b1;
								end
							else if(IF_out&&(c_shield_out==1 || o_shield_out==1))
								DBAV = 'b1;
							else	
								DBAV = 'b0;
								
									
							
							case(IR_in[7:3])
								'b00000,
								'b00001:
									begin
										mux_AB_sel = 'b1;
										NDAV = 'b0;
										if(!IR_in[3])
											begin
												mux_DB_sel = 'b0010;
												ACLE = 'b1;					
											end
										else 
											begin
												mux_DB_sel = 'b0000;
												RW = 'b1;
											end
									end
								'b10010:
									begin
										mux_AB_sel = 'b0;
									   mux_DB_sel = 'b0010;  
										NDAV = 'b0;
										PCLE='b1;
									end
								'b10011:	//interrupt RET
									begin
										if(IF_out == 1)
											PCCE = 1'b1;
										else
											begin
												IF_set = 1;	
											end
										c_allow=1;
										o_allow=1;
											
									end
								'b10101:
								   begin
									POLE = 'b1;
									if(E_SP_E)
										exception = 'b1;
									end								
								'b10110:
									begin
										mux_AB_sel = 'b0;  
										mux_DB_sel = 'b0010;  
										NDAV = 'b0;										
										PCLE = !Z_in;                
										PCCE = 'b1;                 
									if(!Z_in) 
									   CXCE=1;
									end

								'b11000:
									begin
										POLE = 'b1;
										if(E_SP_E)
											exception = 'b1;
									end
								endcase
							end
					FOUR:
						begin
							IF_clear='b1;
							mux_DB_sel='b101;
							PULE='b1;
							if(E_SP_F)
								exception = 'b1;
						end
					FIVE:
					begin
						DBAV = 'b0;
						if(E_SP_E)
							begin
								int_num = 3;
								mux_DB_sel = 'b111;
								PCLE = 'b1;
							end
						if(E_SP_F)
							begin
								int_num = 4;
								mux_DB_sel = 'b111;
								PCLE = 'b1;
							end
						if(E_D_Z)
							begin
								int_num = 5;
								mux_DB_sel = 'b111;
								PCLE = 'b1;
							end
						/*if(Overflow)
							begin
								int_num = 6;
								mux_DB_sel = 'b111;
								PCLE = 'b1;
							end*/
						if(c_shield_out==1)
							begin
								int_num=1;
								mux_DB_sel='b111;
								PCLE='b1;
								c_clear=1;
								c_ban=1;
								o_ban=1;
								IF_set = 1;
							end
						else if(o_shield_out==1)
							begin
								int_num=2;
								mux_DB_sel='b111;
								PCLE='b1;
								o_clear=1;
								o_ban=1;
								IF_set=1;
							end
					end
					endcase
				end

endmodule 