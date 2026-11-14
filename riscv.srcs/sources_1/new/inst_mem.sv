`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2026 22:17:26
// Design Name: 
// Module Name: inst_mem
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


module inst_mem(
 input logic [31:0]addr,
 output logic [31:0] rdata
    );
    logic [31:0]mem[0:1023];
    
    assign rdata=mem[addr[31:2]];
endmodule
