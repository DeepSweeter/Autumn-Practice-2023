`include "Control_RW_Flow.sv"
`include "DecInputKey.sv"

module Controller(Clk,
                  InputKey,
                  ValidCmd,
                  Active,
                  Mode,
                  RW,
                  AccessMem,
                  RWMem,
                  SampleData,
                  TransferData,
                  Busy,
                  TransferDone,
                  Reset);
  
  input Clk,Reset,ValidCmd,RW,TransferDone,InputKey;
  output Active,Mode,AccessMem,RWMem,SampleData,TransferData,Busy;
  wire active,mode;

  DecInputKey decinputkey(Clk,InputKey,ValidCmd,active,mode,Reset);
  
  Control_RW_Flow controlrwflow(Clk,
                                RW,
                                ValidCmd,
                                active,
                                mode,
                                AccessMem,
                                RWMem,
                                SampleData,
                                TransferData,
                                Busy,
                                TransferDone,
                                Reset);

  assign Active=active;
  assign Mode=mode;

endmodule