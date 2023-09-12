class driver;
    virtual inputData interfaceID;
    event drv_done;
    mailbox drv_mbx;

    task run();
        $display("T=%0t [Driver] starting... ", $time);
        @(posedge interfaceID.Clk);

        forever begin
            dut_package_in dpi;

            $display("T=%0t [Driver] waiting for item ...", $time);
            drv_mbx.get(dpi);
            dpi.print("Driver");

            interfaceID.Reset <= dpi.Reset;
            interfaceID.ValidCmd <= dpi.ValidCmd;
            interfaceID.RW <= dpi.RW;
            interfaceID.ConfigDiv <= dpi.ConfigDiv;
            interfaceID.Sel <= dpi.Sel;
            interfaceID.Din <= dpi.Din;
            interfaceID.Addr <= din.Addr;
            interfaceID.InA <= din.InA;
            interfaceID.InB <= din.InB;

            ->drv_done;


        end
    endtask

endclass