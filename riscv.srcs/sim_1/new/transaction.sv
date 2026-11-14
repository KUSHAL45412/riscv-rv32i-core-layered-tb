//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2026 19:20:52
// Design Name: 
// Module Name: transaction
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


class transaction;

    rand bit [31:0] a;
    rand bit [31:0] b;
    rand bit [3:0]alu_ctrl ;
    
    bit [31:0] result ;
    bit zero;
    
    constraint c_alu_ctrl{   
    alu_ctrl inside {[4'b0000: 4'b1010]}; 
    };
    
     function string get_op_name();
      case (alu_ctrl)
        4'b0000: return "ADD";
        4'b0001: return "SUB";
        4'b0010: return "SLL";
        4'b0011: return "SLT";
        4'b0100: return "SLTU";
        4'b0101: return "XOR";
        4'b0110: return "SRL";
        4'b0111: return "SRA";
        4'b1000: return "OR";
        4'b1001: return "AND";
        4'b1010: return "PASS_B";
        default: return "UNKNOWN";
      endcase
    endfunction
    
    
    function void display(input string name);
    $display("-------------------------");
    $display(" %s ", name);
    $display("-------------------------");
    $display("a = 0x%08h (%0d), b = 0x%08h (%0d)", a, a, b, b);
    $display("alu_ctrl = 4'b%04b [%s]", alu_ctrl, get_op_name());
    $display("result   = 0x%08h (%0d), zero = %0b", result, result, zero);
    $display("-------------------------");
  endfunction
endclass
