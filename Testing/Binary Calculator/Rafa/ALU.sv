module ALU 
  #(parameter INBITS=8)(in_A,
                        in_B,
                        Sel,
                        Flag,
                        Out);
  input [INBITS-1:0]in_A;
  input [INBITS-1:0]in_B;
  input [3:0]Sel;
  output reg [3:0]Flag=4'h0;
  output reg [INBITS-1:0]Out;

  reg [INBITS*2-1:0]m;

  always @(*)
    begin
      case(Sel)
        4'h0:{Flag[1],Out}=in_A+in_B;
        4'h1:{Flag[3],Out}={in_A<in_B,in_A-in_B};	
        4'h2:begin
          m=in_A*in_B;
          Flag[2]=|m[INBITS*2-1:INBITS];
          Out=in_A*in_B;
        end
        4'h3: {Flag[3],Out}={in_A<in_B,in_A/in_B};
        4'h4: Out = {Flag[1],in_A}<<in_B;
        4'h5: Out = {in_A,Flag[1]}>>in_B;
        4'h6: Out = in_A & in_B;
        4'h7: Out = in_A | in_B;
        4'h8: Out = in_A ^ in_B;
        4'h9: Out = !(in_A ^ in_B);
        4'hA: Out = !(in_A & in_B);
        4'hB: Out = !(in_A | in_B);
        default: {Flag,Out}={ 4'h0,{INBITS{1'h0}} };
      endcase
      Flag[0]= Out==0 & (Sel<4'hC);
    end



endmodule