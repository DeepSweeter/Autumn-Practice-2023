module MUX #(
    parameter LENGTH = 8
) 
(
    input [LENGTH-1:0] inA,
    input [LENGTH-1:0] inB,
    input sel,
    output [LENGTH-1:0] dout
);

    assign dout = sel? inB : inA;
    
endmodule