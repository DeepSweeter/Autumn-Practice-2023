module Concatenator
  #(parameter INBITS=8)
  (A,B,C,D,E,Out);
  input [INBITS-1:0]A;
  input [INBITS-1:0]B;
  input [INBITS-1:0]C;
  input [3:0]D;
  input [3:0]E;
  output [INBITS*3+8-1:0]Out;
  
  assign Out={E,D,C,B,A};
  
endmodule
