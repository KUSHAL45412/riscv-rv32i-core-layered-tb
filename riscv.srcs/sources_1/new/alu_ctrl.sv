`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2026 11:41:15
// Design Name: 
// Module Name: alu_ctrl
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


module alu_ctrl (
    input  logic [1:0] alu_op,     // 2-bit hint from Main Control
    input  logic [2:0] funct3,     // inst[14:12]
    input  logic       funct7_5,   // inst[30] (bit 5 of funct7)
    input  logic       is_imm,     // 1 if I-type (addi), 0 if R-type (add)
    output logic [3:0] alu_ctrl    // 4-bit operation code to the ALU
);

    localparam [3:0] ALU_ADD  = 4'b0000;
    localparam [3:0] ALU_SUB  = 4'b0001;
    localparam [3:0] ALU_SLL  = 4'b0010;
    localparam [3:0] ALU_SLT  = 4'b0011;
    localparam [3:0] ALU_SLTU = 4'b0100;
    localparam [3:0] ALU_XOR  = 4'b0101;
    localparam [3:0] ALU_SRL  = 4'b0110;
    localparam [3:0] ALU_SRA  = 4'b0111;
    localparam [3:0] ALU_OR   = 4'b1000;
    localparam [3:0] ALU_AND  = 4'b1001;
    localparam [3:0] ALU_PASS = 4'b1010;
    
    always_comb begin
    case (alu_op)
        2'b00: alu_ctrl=ALU_ADD; 
        
        2'b01: alu_ctrl=ALU_SUB;
        
        2'b11:alu_ctrl=ALU_PASS;
        
        2'b10: begin
            case(funct3) 
              3'b000:begin
                if(!is_imm && funct7_5) //R-type  func7_5=1 :sub else add
                    alu_ctrl=ALU_SUB;
                else
                    alu_ctrl=ALU_ADD;
                  end
                  
              3'b001:alu_ctrl=ALU_SLL;
              3'b010:alu_ctrl=ALU_SLT;
              3'b011: alu_ctrl = ALU_SLTU; 
              3'b100: alu_ctrl = ALU_XOR;
              3'b101: begin                // Shift Right
                        if (funct7_5)
                            alu_ctrl=ALU_SRA;
                        else
                            alu_ctrl=ALU_SRL;
                        end
                        
               3'b110: alu_ctrl = ALU_OR;   // OR
                    3'b111: alu_ctrl = ALU_AND;  // AND
                    default: alu_ctrl = ALU_ADD;
                endcase   
                       end       
    default:alu_ctrl=ALU_ADD;
    endcase
    end
endmodule
