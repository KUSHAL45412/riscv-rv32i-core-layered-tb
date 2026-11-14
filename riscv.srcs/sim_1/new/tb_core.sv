`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2026 00:03:10
// Design Name: 
// Module Name: tb_core
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


module tb_core;

    logic clk, rst_n;
    logic [31:0] pc_out;
    logic [31:0] inst_out;
    logic [31:0] alu_result_out;
    logic [31:0] reg_wdata_out;
    logic        reg_write_out;

    // 1. Clock Generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // 2. Connect the Core
    rv32i_core u_core (
        .clk            (clk),
        .rst_n          (rst_n),
        .pc_out         (pc_out),
        .inst_out       (inst_out),
        .alu_result_out (alu_result_out),
        .reg_wdata_out  (reg_wdata_out),
        .reg_write_out  (reg_write_out)
    );
    
    // 3. Test Sequence
    initial begin
        rst_n = 0;
        $display("[TB] Loading program: basic_test.hex");
        $readmemh("basic_test.hex", u_core.u_imem.mem); // <-- fixed u_imem
        
        #20;
        @(negedge clk);
        rst_n = 1;
        $display("[TB] Reset released! CPU starts executing...\n");
        
        for (int i = 0; i < 50; i++) begin // <-- fixed space in "int i"
            @(posedge clk);
            if (reg_write_out && (inst_out[11:7] != 0)) begin
                $display("[Cycle %0d] PC: 0x%08h | Inst: 0x%08h | x%0d <= %0d",
                         i+1, pc_out, inst_out, inst_out[11:7], reg_wdata_out);
            end else begin
                $display("[Cycle %0d] PC: 0x%08h | Inst: 0x%08h",
                         i+1, pc_out, inst_out);
            end

            // Detect halt instruction (beq x0, x0, 0 which is 0x00000063)
            if (inst_out == 32'h0000_0063) begin
                $display("\n[TB] Program finished (Halt detected at PC = 0x%08h)!", pc_out);
                break;
            end
        end

        // Added this so simulation stops properly:
        $display("========================================");
        $display("         SIMULATION COMPLETE!           ");
        $display("========================================");
        $finish; 
    end // <-- Added this 'end' to close 'initial begin'

endmodule