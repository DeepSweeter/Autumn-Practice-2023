`ifndef INTERFACE_IN
  `include "interface_in.sv"
	`define INTERFACE_IN
`endif

`ifndef PACKAGE_IN
  `include "package_in.sv"
	`define PACKAGE_IN
`endif

class driver;
    virtual inputData interfaceID;
    event drv_done;
  event gen_done;
    mailbox drv_mbx;



    task run();
      $display("T=%0t [DRIVER] starting... ", $time);
      
      
        @(posedge interfaceID.Clk);
			forever begin
              dut_package_in dpi = new;

              $display("T=%0t [DRIVER] waiting for item ...", $time);
              
              drv_mbx.get(dpi);
              dpi.print("DRIVER");
              interfaceID.commandInput = 1;
              interfaceID.InputKey = dpi.InputKey;
              interfaceID.Reset = dpi.Reset;
              interfaceID.ValidCmd = dpi.ValidCmd;
              interfaceID.RW = 1;
              interfaceID.ConfigDiv = 1;
              interfaceID.Sel = dpi.Sel;
              interfaceID.Din = dpi.Din;
              interfaceID.Addr = dpi.Addr;
              interfaceID.inA = dpi.inA;
              interfaceID.inB = dpi.inB;
              
              $display("T=%0t [DRIVER] finished processing ...", $time);
              @(posedge interfaceID.Clk);
              	
              
              
        end
      interfaceID.commandInput = 1;
    endtask

endclass