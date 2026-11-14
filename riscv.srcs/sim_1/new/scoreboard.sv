
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2026 22:45:53
// Design Name: 
// Module Name: scoreboard
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

class scoreboard;

mailbox mon2scb;

function new(mailbox mon2scb);
this.mon2scb=mon2scb;
endfunction

task main;
 transaction trans;
 logic [31:0] exp_result;
 logic        exp_zero;
 
 repeat(10)
    begin 
     mon2scb.get(trans);
     
     // Reference model: calculate expected answer independently
     case (trans.alu_ctrl)
          4'b0000: exp_result = trans.a + trans.b;
          4'b0001: exp_result = trans.a - trans.b;
          4'b0010: exp_result = trans.a << trans.b[4:0];
          4'b0011: exp_result = ($signed(trans.a) < $signed(trans.b)) ? 32'd1 : 32'd0;
          4'b0100: exp_result = (trans.a < trans.b) ? 32'd1 : 32'd0;
          4'b0101: exp_result = trans.a ^ trans.b;
          4'b0110: exp_result = trans.a >> trans.b[4:0];
          4'b0111: exp_result = $signed(trans.a) >>> trans.b[4:0];
          4'b1000: exp_result = trans.a | trans.b;
          4'b1001: exp_result = trans.a & trans.b;
          4'b1010: exp_result = trans.b;
          default: exp_result = 32'd0;
        endcase
       exp_zero=(exp_result==32'd0);
        
        if((trans.result==exp_result)&&(trans.zero==exp_zero))
        $display("[SCOREBOARD] Result is as Expected (PASS)");
        else
          $error("[SCOREBOARD] Wrong Result (FAIL): Expected 0x%08h, Got 0x%08h", 
                 exp_result, trans.result);
        
        trans.display("Scoreboard");
        end
        endtask
 
endclass
