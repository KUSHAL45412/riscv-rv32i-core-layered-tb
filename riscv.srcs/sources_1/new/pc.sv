`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2026 22:01:29
// Design Name: 
// Module Name: pc
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


module pc (
   input logic clk,
   input logic rst_n,
   input logic [31:0]next_pc,
   output logic [31:0] pc
    );
    
    parameter logic [31:0] RESET_ADDR=32'h00000000;
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            pc<=RESET_ADDR;
        else
            pc<=next_pc;
      end
endmodule
