
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2026 22:38:02
// Design Name: 
// Module Name: monitor
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


class monitor;

  mailbox mon2scb;
  virtual intf vif;

  // Constructor
  function new(virtual intf vif, mailbox mon2scb);
    this.vif     = vif;
    this.mon2scb = mon2scb;
  endfunction

  // Main monitoring task
    // Main monitoring task
  task main();
    transaction trans; // ✅ 1. Declare at the top!
    
    repeat(10)
      begin
        #1; // 2. Now the delay is valid!
        
        trans = new(); // 3. Create new transaction object
        
        // Sample all inputs and outputs from interface wires
        trans.a        = vif.a;
        trans.b        = vif.b;
        trans.alu_ctrl = vif.alu_ctrl;
        trans.result   = vif.result;
        trans.zero     = vif.zero;
        
        mon2scb.put(trans);       // Send packet to Scoreboard!
        trans.display("Monitor"); // Print Monitor log!
        
        #1; // Wait remaining 1ns to complete the 2ns step
      end
  endtask
  
  endclass