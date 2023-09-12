
class generator;
    mailbox drv_mbx;
    event drv_done;
    int num = 13;

    task run();
        for (int i = 0; i < num; i++)begin
            dut_package_in pck = new;
            pck.randomize();
            $display("T=%0t [Generator] Loop: %0d/%0d create next item", $time, i+1, num);
            drv_mbx.put(pck);
            @(drv_done);
        end
        $display("T= %0t [Generator] Done generation of %0d items", $time, num);
    endtask
    

endclass