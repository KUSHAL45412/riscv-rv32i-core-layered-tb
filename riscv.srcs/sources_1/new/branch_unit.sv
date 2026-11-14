`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2026 13:06:30
// Design Name: 
// Module Name: branch_unit
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


module branch_unit(
input logic [31:0]rdata1,
input logic[31:0]rdata2,
input logic[2:0] funct3,
input logic branch_en,
output logic branch_taken
    );
    
    logic condition_met;
    always_comb begin
        case (funct3)
            3'b000:  condition_met = (rdata1 == rdata2);                    // BEQ
            3'b001:  condition_met = (rdata1 != rdata2);                    // BNE
            3'b100:  condition_met = ($signed(rdata1) < $signed(rdata2));  // BLT  (signed)
            3'b101:  condition_met = ($signed(rdata1) >= $signed(rdata2)); // BGE  (signed)
            3'b110:  condition_met = (rdata1 < rdata2);                     // BLTU (unsigned)
            3'b111:  condition_met = (rdata1 >= rdata2);                    // BGEU (unsigned)
            default: condition_met = 1'b0;
        endcase
    end
    // Only take branch if condition is met AND it is actually a branch instruction!
    assign branch_taken = branch_en & condition_met;
endmodule
