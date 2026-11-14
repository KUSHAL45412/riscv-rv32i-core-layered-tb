`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2026 22:24:21
// Design Name: 
// Module Name: reg_file
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reg_file(
input logic clk, 
input logic rst_n,
input logic[4:0] raddr1, //rs1
input logic [4:0] raddr2, //rs2
input logic [31:0]wdata,   //32bit data to write 
input logic[4:0] waddr,  //rd
input logic reg_write ,// enabling write into reg 
output logic [31:0] rdata1,
output logic [31:0] rdata2
    );
    
    logic [31:0] regs [0:31]; //32 bit wide , 32 bit reg
    
    //async read
    assign rdata1 = (raddr1==5'd0)?32'd0:regs[raddr1];
    assign rdata2 = (raddr2==5'd0)?32'd0:regs[raddr2];
    
    //sync write
    always_ff @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) begin
            foreach(regs[i])begin  //resetting all the regs
                regs[i]<=32'd0;
         end
         end
         
         else if(reg_write &&(wdata!=5'd0))begin
            regs[waddr]<=wdata;
            end
            end
endmodule
