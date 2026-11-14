
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2026 22:08:02
// Design Name: 
// Module Name: driver
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

class driver;

virtual intf vif;
mailbox gen2driv;

function new (virtual intf vif, mailbox gen2driv);
    this.vif=vif;
    this.gen2driv=gen2driv;
    endfunction
    
    task main;
    repeat(10)
     begin
        transaction trans;
        gen2driv.get(trans);
        
        vif.a<= trans.a;
        vif.b<=trans.b;
        vif.alu_ctrl<=trans.alu_ctrl;
        
        trans.display("Driver");
        #2;
        end
        endtask

endclass
