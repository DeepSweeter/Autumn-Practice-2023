`ifndef PACKAGE_IN
  `include "package_in.sv"
	`define PACKAGE_IN
`endif

class generator;
    mailbox drv_mbx;
    event drv_done;
  	event gen_done;
  //	event gen_data;
    int num = 1;

    task run();
        for (int i = 0; i < num; i++)begin
          
            dut_package_in pck = new;
            pck.randomize();
          $display("T=%0t [GENERATOR] Loop: %0d/%0d create next item", $time, i+1, num);
            drv_mbx.put(pck);
            @(drv_done);
          
        end
      $display("T= %0t [GENERATOR] Done generation of %0d items", $time, num);
      ->gen_done;
    endtask
    

endclass