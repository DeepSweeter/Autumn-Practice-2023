module DUT;
    
    reg validCmd, RW, reset, clk, txDone, active, mode;
    wire AccessMem, RWMem, SampleData, TxData, Busy;

    Control_RW_Flow crwf_dut(validCmd, RW, reset, clk, txDone, active, mode,
                             AccessMem, RWMem, SampleData, TxData, Busy);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, crwf_dut);
        $dumpvars(1, crwf_dut.cs);
        $dumpvars(1, crwf_dut.ns);

    end
    initial begin
        #0 clk = 1'b0;
        forever #5 clk =~ clk;
    end

        task write(input reg[4:0] data);
            begin
                validCmd = data[4];
                active = data[3];
                mode = data[2];
                RW = data[1];
                txDone = data[0];
            end
        endtask

    initial
        begin
            #0 reset = 1'b1; write(5'b00_000);
            #13 reset = 1'b0; write(5'b11_100);
            #10 write(5'b11_100);
            #10 write(5'b11_100);
            #20 write(5'b11_101);
            #10 write(5'b11_110);
            #30 write(5'b00_000);
            #10 write(5'b11_000);
            #40 write(5'b11_001);
            #10 write(5'b01_000);


            #200 $finish;
        end

endmodule