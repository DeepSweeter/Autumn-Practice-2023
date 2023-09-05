module Serial_Transceiver #(
    parameter LENGTH = 4
)
(
    input[31:0] din,
    input sample,
    input startTx,
    input reset,
    input clk,
    input clkTx,
    output reg txDone,
    output reg txBusy,
    output reg [LENGTH-1:0] dout
);
    reg [31:0] mem;
    
    integer i = 32 / LENGTH;

    always@(posedge clkTx or posedge clk or posedge reset) begin
        if(reset)begin
            mem = 32'b0;
            txDone = 1'b0;
            txBusy = 1'b0;
            dout = 0;
        end
        else begin
            if(clk) begin
                if(sample && ~startTx)
                    mem <= din;
                else if(~sample && startTx)begin
                    txBusy <= 1'b1;
                end
                if(txDone == 1'b1)
                    txBusy <= 1'b0;
            end
            if(clkTx)begin
                if(i != 0 && txBusy == 1'b1) begin
                    dout <= mem[31:32-LENGTH];
                    mem <= mem << LENGTH;
                    i = i - 1;
                    if(i == 0)
                        txDone <= 1'b1;
                end
            end
        end
    end
    
endmodule