module DUT;
    
    reg [31:0] din;
    reg sample, startTx, reset, clk, clkTx;
    wire txDone, txBusy;
    wire [4:0] dout;


    Serial_Transceiver #(5) st_dut(din, sample, startTx, reset, clk, clkTx, txDone, txBusy, dout);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, st_dut);
        $dumpvars(1, st_dut.mem);
    end
    initial begin
        #0 clk = 1'b0;
        forever #10 clk =~ clk;
       
    end

    initial begin
        #0 clkTx = 1'b0;
        forever #5 clkTx =~ clkTx;
    end

    initial
        begin
            #0 din = 32'hf10f10f1; sample = 1'b0; startTx= 1'b0;  reset = 1'b1;
            #5 sample = 1'b1; reset = 1'b0;
            #20 startTx = 1'b1; sample = 1'b0;
           // #43 reset = 1'b1;
            #200 $finish;
        end

endmodule