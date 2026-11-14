`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2026 23:41:18
// Design Name: 
// Module Name: alu
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


module alu (
    input  logic [31:0] a,          // Operand A
    input  logic [31:0] b,          // Operand B
    input  logic [3:0]  alu_ctrl,   // 4-bit command from alu_ctrl.sv
    output logic [31:0] result,     // Calculation result
    output logic        zero        // 1 if result is 0
);
    always_comb begin
        case (alu_ctrl)
            4'b0000: result = a + b;                                      // ADD
            4'b0001: result = a - b;                                      // SUB
            4'b0010: result = a << b[4:0];                               // SLL (Shift Left)
            4'b0011: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLT (Signed compare)
            4'b0100: result = (a < b) ? 32'd1 : 32'd0;                   // SLTU (Unsigned compare)
            4'b0101: result = a ^ b;                                      // XOR
            4'b0110: result = a >> b[4:0];                               // SRL (Shift Right Logical)
            4'b0111: result = $signed(a) >>> b[4:0];                      // SRA (Shift Right Arith)
            4'b1000: result = a | b;                                      // OR
            4'b1001: result = a & b;                                      // AND
            4'b1010: result = b;                                          // PASS B (for LUI)
            default: result = 32'd0;
        endcase
    end
    // Flag is 1 when result is zero (useful for equality checks)
    assign zero = (result == 32'd0);
endmodule
