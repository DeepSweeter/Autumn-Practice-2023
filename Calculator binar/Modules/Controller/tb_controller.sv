module DUT;
    
    reg inputKey, validCmd, reset, clk, RW, txDone;
    wire active, mode, AccessMem, RWMem, SampleData, TxData, Busy;

    Controller controller_dut(inputKey, validCmd, clk, reset, RW, txDone,
                             active, mode, AccessMem, RWMem, SampleData, TxData, Busy);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, controller_dut);


    end
    initial begin
        #0 clk = 1'b0;
        forever #5 clk =~ clk;
    end

    initial
        begin
            #0 reset = 1'b1; inputKey = 1'b0; validCmd = 1'b0;
            #13 reset = 1'b0; validCmd = 1'b1; inputKey = 1'b1;
            #10 inputKey = 1'b0;
            #10 inputKey = 1'b1;
            #10 inputKey = 1'b0;
            #10 inputKey = 1'b1; RW= 1'b0; txDone =1'b0;// Mode 1
            
            #47 validCmd = 1'b0; txDone = 1'b1;

            // #10 reset = 1'b1;
            // #13 reset = 1'b0; validCmd = 1'b1; inputKey = 1'b1;
            // #10 inputKey = 1'b0;
            // #10 inputKey = 1'b1;
            // #10 inputKey = 1'b0;
            // #10 inputKey = 1'b0; // Mode 0
            // #7 validCmd = 1'b0;

            // #10 reset = 1'b1;
            // #13 reset = 1'b0; validCmd = 1'b1; inputKey = 1'b1;
            // #10 inputKey = 1'b0;
            // #10 inputKey = 1'b0;
            // #10 inputKey = 1'b1;
            // #10 inputKey = 1'b0; // Incorrect sequence
            // #7 validCmd = 1'b0;


            


            #200 $finish;
        end

endmodule