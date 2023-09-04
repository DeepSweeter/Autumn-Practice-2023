module Concatenator(
  input [7:0] a,
  input [7:0] b,
  input [7:0] c,
  input [3:0] d,
  input [3:0] e,
  output [31:0] dout
);
	
  assign dout = {e, d, c, b, a};

endmodule