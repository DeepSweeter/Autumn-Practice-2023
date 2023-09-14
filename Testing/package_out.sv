class dut_package_out #(int SBITI = 4);
    bit CalcBusy, ClkTx, DoutValid;
    bit [SBITI-1:0] DataOut;

    function void print(string tag="");
        $display("T=%0t %s CalcBusy = 0x%0h ClkTx = 0x%0h DoutValid = 0x%0h DataOut = 0x%0h",
        $time,tag, CalcBusy, ClkTx, DoutValid, DataOut);
    endfunction

endclass