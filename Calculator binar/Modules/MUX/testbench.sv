module DUT;
    
    reg [9:0] inA, inB;
    reg sel;
    wire [9:0] dout;

    MUX #(10) mux_dut(inA, inB, sel, dout);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
    end

    initial
        begin
            #0 inA = 7; inB = 9; sel = 0;
            #5 sel = 1;


            #100 $finish;
        end

endmodule