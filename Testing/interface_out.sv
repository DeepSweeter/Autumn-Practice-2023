interface outputData #(
    parameter SBITI = 4
)(
    input Clk
);
    logic CalcBusy, ClkTx, DoutValid;
    logic [SBITI-1:0] DataOut;
endinterface