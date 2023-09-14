`ifndef INTERFACE_OUT
  `include "interface_out.sv"
	`define INTERFACE_OUT
`endif

`ifndef PACKAGE_OUT
  `include "package_out.sv"
	`define PACKAGE_OUT
`endif

class monitor_output;
    virtual outputData interfaceOD;
    mailbox scb_output_mbx;

    task run();
      $display("T=%0t [MONITOR OUTPUT] starting ...", $time);
        forever begin
          @(posedge interfaceOD.Clk);
          if(1) begin
                dut_package_out pkg = new;
                pkg.CalcBusy       =    interfaceOD.CalcBusy;
                pkg.ClkTx          =    interfaceOD.ClkTx;
                pkg.DoutValid      =    interfaceOD.DoutValid;
                pkg.DataOut        =    interfaceOD.DataOut;


          scb_output_mbx.put(pkg);
            pkg.print({"MONITOR_OUTPUT"});
            
          end
        end
    endtask

endclass