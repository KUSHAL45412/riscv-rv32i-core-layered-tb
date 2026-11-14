
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2026 22:53:29
// Design Name: 
// Module Name: environment
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

`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class environment;

 generator   gen;
  driver      driv;
  monitor     mon;
  scoreboard  scb;
  
  mailbox m1; // Generator to Driver mailbox
  mailbox m2; // Monitor to Scoreboard mailbox
  virtual intf vif;
  
function new(virtual intf vif);
this.vif=vif;

m1=new();
m2=new();
gen=new(m1);
driv=new(vif,m1);
mon=new(vif,m2);
scb=new(m2);
endfunction

task test();
    fork
        gen.main();
        driv.main();
        mon.main();
        scb.main();
    join
    
   endtask
   
   task run;
    test();
    $finish; // End simulation when all 4 tasks finish!
  endtask
endclass
