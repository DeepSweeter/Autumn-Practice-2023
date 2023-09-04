module DUT;

  reg [7:0] a, b;
  reg [3:0] sel;
  wire [7:0] dout;
  wire [3:0] flags;
  

  ALU alu_dut(a, b, sel, dout, flags);

  
  task write(input [7:0] at, input [7:0]bt, input [3:0] selt);
      begin
        a = at;
        b = bt;
        sel = selt;
      end
    endtask


    // Close file and finish simulation
    initial begin
        $dumpfile("dump.vcd"); // Save simulation data in VCD file
    $dumpvars(1);
  end

  initial begin
    #5 write(8'd250, 8'd8, 4'h0); //ADD overflow
    #5 write(8'd0, 8'd0, 4'h0); //ADD zero flag
    #5 write(8'd5, 8'd7, 4'h0); //ADD result 12

    #5 write(8'd5, 8'd8, 4'h1); //SUB A < B underflow
    #5 write(8'd8, 8'd8, 4'h1); //SUB zero flag
    #5 write(8'd9, 8'd5, 4'h1); //SUB result 4

    #5 write(8'd16, 8'd16, 4'h2); //MUL overflow
    #5 write(8'd0, 8'd0, 4'h2); //MUL zero flag
    #5 write(8'd6, 8'd4, 4'h2); // MUL result 24

    #5 write(8'd3, 8'd8, 4'h3); //DIV underflow
    #5 write(8'd250, 8'd0, 4'h3); //DIV error case
    #5 write(8'd9, 8'd3, 4'h3); // DIV result 3

    #5 write(8'b1100_0010, 8'd2, 4'h4); //SHL result 8 plus Carryflag = 1
    #5 write(8'd255, 8'h8, 4'h4); //SHL zero flag

    #5 write(8'b0010_0010, 8'd2, 4'h5); //SHR result 8 plus Carryflag = 1
    #5 write(8'd255, 8'h8, 4'h5); //SHR zero flag

    #5 write(8'b1010_1001, 8'b0000_1000, 4'h6); //AND result 8

    #5 write(8'b0000_0001, 8'b0000_1000, 4'h7); //OR result 9

    #5 write(8'b0000_1001, 8'b0000_1000, 4'h8); //XOR result 1

    #5 write(8'b1010_1001, 8'b0101_0111, 4'h9); //NXOR result 1

    #5 write(8'b1111_0111, 8'b1111_1111, 4'ha); //NAND result 8

    #5 write(8'b1010_1001, 8'b0000_1000, 4'hb); //NOR result 86

    #5 write(8'b1010_1001, 8'b0000_1000, 4'hc); //Default



    #200 $finish;
  end

endmodule
