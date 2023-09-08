module DUT;
    
    reg clk, reset, inputKey, RW, validCmd, configDiv;
    reg [7:0] inA, inB, ADDR;
    reg [3:0] aluOp;
    reg [31:0] freqDivInput;

    wire calcBusy, DoutValid, clkTxOut;
    wire DataOut; //trebuie modificat in functie de parametrul LENGTH de la Serial_Transceiver

    top dut(
        //Inputs
        .clk(clk),
        .reset(reset),
        .inA(inA),
        .inB(inB),
        .aluOp(aluOp),
        .inputKey(inputKey),
        .RW(RW),
        .validCmd(validCmd),
        .ADDR(ADDR),
        .freqDivInput(freqDivInput),
        .configDiv(configDiv),
        //Ouputs
        .calcBusy(calcBusy),
        .DoutValid(DoutValid), 
        .DataOut(DataOut),
        .clkTxOut(clkTxOut)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, dut);
        $dumpvars(1, dut.mem.mem[4]);


    end
    initial begin
        #0 clk = 1'b0;
        forever #5 clk =~ clk;
    end

    initial
        begin
            #0 reset = 1'b1; inputKey = 1'b0; validCmd = 1'b0;
            #13 reset = 1'b0; validCmd = 1'b1; inputKey = 1'b1; ADDR = 8'd4; freqDivInput = 32'd4; configDiv = 1'b1; RW = 1'b1; inA = 8'd7; inB = 8'd8; aluOp = 4'b0;
            #10 inputKey = 1'b0;
            #10 inputKey = 1'b1;
            #10 inputKey = 1'b0;
            #10 inputKey = 1'b1;// Mode 1 Write
            #20 RW = 1'b0; //Mode 1 Read
            // #137 inputKey = 1'b0;
            // #290 validCmd = 1'b0;
            


            #3000 $finish;
        end

endmodule