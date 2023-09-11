class dut_package_in;
    rand bit [7:0] inA;
    rand bit [7:0] inB;
    rand bit [3:0] Sel;
    rand bit [31:0] Din;
    rand bit [7:0] Addr;
    bit InputKey, ValidCmd, RW, ConfigDiv;

    function void print(string tag="");
        $display("T=%0t %s inA = 0x%0h inB = 0x%0h sel = 0x%0h Din = 0x%0h, Addr = 0x%0h",
        $time, tag, inA, inB, Sel, Din, Addr);
    endfunction

endclass


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