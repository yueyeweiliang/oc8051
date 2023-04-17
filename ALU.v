`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    20:42:54 08/28/09
// Design Name:    
// Module Name:    ALU
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
module ALU(C_in, op, AC_in, GR_in, ALU_C, ALU_O);
    input C_in;								  
    input [4:0] op;						
    input [7:0] AC_in;					
    input [7:0] GR_in;						  
    output ALU_C;								  
    output [7:0] ALU_O;						  


	 reg [7:0] ALU_O;
	 reg ALU_C;

	 always @ (C_in or op or AC_in or GR_in)
	 		begin 
				case(op)
				5'b00010:begin {ALU_C, ALU_O} = {C_in, AC_in};end							
				5'b00011:begin {ALU_C, ALU_O} = {C_in, GR_in};end						
				5'b00100:begin {ALU_C, ALU_O} = AC_in + GR_in;end						
				5'b00101:begin {ALU_C, ALU_O} = AC_in - GR_in;end						
				5'b00110:begin {ALU_C, ALU_O} = AC_in + GR_in + C_in;end 			 
				5'b00111:begin {ALU_C, ALU_O} = AC_in - GR_in - C_in;end					
				5'b01000:begin {ALU_C, ALU_O} = {C_in, AC_in&GR_in};end					
				5'b01001:begin {ALU_C, ALU_O} = {C_in, AC_in^GR_in};end					
				5'b01010:begin {ALU_C, ALU_O} = {GR_in, C_in};end							
				5'b01011:begin {ALU_C, ALU_O} = {GR_in[0], C_in, GR_in[7:1]};end		
				default:	begin {ALU_C, ALU_O} = {C_in, 8'b0};end							
				endcase
			end

endmodule
