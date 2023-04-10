//////////////////////////////////////////////////////////////////////
////                                                              ////
////  8051 stack pointer                                          ////
////                                                              ////
////  This file is part of the 8051 cores project                 ////
////  http://www.opencores.org/cores/8051/                        ////
////                                                              ////
////  Description                                                 ////
////   8051 special function register: stack pointer.             ////
////                                                              ////
////  To Do:                                                      ////
////   nothing                                                    ////
////                                                              ////
////  Author(s):                                                  ////
////      - Simon Teran, simont@opencores.org                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS Revision History
//
// $Log: not supported by cvs2svn $
// Revision 1.5  2003/01/13 14:14:41  simont
// replace some modules
//
// Revision 1.4  2002/11/05 17:23:54  simont
// add module oc8051_sfr, 256 bytes internal ram
//
// Revision 1.3  2002/09/30 17:33:59  simont
// prepared header
//
//

// synopsys translate_off
`include "oc8051_timescale.v"
// synopsys translate_on

`include "oc8051_defines.v"



module oc8051_sp (clk, rst, ram_rd_sel, ram_wr_sel, wr_addr, wr, wr_bit, data_in, sp_out, sp_w);


input clk, rst, wr, wr_bit;             //wr:字节写入，wr_bit:位写入，SP不支持位操作，所以wr_bit必须是0
input [2:0] ram_rd_sel, ram_wr_sel;     //内部操作地址，此处用于确定出栈和入栈
input [7:0] data_in, wr_addr;           //数据和地址总线
output [7:0] sp_out, sp_w;

reg [7:0] sp_out, sp_w;     //sp_out作为总线输出，sp_w作为出栈时的地址输出
reg pop;                    //出栈标记
wire write;                 //写入信号
wire [7:0] sp_t;

reg [7:0] sp;   //寄存器实体


assign write = ((wr_addr==`OC8051_SFR_SP) & (wr) & !(wr_bit));    //写入信号有效，且地址匹配，则产生写信号

assign sp_t= write ? data_in : sp;  //如果需要写入则使用外部输入数据，否则使用现有数据


always @(posedge clk or posedge rst)    //时钟边沿更新寄存器，可能是复位、总线写入、其它操作
begin
  if (rst)
    sp <= #1 `OC8051_RST_SP;    //复位初始值
  else if (write)
    sp <= #1 data_in;           //总线写入
  else
    sp <= #1 sp_out;            //自更新
end


always @(sp or ram_wr_sel)
begin
//
// push，入栈操作，指针向上增长
  if (ram_wr_sel==`OC8051_RWS_SP) sp_w = sp + 8'h01;
  else sp_w = sp;

end


always @(sp_t or ram_wr_sel or pop or write)
begin
//
// push
  if (write) sp_out = sp_t;     //普通写入，由外部更新
  else if (ram_wr_sel==`OC8051_RWS_SP) sp_out = sp_t + 8'h01;   //入栈，向上增长
  else sp_out = sp_t - {7'b0, pop};       //可能是出栈，取决于pop标记

end


always @(posedge clk or posedge rst)    //出栈操作，做pop标记
begin
  if (rst)
    pop <= #1 1'b0;
  else if (ram_rd_sel==`OC8051_RRS_SP) pop <= #1 1'b1;
  else pop <= #1 1'b0;
end

endmodule
