module Frequency_Divider(
    input[31:0] din,
    input configDiv,
    input reset,
    input clk,
    input enable,
    output reg clkOut
);

    reg [31:0] mem;
    reg [31:0] counter = 32'b0;
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            mem <= 32'b1;
            clkOut <= 1'b0;
        end
        else begin
            if(~enable)begin
                clkOut <= 1'b0;
                if(configDiv)
                    mem <= din; // Esantionarea are loc doar cand enable = 0 si configDiv = 1
            end
            else begin
                //Logica de functionare
                counter <= counter + 32'b1; 
                if(counter >= (mem - 1))
                    counter <= 32'b0;
                clkOut <= (counter < (mem/2))? 1'b1: 1'b0;
                //Ex: pentru din = 4
                //      clkOut = 1 pentru primele 2 secvente de clk (counter < (mem/2))
                //      clkOut = 0 pentru urmatoarele 2 secvente de clk(counter >=(mem/2))
                //                       dupa care se reseteaza counter
            end

        end
    end

endmodule