
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2026 23:14:20
// Design Name: 
// Module Name: tbench_top
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


//`include "interface.sv"
//`include "test.sv"

module tbench_top;
  
  // 1. Instantiate the physical interface
  intf i_intf();
  
  // 2. Instantiate the test program
  test t1(i_intf);
  
  // 3. Instantiate the ALU hardware DUT
  alu u_alu (
    .a        (i_intf.a),
    .b        (i_intf.b),
    .alu_ctrl (i_intf.alu_ctrl),
    .result   (i_intf.result),
    .zero     (i_intf.zero)
  );
  
  // 4. Waveform dump
  initial begin 
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
endmodule
