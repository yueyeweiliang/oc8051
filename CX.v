`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:15:44 09/29/2009 
// Design Name: 
// Module Name:    CX 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module CX(CX_out,	 CX_in, clk, reset,  CX_load_enable,CX_count_enable,iszero);
    output [7:0] CX_out;
	 output iszero;
    input [7:0] CX_in;
    input clk;
    input reset;
	 input CX_count_enable;
	 input CX_load_enable;
	 reg[7:0] CX_out;
	 assign iszero=(CX_out==0)?1:0;
	 always @ (posedge clk or negedge reset) 
		begin
			if(!reset)
				begin
					CX_out = 'b0;
				end
			else
			 if(CX_load_enable)
					CX_out=CX_in;
			 else if(CX_count_enable)
					CX_out=CX_out-1;
		end
endmodule
