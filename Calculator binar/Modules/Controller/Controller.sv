module DecInputKey(
    input inputKey,
    input validCmd,
    input reset,
    input clk,
    output reg active,
    output reg mode
);
    reg [4:0] mem;
    reg [2:0] i = 3'd0;

    always@(posedge clk or posedge reset)begin
        if(reset) begin
            mem = 5'b0;
            i = 3'b0;
            active = 1'b0;
            mode = 1'b0;
        end
        else begin
            if(validCmd) begin
                if(i < 5)begin
                   mem[i] = inputKey;
                   i = i + 1;
                end
            end
            if(i == 5) begin
                if(mem[3:0]==4'b0101) begin
                    active <= 1'b1;
                    mode <= mem[4];
                    if(validCmd)
                        mode <= inputKey;
                end

                end
        end
    end

endmodule

module Control_RW_Flow (
    input validCmd,
    input RW,
    input reset,
    input clk,
    input txDone,
    input active,
    input mode,
    output reg AccessMem,
    output reg RWMem,
    output reg SampleData,
    output reg TxData,
    output reg Busy  
);


    
endmodule