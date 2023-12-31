module Memory #(
    parameter WIDTH = 32,
    parameter DEPTH= 8
) (
    input [WIDTH-1:0] din,
    input [DEPTH-1:0] addr,
    input RW,
    input valid,
    input reset,
    input clk,
    output reg [WIDTH-1:0] dout
);

    reg [WIDTH-1:0] mem [0:(1<<DEPTH)-1];
    reg [8:0] i;

    always@(posedge reset or posedge clk)
        begin
            if(reset)begin
                for(i = 0; i < (1<<DEPTH); i= i + 1)
                    mem[i] <= 0;
                dout <= 0;
            end
            else begin
                if(clk) begin
                    if(valid)begin
                        if(RW)   //RW = 1 => Write in memory 
                            mem[addr] <= din;
                        else // RW = 0 => Read from memory
                            dout <= mem[addr];
                    end
                    else
                        dout<= 32'b0;
                end
            end
        end
    
endmodule