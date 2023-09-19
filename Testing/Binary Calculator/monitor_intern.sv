`ifndef INTERFACE_INTERN
  `include "interface_intern.sv"
	`define INTERFACE_INTERN
`endif

`ifndef PACKAGE_INTERN
  `include "package_intern.sv"
	`define PACKAGE_INTERN
`endif

class monitor_intern;
    virtual interface_Intern interfaceInt;
    mailbox scb_intern_mbx;

    task run();
      $display("T=%0t [MONITOR INTERN] starting ...", $time);
        forever begin
          @(posedge interfaceInt.Clk);
          if(1) begin
                dut_package_intern pkg = new;
                pkg.SampleData       =    interfaceInt.SampleData;
                pkg.TransferData          =    interfaceInt.TransferData;


          scb_intern_mbx.put(pkg);
            pkg.print({"MONITOR_INTERN"});
            
          end
        end
    endtask

endclass