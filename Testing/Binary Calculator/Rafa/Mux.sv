module Mux
  #(parameter INBITS=8)(in_A,
                        in_B,
                        Sel,
                        Out);
  input [INBITS-1:0] in_A;
  input [INBITS-1:0] in_B;
  input Sel;
  output [INBITS-1:0] Out;

  assign Out = Sel ? in_B:in_A;

endmodule
