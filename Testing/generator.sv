`ifndef PACKAGE_IN
`include "package_in.sv"
`define PACKAGE_IN
`endif

class generator;
  mailbox drv_mbx;
  event drv_done;
  event gen_done;
  //	event gen_data;
  int num = 5;

  task run();
    for (int i = 0; i < num; i++)begin
	  
      dut_package_in pck = new;
      pck.randomize();
      pck.ValidCmd = 1'b1;
      
      if(i%2 == 0)begin
        pck.InputKey = 1'b1;
      end
      else if(i%2 == 1) begin
        pck.InputKey = 1'b0;
      end
      if(i >= 4)
        pck.InputKey= 1'b0;

      $display("T=%0t [GENERATOR] Loop: %0d/%0d create next item\n\tInputKey=%0h", $time, i, num, pck.InputKey);
      drv_mbx.put(pck);
      @(drv_done);

    end
    $display("T= %0t [GENERATOR] Done generation of %0d items", $time, num);
    ->gen_done;
  endtask


endclass