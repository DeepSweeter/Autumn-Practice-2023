class dut_package_intern;
    bit SampleData, TransferData;

    function void print(string tag="");
      $display("T=%0t %s SampleData = 0x%0h TransferData = 0x%0h ",
        $time,tag, SampleData, TransferData);
    endfunction

endclass