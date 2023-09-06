module DUT;
    
    reg [31:0] din;
    reg configDiv, reset, clk, enable;
    wire clkOut;


    Frequency_Divider  fd_dut(din, configDiv, reset, clk, enable, clkOut);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, fd_dut);
        $dumpvars(1, fd_dut.mem);
    end
    initial begin
        #0 clk = 1'b0;
        forever #6 clk =~ clk;
       
    end



    initial
        begin
            #0 din = 32'd6; configDiv = 1'b0; enable= 1'b0;  reset = 1'b1;
            #14 reset = 1'b0; configDiv = 1'b1;
            #24 enable = 1'b1; configDiv = 1'b0;
            #200 $finish;
        end

endmodule