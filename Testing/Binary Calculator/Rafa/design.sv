`include "Controller.sv"
`include "FrequencyDivider.sv"
`include "SerialTranceiver.sv"
`include "ALU.sv"
`include "Mux.sv"
`include "Memory.sv"
`include "Concatenator.sv"

module BinaryCalculator
  #(parameter INBITS=8,
    parameter WIDTH=8,
    parameter SBITI=4)(Clk,
                        InputKey,
                        ValidCmd,
                        InA,
                        InB,
                        RW,
                        Addr,
                        Sel,
                        Din,
                        ConfigDiv,
                        CalcBusy,
                        ClkTx,
                        DoutValid,
                        DataOut,
                        Reset);
  `define DinLENGTH 8+3*INBITS

  input Clk,Reset,ValidCmd,RW,ConfigDiv,InputKey;
  input[WIDTH-1:0]Addr;
  input[3:0]Sel;
  input[INBITS-1:0]InA,InB;
  input[31:0]Din;
  output CalcBusy,ClkTx,DoutValid;
  output [SBITI-1:0]DataOut;
  wire Active,SampleData,TransferData,Busy,TransferDone;
  wire ResetTmp,CtrlModeTmp,CtrlRWMemTmp,CtrlAccessMemTmp,RWTmp;
  wire[INBITS-1:0]MuxInATmp,MuxInBTmp,AluOutTmp;
  wire[3:0]MuxSelTmp;
  wire[3:0]AluFlagTmp;
  wire[`DinLENGTH-1:0]ConcatOutTmp,MemDoutTmp,TxDinTmp;

  Controller ctrl(Clk,
                  InputKey,
                  ValidCmd,
                  Active,
                  CtrlModeTmp,
                  RWTmp,
                  CtrlAccessMemTmp,
                  CtrlRWMemTmp,
                  SampleData,
                  TransferData,
                  CalcBusy,
                  TransferDone,
                  Reset);

  Mux #(.INBITS(INBITS))	 M1(InA,{INBITS{1'h0}},ResetTmp,MuxInATmp);
  Mux #(.INBITS(INBITS)) 	 M2(InB,{INBITS{1'h0}},ResetTmp,MuxInBTmp);
  Mux #(.INBITS(4)) 		 M3(Sel,4'h0,ResetTmp,MuxSelTmp);
  Mux #(.INBITS(`DinLENGTH)) M4(ConcatOutTmp,MemDoutTmp,CtrlModeTmp,TxDinTmp);

  ALU #(INBITS) alu(MuxInATmp,MuxInBTmp,MuxSelTmp,AluFlagTmp,AluOutTmp);

  Concatenator #(INBITS) concat(MuxInATmp,MuxInBTmp,AluOutTmp,MuxSelTmp,AluFlagTmp,ConcatOutTmp);

  Memory #(WIDTH,
           `DinLENGTH) mem(Clk,
                           ConcatOutTmp,
                           Addr,
                           CtrlRWMemTmp,
                           CtrlAccessMemTmp,
                           ResetTmp,
                           MemDoutTmp);
  FrequencyDivider freqdiv(Clk,Din,ConfigDiv,Active,ClkTx,ResetTmp);

  SerialTranceiver #(SBITI,
                     `DinLENGTH) sertx(Clk,
                                       ClkTx,
                                       TxDinTmp,
                                       SampleData,
                                       TransferData,
                                       TransferDone,
                                       ResetTmp,
                                       DoutValid,
                                       DataOut);

  assign RWTmp=RW&Active;
  assign ResetTmp=Reset&~Active;

endmodule