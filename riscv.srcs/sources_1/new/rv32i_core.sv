`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2026 20:42:06
// Design Name: 
// Module Name: rv32i_core
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


module rv32i_core (
    input  logic        clk,
    input  logic        rst_n,

    // Debug / observation pins (so we can monitor execution in simulation)
    output logic [31:0] pc_out,
    output logic [31:0] inst_out,
    output logic [31:0] alu_result_out,
    output logic [31:0] reg_wdata_out,
    output logic        reg_write_out
);
//-------------------------------------declaring the varaibles-------------------------------------------------------------
    // =========================================================================
    // 1. Internal Wires
    // =========================================================================
    logic [31:0] current_pc;
    logic [31:0] next_pc;
    logic [31:0] pc_plus_4;
    logic [31:0] pc_target;
    logic [31:0] pc_jalr_target;

    logic [31:0] inst;
    logic [6:0]  opcode;
    logic [4:0]  rd;
    logic [2:0]  funct3;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [6:0]  funct7;

    // Control wires
    logic        reg_write;
    logic [2:0]  imm_src;
    logic        alu_src_a;
    logic        alu_src_b;
    logic [1:0]  alu_op;
    logic        mem_read;
    logic        mem_write;
    logic [1:0]  mem_to_reg;
    logic        branch;
    logic        jal;
    logic        jalr;

    // Data wires
    logic [31:0] rdata1;
    logic [31:0] rdata2;
    logic [31:0] imm_out;
    logic [31:0] alu_in_a;
    logic [31:0] alu_in_b;
    logic [3:0]  alu_ctrl_sig;
    logic [31:0] alu_result;
    logic        alu_zero;
    logic        branch_taken;
    logic [31:0] mem_rdata;
    logic [31:0] reg_wdata;
//-------------------------------------------------assigning the variables---------------------------------------------------------------------
    // =========================================================================
    // 2. Instruction Field Slicing
    // =========================================================================
    assign opcode = inst[6:0];
    assign rd     = inst[11:7];
    assign funct3 = inst[14:12];
    assign rs1    = inst[19:15];
    assign rs2    = inst[24:20];
    assign funct7 = inst[31:25];
//--------------------------------------- instantiating (connecting)--------------------------------------------------------
    // =========================================================================
    // 3. PC & Next-PC Logic
    // =========================================================================
    pc u_pc (
        .clk     (clk),
        .rst_n   (rst_n),
        .next_pc (next_pc),
        .pc      (current_pc)
    );

    // Calculate possible next PC targets in parallel
    assign pc_plus_4      = current_pc + 32'd4;
    assign pc_target      = current_pc + imm_out;
    assign pc_jalr_target = (rdata1 + imm_out) & ~32'd1; // bit 0 cleared per RISC-V spec

    // Next-PC Multiplexer
    always_comb begin
        if (jalr)
            next_pc = pc_jalr_target;
        else if (jal || branch_taken)
            next_pc = pc_target;
        else
            next_pc = pc_plus_4;
    end

    // =========================================================================
    // 4. Instruction Memory
    // =========================================================================
    inst_mem u_imem (
        .addr  (current_pc),
        .rdata (inst)
    );

    // =========================================================================
    // 5. Main Control Unit
    // =========================================================================
    control_unit u_control (
        .opcode     (opcode),
        .reg_write  (reg_write),
        .imm_src    (imm_src),
        .alu_src_a  (alu_src_a),
        .alu_src_b  (alu_src_b),
        .alu_op     (alu_op),
        .mem_read   (mem_read),
        .mem_write  (mem_write),
        .mem_to_reg (mem_to_reg),
        .branch     (branch),
        .jal        (jal),
        .jalr       (jalr)
    );

    // =========================================================================
    // 6. Register File
    // =========================================================================
    reg_file u_regfile (
        .clk       (clk),
        .rst_n     (rst_n),
        .raddr1    (rs1),
        .raddr2    (rs2),
        .waddr     (rd),
        .wdata     (reg_wdata),
        .reg_write (reg_write),
        .rdata1    (rdata1),
        .rdata2    (rdata2)
    );

    // =========================================================================
    // 7. Immediate Generator
    // =========================================================================
    imm_gen u_immgen (
        .inst    (inst),
        .imm_src (imm_src),
        .imm_out (imm_out)
    );

    // =========================================================================
    // 8. ALU Control & ALU
    // =========================================================================
    alu_ctrl u_alu_ctrl (
        .alu_op   (alu_op),
        .funct3   (funct3),
        .funct7_5 (funct7[5]),
        .is_imm   (opcode == 7'b0010011), // 1 if I-type
        .alu_ctrl (alu_ctrl_sig)
    );

    // ALU Input Multiplexers
    assign alu_in_a = alu_src_a ? current_pc : rdata1;
    assign alu_in_b = alu_src_b ? imm_out    : rdata2;

    alu u_alu (
        .a        (alu_in_a),
        .b        (alu_in_b),
        .alu_ctrl (alu_ctrl_sig),
        .result   (alu_result),
        .zero     (alu_zero)
    );

    // =========================================================================
    // 9. Branch Unit
    // =========================================================================
    branch_unit u_branch_unit (
        .rdata1       (rdata1),
        .rdata2       (rdata2),
        .funct3       (funct3),
        .branch_en    (branch),
        .branch_taken (branch_taken)
    );

    // =========================================================================
    // 10. Data Memory
    // =========================================================================
    data_mem u_dmem (
        .clk       (clk),
        .rst_n     (rst_n),
        .mem_write (mem_write),
        .mem_read  (mem_read),
        .addr      (alu_result),
        .wdata     (rdata2),
        .rdata     (mem_rdata)
    );

    // =========================================================================
    // 11. Write-Back Multiplexer
    // =========================================================================
    always_comb begin
        case (mem_to_reg)
            2'b00:   reg_wdata = alu_result; // ALU math result
            2'b01:   reg_wdata = mem_rdata;  // Data loaded from RAM
            2'b10:   reg_wdata = pc_plus_4;  // Jump return address
            default: reg_wdata = alu_result;
        endcase
    end

    // =========================================================================
    // 12. Connect Debug Output Wires
    // =========================================================================
    assign pc_out         = current_pc;
    assign inst_out       = inst;
    assign alu_result_out = alu_result;
    assign reg_wdata_out  = reg_wdata;
    assign reg_write_out  = reg_write;

endmodule
