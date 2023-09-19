module Memory 
  #(parameter WIDTH=8, DinLENGTH=32)(Clk,
                                     Din,
                                     Addr,
                                     R_W,
                                     Valid,
                                     Reset,
                                     Dout);
  input Clk,Reset,Valid,R_W;
  input [DinLENGTH-1:0] Din;
  input [WIDTH-1:0] Addr;
  output reg [DinLENGTH-1:0] Dout;

  integer i;
  reg [DinLENGTH-1:0] mem [0:(1<<WIDTH)-1];

  always@(posedge Reset)
    begin
      for(i=0; i<(1<<WIDTH); i=i+1)
        mem[i]<=0;
      Dout<={DinLENGTH{1'bz}};
    end

  always@(posedge Clk)
    begin
      if(!Reset && Valid)
        begin
          if(R_W)
            mem[Addr]<=Din;
          else
            Dout<=mem[Addr];
        end
      else
        Dout<={DinLENGTH{1'bz}};
    end

endmodule
