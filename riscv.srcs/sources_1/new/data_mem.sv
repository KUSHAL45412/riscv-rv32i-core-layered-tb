`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2026 13:22:27
// Design Name: 
// Module Name: data_mem
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


module data_mem(
input logic clk,
input logic rst_n,
input logic mem_write,
input logic mem_read,
input logic [31:0]addr,
input logic [31:0]wdata,
output logic [31:0]rdata
    );
    
    logic[31:0]mem[0:1023];
    
    //sync write
    always_ff @(posedge clk or negedge rst_n)begin
        if(!rst_n) begin
            end
            
        else if(mem_write) begin
            mem[addr[11:2]]<=wdata; //the starting mem[addr] of req word
            end
            end
            
            
       //asyn read     
     always_comb begin
     if(mem_read)
        rdata=mem[addr[11:2]];
       else
        rdata=32'd0;
        end
        
endmodule
