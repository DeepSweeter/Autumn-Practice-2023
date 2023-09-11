`define INBITS 8
`define WIDTH 8
`define SBITS 4

`define DIV 3
`define DinLENGTH 8+3*INBITS

`include "interfaces.sv"
`include "generator.sv"
module test();
   reg Clk;//Reset,ValidCmd,RW,ConfigDiv,InputKey;
  // reg[31:0]Din;
  // reg[3:0]Sel;
  // reg[`INBITS-1:0]InA,InB;
  // reg[`WIDTH-1:0]Addr;
  // wire CalcBusy,ClkTx,DoutValid;
  // wire[`SBITS-1:0]DataOut;

  

 inputData #(.INBITS(`INBITS), .WIDTH(`WIDTH)) iData (Clk);
 outputData #(.SBITS(`SBITS)) oData(Clk); 

 BinaryCalculator 
  #(`INBITS,`WIDTH,`SBITS) bc (Clk,
                               iData.InputKey,
                               iData.ValidCmd,
                               iData.InA,
                               iData.InB,
                               iData.RW,
                               iData.Addr,
                               iData.Sel,
                               iData.Din,
                               iData.ConfigDiv,
                               oData.CalcBusy,
                               oData.ClkTx,
                               oData.DoutValid,
                               oData.DataOut,
                               iData.Reset);                        

  initial
    begin
      Clk=1'b0;
      forever #5 Clk = ~Clk;
    end

  initial
    begin
      $dumpfile("dump.vcd"); 
      $dumpvars(0,bc);
      #0//Init values
      iData.Reset=1'b0;
      iData.ValidCmd=1'b0;
      iData.RW=1'b0;
      ConfigDiv=1'b0;
      iData.InputKey=1'b0;
      iData.Din=32'h0;
      iData.Sel=4'h0;
      iData.InA=`INBITS'h4;
      iData.InB=`INBITS'h4;
      iData.Addr=`WIDTH'h0;

      #20//config clk divider
      iData.Din=32'h`DIV;
      iData.ConfigDiv=1'b1;
      #10
      iData.ConfigDiv=1'b0;

      #20//input key (mode 1)
      iData.ValidCmd=1'b1;
      iData.InputKey=1'b1;
      #10
      iData.InputKey=1'b0;
      #10
      iData.InputKey=1'b1;
      #10
      iData.InputKey=1'b0;
      #10
      iData.InputKey=1'b1;
      #20
      iData.ValidCmd=1'b0;


      #30//start write cmd
      iData.RW=1'b1;
      iData.ValidCmd=1'b1;
      #10
      iData.ValidCmd=1'b0;


      #30//start read cmd
      iData.RW=1'b0;
      iData.ValidCmd=1'b1;
      #10
      iData.ValidCmd=1'b0;


//       #(60+ `DinLENGTH*10+20*`DIV)
      #360//wait finish read cmd
      #40//start mode 0
      iData.RW=1'b0;
      iData.InputKey=1'b0;
      iData.ValidCmd=1'b1;
      #10
      iData.ValidCmd=1'b0;


      #360//wait finish mode 0
      #40//start mode 0
      iData.RW=1'b0;
      iData.Addr=`WIDTH'h1;
      iData.InputKey=1'b0;
      iData.ValidCmd=1'b1;
      #10
      iData.ValidCmd=1'b0;

      #145//iData.Reset
      iData.Reset=1'b1;
      #10
      iData.Reset=1'b0;


      #120
      $finish(1);	
    end

endmodule