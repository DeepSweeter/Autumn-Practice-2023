module DUT;
    
    reg [31:0] din;
    reg [7:0] addr;
    reg rw, valid, reset, clk;
    wire [31:0] dout;

    integer i;

    Memory #(32, 8) memory_dut(din, addr, rw, valid, reset, clk, dout);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, memory_dut);
        for(i = 0; i<=255; i= i+1)
            $dumpvars(1, memory_dut.mem[i]);
    end
    initial begin
        #0 clk = 1'b0;
        forever #5 clk =~ clk;
    end

    initial
        begin
            #0 din = 32'h7; addr = 8'h4; rw= 1'b0; valid = 1'b1; reset = 1'b1;
            #10 reset = 1'b0;
            #9 rw = 1'b0;
            #3 rw = 1'b1;
            #10 rw = 1'b0; din= 32'h10; addr=8'h7; valid = 1'b0;
            #10 valid = 1'b1;
            #5 reset = 1'b1;

            


            #100 $finish;
        end

endmodule