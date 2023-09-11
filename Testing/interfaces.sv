interface inputData #(
    parameter INBITS=8,
    parameter WIDTH=8
)
(input Clk);
	logic Reset;
  	logic ValidCmd;
  	logic RW;
  	logic ConfigDiv;
  	logic InputKey;
    logic [3:0] Sel;
    logic [31:0] Din;
    logic [WIDTH-1:0] Addr;
    logic [INBITS-1:0] InA, InB;


endinterface

interface outputData #(
    parameter SBITI = 4
)(
    input Clk
);
    logic CalcBusy, ClkTx, DoutValid;
    logic [SBITI-1:0] DataOut;
endinterface
  