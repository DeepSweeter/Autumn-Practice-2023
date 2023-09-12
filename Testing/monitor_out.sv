
class monitor_output;
    virtual outputData interfaceOD;
    mailbox scb_output_mbx;

    task run();
        $display("T=%0t [Monitor Output] starting ...", $time);
        forever begin
            @posedge(interfaceOD.Clk) begin
                package_in pkg = new;
                pkg.CalcBusy       <=    interfaceOD.Reset;
                pkg.ClkTx          <=    interfaceOD.ValidCmd;
                pkg.DoutValid      <=    interfaceOD.RW;
                pkg.DataOut        <=    interfaceOD.ConfigDiv;


                scb_output_mbx.put(pck);
                pck.print({"Monitor_Out"});
            end

        end
    endtask

endclass