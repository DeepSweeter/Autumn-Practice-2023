
class monitor_input;
    virtual inputData interfaceID;
    mailbox scb_input_mbx;

    task run();
        $display("T=%0t [Monitor input] starting ...", $time);
        forever begin
            @posedge(interfaceID.Clk) begin
                package_in pkg = new;
                pkg.Reset       <=    interfaceID.Reset;
                pkg.ValidCmd    <=    interfaceID.ValidCmd;
                pkg.RW          <=    interfaceID.RW;
                pkg.ConfigDiv   <=    interfaceID.ConfigDiv;
                pkg.Sel         <=    interfaceID.Sel;
                pkg.Din         <=    interfaceID.Din;
                pkg.Addr        <=    interfaceID.Addr;
                pkg.InA         <=    interfaceID.InA;
                pkg.InB         <=    interfaceID.InB;

                scb_input_mbx.put(pck);
                pck.print({"Monitor_in"});
            end

        end
    endtask

endclass