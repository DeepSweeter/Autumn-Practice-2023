module DUT;
    
    reg inputKey, validCmd, reset, clk;
    wire active, mode;

    DecInputKey decIK_dut(inputKey, validCmd, reset, clk, active, mode);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, decIK_dut);
        $dumpvars(1, decIK_dut.mem);
        $dumpvars(1, decIK_dut.i);

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
            #10 inputKey = 1'b1; // Mode 1
            #10 inputKey = 1'b0;
            #10 inputKey = 1'b1;
            #10 validCmd = 1'b1;
            #27 validCmd = 1'b0;

            #10 reset = 1'b1;
            #13 reset = 1'b0; validCmd = 1'b1; inputKey = 1'b1;
            #10 inputKey = 1'b0;
            #10 inputKey = 1'b1;
            #10 inputKey = 1'b0;
            #10 inputKey = 1'b0; // Mode 0
            #7 validCmd = 1'b0;

            #10 reset = 1'b1;
            #13 reset = 1'b0; validCmd = 1'b1; inputKey = 1'b1;
            #10 inputKey = 1'b0;
            #10 inputKey = 1'b0;
            #10 inputKey = 1'b1;
            #10 inputKey = 1'b0; // Incorrect sequence
            #7 validCmd = 1'b0;


            


            #200 $finish;
        end

endmodule