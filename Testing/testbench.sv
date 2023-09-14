`define INBITS 8
`define WIDTH 8
`define SBITS 4

`define DIV 3
`define DinLENGTH 8+3*INBITS

`ifndef TEST
  `include "test.sv"
	`define TEST
`endif
  



module test();
   	reg Clk;//,Reset,ValidCmd,RW,ConfigDiv,InputKey;
//   reg[31:0]Din;
//   reg[3:0]Sel;
//   reg[`INBITS-1:0]InA,InB;
//   reg[`WIDTH-1:0]Addr;
//   wire CalcBusy,ClkTx,DoutValid;
//   wire[`SBITS-1:0]DataOut;

  

  inputData #(.INBITS(`INBITS), .WIDTH(`WIDTH)) iData (Clk);
  outputData #(.SBITI(`SBITS)) oData(Clk); 
  interface_Intern iIntern(Clk);
  test t0;
  
  
  

 BinaryCalculator 
  #(`INBITS,`WIDTH,`SBITS) bc (Clk,
                               iData.InputKey,
                               iData.ValidCmd,
                               iData.inA,
                               iData.inB,
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
  
 
    assign iIntern.SampleData = bc.SampleData;
    assign iIntern.TransferData = bc.TransferData;
 

  initial
    begin
      $dumpfile("dump.vcd"); 
      $dumpvars(0,bc);
//       $dumpvars(1, iData);
//       $dumpvars(1, oData);
      #0//Init values
      iData.ValidCmd = 1'b1;
      iData.InputKey = 1'b1;
      iData.Reset = 1'b0;
      #10
      iData.InputKey = 1'b0;
      #10
      iData.InputKey =1'b1;
      #10
      iData.InputKey =1'b0;
      
      #10 iData.InputKey = 1'b0; iData.ConfigDiv = 1'b1; iData.RW = 1'b1;
      
      #10
	 
      t0 = new;
      t0.e0.interfaceID = iData;
      t0.e0.interfaceOD = oData;
      t0.e0.interfaceInt= iIntern;
      
      fork
      	t0.run();
      join_none
      @(t0.e0.g0.gen_done);
      #400
      $finish(1);
      
//       iData.Reset=1'b0;
//       iData.ValidCmd=1'b0;
//       iData.RW=1'b0;
//       iData.ConfigDiv=1'b0;
//       iData.InputKey=1'b0;
//       iData.Din=32'h0;
//       iData.Sel=4'h0;
//       iData.InA=`INBITS'h4;
//       iData.InB=`INBITS'h4;
//       iData.Addr=`WIDTH'h0;

//       #20//config clk divider
//       iData.Din=32'h`DIV;
//       iData.ConfigDiv=1'b1;
//       #10
//       iData.ConfigDiv=1'b0;

//       #20//input key (mode 1)
//       iData.ValidCmd=1'b1;
//       iData.InputKey=1'b1;
//       #10
//       iData.InputKey=1'b0;
//       #10
//       iData.InputKey=1'b1;
//       #10
//       iData.InputKey=1'b0;
//       #10
//       iData.InputKey=1'b1;
//       #20
//       iData.ValidCmd=1'b0;


//       #30//start write cmd
//       iData.RW=1'b1;
//       iData.ValidCmd=1'b1;
//       #10
//       iData.ValidCmd=1'b0;


//       #30//start read cmd
//       iData.RW=1'b0;
//       iData.ValidCmd=1'b1;
//       #10
//       iData.ValidCmd=1'b0;


// //       #(60+ `DinLENGTH*10+20*`DIV)
//       #360//wait finish read cmd
//       #40//start mode 0
//       iData.RW=1'b0;
//       iData.InputKey=1'b0;
//       iData.ValidCmd=1'b1;
//       #10
//       iData.ValidCmd=1'b0;


//       #360//wait finish mode 0
//       #40//start mode 0
//       iData.RW=1'b0;
//       iData.Addr=`WIDTH'h1;
//       iData.InputKey=1'b0;
//       iData.ValidCmd=1'b1;
//       #10
//       iData.ValidCmd=1'b0;

//       #145//iData.Reset
//       iData.Reset=1'b1;
//       #10
//       iData.Reset=1'b0;

	
    end

endmodule