
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2026 19:55:12
// Design Name: 
// Module Name: generator
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

class generator;

transaction trans;
mailbox gen2driv;

function new(mailbox gen2driv);
    this.gen2driv=gen2driv;
   endfunction
   
   task main();
    repeat(10)
        begin
    trans=new();
    trans.randomize();
    trans.display("Generator");
    gen2driv.put(trans);
    end
    endtask   
endclass