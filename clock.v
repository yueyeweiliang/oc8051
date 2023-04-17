`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    12:14:37 08/30/09
// Design Name:    
// Module Name:    clock
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
module clock(clk);

	 parameter cyc = 5;

    output clk;
	 reg clk;

	 initial
	 	clk =0;
	 always 
	 	#cyc clk = ~clk;

endmodule
