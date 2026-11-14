`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2026 19:28:40
// Design Name: 
// Module Name: control_unit
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


module control_unit (
    input  logic [6:0] opcode,      // inst[6:0]

    // Control Outputs to the Datapath
    output logic       reg_write,   // 1: Write result into Register File (rd)
    output logic [2:0] imm_src,     // 0=I, 1=S, 2=B, 3=U, 4=J
    output logic       alu_src_a,   // 0: rs1, 1: PC (used for AUIPC)
    output logic       alu_src_b,   // 0: rs2, 1: Immediate
    output logic [1:0] alu_op,      // Hint to ALU Ctrl: 00=ADD, 01=SUB, 10=R/I, 11=PASS
    output logic       mem_read,    // 1: Read from Data RAM
    output logic       mem_write,   // 1: Write to Data RAM
    output logic [1:0] mem_to_reg,  // 00: ALU, 01: RAM, 10: PC+4
    output logic       branch,      // 1: Conditional branch instruction
    output logic       jal,         // 1: JAL jump
    output logic       jalr         // 1: JALR jump
);

    always_comb begin
        // Safe default assignments (all controls off)
        reg_write  = 1'b0;
        imm_src    = 3'b000;
        alu_src_a  = 1'b0; // Default: rs1
        alu_src_b  = 1'b0; // Default: rs2
        alu_op     = 2'b00;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        mem_to_reg = 2'b00;
        branch     = 1'b0;
        jal        = 1'b0;
        jalr       = 1'b0;

        case (opcode)
            // ---------------------------------------------------------
            // 1. R-type Arithmetic: add, sub, and, or, sll, slt...
            // ---------------------------------------------------------
            7'b0110011: begin
                reg_write  = 1'b1;  // Writes result to rd
                alu_src_b  = 1'b0;  // ALU 2nd input is register rs2
                alu_op     = 2'b10; // Tell alu_ctrl to look at funct3 & funct7
                mem_to_reg = 2'b00; // Result comes from ALU
            end

            // ---------------------------------------------------------
            // 2. I-type Arithmetic: addi, andi, ori, slli, slti...
            // ---------------------------------------------------------
            7'b0010011: begin
                reg_write  = 1'b1;  // Writes result to rd
                imm_src    = 3'b000;// I-type immediate format
                alu_src_b  = 1'b1;  // ALU 2nd input is Immediate
                alu_op     = 2'b10; // Tell alu_ctrl to look at funct3
                mem_to_reg = 2'b00; // Result comes from ALU
            end

            // ---------------------------------------------------------
            // 3. Load from RAM: lw, lh, lb...
            // ---------------------------------------------------------
            7'b0000011: begin
                reg_write  = 1'b1;  // Writes loaded data to rd
                imm_src    = 3'b000;// I-type immediate (offset)
                alu_src_b  = 1'b1;  // ALU adds rs1 + Immediate (address)
                alu_op     = 2'b00; // 00 means ADD
                mem_read   = 1'b1;  // Read from Data RAM
                mem_to_reg = 2'b01; // WB Mux selects RAM data!
            end

            // ---------------------------------------------------------
            // 4. Store to RAM: sw, sh, sb...
            // ---------------------------------------------------------
            7'b0100011: begin
                imm_src    = 3'b001;// S-type immediate (offset)
                alu_src_b  = 1'b1;  // ALU adds rs1 + Immediate (address)
                alu_op     = 2'b00; // 00 means ADD
                mem_write  = 1'b1;  // Write to Data RAM!
                // reg_write is 0: stores don't modify registers
            end

            // ---------------------------------------------------------
            // 5. Branch: beq, bne, blt, bge...
            // ---------------------------------------------------------
            7'b1100011: begin
                imm_src    = 3'b010;// B-type immediate (branch target)
                alu_src_b  = 1'b0;  // Compare rs1 and rs2
                alu_op     = 2'b01; // SUB for comparison
                branch     = 1'b1;  // Enable branch unit!
            end

            // ---------------------------------------------------------
            // 6. JAL (Unconditional Jump and Link)
            // ---------------------------------------------------------
            7'b1101111: begin
                reg_write  = 1'b1;  // Save return address into rd
                imm_src    = 3'b100;// J-type immediate (jump target)
                mem_to_reg = 2'b10; // WB Mux selects PC + 4!
                jal        = 1'b1;  // Jump!
            end

            // ---------------------------------------------------------
            // 7. JALR (Indirect Jump and Link)
            // ---------------------------------------------------------
            7'b1100111: begin
                reg_write  = 1'b1;  // Save return address into rd
                imm_src    = 3'b000;// I-type immediate
                alu_src_b  = 1'b1;  // Target is rs1 + offset
                alu_op     = 2'b00; // ADD
                mem_to_reg = 2'b10; // WB Mux selects PC + 4!
                jalr       = 1'b1;  // Jump indirect!
            end

            // ---------------------------------------------------------
            // 8. LUI (Load Upper Immediate)
            // ---------------------------------------------------------
            7'b0110111: begin
                reg_write  = 1'b1;  // Writes to rd
                imm_src    = 3'b011;// U-type immediate
                alu_src_b  = 1'b1;  // Immediate into ALU
                alu_op     = 2'b11; // ALU passes operand B straight through
                mem_to_reg = 2'b00; // Result comes from ALU
            end

            // ---------------------------------------------------------
            // 9. AUIPC (Add Upper Immediate to PC)
            // ---------------------------------------------------------
            7'b0010111: begin
                reg_write  = 1'b1;  // Writes to rd
                imm_src    = 3'b011;// U-type immediate
                alu_src_a  = 1'b1;  // Selects PC for ALU input A!
                alu_src_b  = 1'b1;  // Selects Immediate for ALU input B
                alu_op     = 2'b00; // ADD (PC + Immediate)
                mem_to_reg = 2'b00; // Result comes from ALU
            end

            default: begin
                // Keeps all safe default zeroes
            end
        endcase
    end

endmodule