module FrequencyDivider (Clk,
                         Din,
                         ConfigDiv,
                         Enable,
                         ClkOut,
                         Reset);
  input Clk,Reset,Enable,ConfigDiv;
  input [31:0] Din;
  output reg ClkOut=0;
  reg [31:0] i=0;

  reg [31:0] Div=0;

  always@(posedge Reset)
    begin
      Div<=0;
      ClkOut<=0;
      i<=0;
    end

  always@(posedge Clk)
    if(!Reset && !Enable)
      begin
        ClkOut<=0;
        if(ConfigDiv)
          Div<=Din;
      end

  always@(Clk)
    if(!Reset && Enable)
      begin
        if(i >= Div)
          begin
            ClkOut<=~ClkOut;
            i=0;
          end
        i<=i+1;
      end

endmodule
