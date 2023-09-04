module DUT;

  reg [7:0] a, b, c;
  reg [3:0] d, e;
  wire [31:0] dout;
  

  Concatenator c_dut(a, b, c, d, e, dout);

  
  task write(input [7:0] at, input [7:0]bt, input[7:0] ct, input [3:0] dt, input [3:0] et);
      begin
        a = at;
        b = bt;
        c = ct;
        d = dt;
        e = et;
      end
    endtask


  // Close file and finish simulation
initial begin
    $dumpfile("dump.vcd"); // Save simulation data in VCD file
  $dumpvars(1);
  end

  initial begin
    #3 write(8'h10, 8'h2, 8'h12, 4'h7, 4'h9);
    #23 write(8'h14, 8'h13, 8'h10, 4'h4, 4'h7);

    #100 $finish;
  end

endmodule
