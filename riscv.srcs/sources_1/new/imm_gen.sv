`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2026 23:00:07
// Design Name: 
// Module Name: imm_gen
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


`timescale 1ns / 1ps

module imm_gen (
    input  logic [31:0] inst,       // The 32-bit instruction
    input  logic [2:0]  imm_src,    // Selects format: 0=I, 1=S, 2=B, 3=U, 4=J
    output logic [31:0] imm_out     // 32-bit sign-extended immediate
);

    always_comb begin
        case (imm_src)
            // ---------------------------------------------------------
            // I-type: (addi, lw, jalr) -> 12-bit immediate at inst[31:20]
            // ---------------------------------------------------------
            3'b000: begin
                imm_out = {{20{inst[31]}}, inst[31:20]};
            end

            // ---------------------------------------------------------
            // S-type: (sw, sh, sb) -> Split into inst[31:25] and inst[11:7]
            // ---------------------------------------------------------
            3'b001: begin
                imm_out = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            end

            // ---------------------------------------------------------
            // B-type: (beq, bne) -> Branch offset (bit 0 is always 0)
            // ---------------------------------------------------------
            3'b010: begin
                imm_out = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            end

            // ---------------------------------------------------------
            // U-type: (lui, auipc) -> Upper 20 bits, lower 12 bits zero
            // ---------------------------------------------------------
            3'b011: begin
                imm_out = {inst[31:12], 12'h000};
            end

            // ---------------------------------------------------------
            // J-type: (jal) -> Jump offset (bit 0 is always 0)
            // ---------------------------------------------------------
            3'b100: begin
                imm_out = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            end

            default: imm_out = 32'd0;
        endcase
    end

endmodule
