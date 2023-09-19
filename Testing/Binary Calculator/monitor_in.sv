`ifndef INTERFACE_IN
`include "interface_in.sv"
`define INTERFACE_IN
`endif

`ifndef PACKAGE_IN
`include "package_in.sv"
`define PACKAGE_IN
`endif

class monitor_input;
  virtual inputData interfaceID;
  mailbox scb_input_mbx;


  task run();
    $display("T=%0t [MONITOR INPUT] starting ...", $time);
    forever begin
      @(posedge interfaceID.Clk);
      if(1) begin
        dut_package_in pkg = new;
        pkg.Reset       =    interfaceID.Reset;
        pkg.ValidCmd    =    interfaceID.ValidCmd;
        pkg.RW          =    interfaceID.RW;
        pkg.ConfigDiv   =    interfaceID.ConfigDiv;
        pkg.Sel         =    interfaceID.Sel;
        pkg.Din         =    interfaceID.Din;
        pkg.Addr        =    interfaceID.Addr;
        pkg.inA         =    interfaceID.inA;
        pkg.inB         =    interfaceID.inB;
        pkg.InputKey    =    interfaceID.InputKey;
        scb_input_mbx.put(pkg);
        pkg.print("MONITOR_IN");
      end
    end
  endtask

endclass