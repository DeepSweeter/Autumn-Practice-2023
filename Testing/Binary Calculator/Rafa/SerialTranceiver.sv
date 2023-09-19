module SerialTranceiver 
  #(parameter SBITI=3,parameter DinLENGTH=32)(Clk,
                                              ClkTx,
                                              DataIn,
                                              Sample,
                                              StartTx,
                                              TxDone,
                                              Reset,
                                              TxBusy,
                                              Dout);

  input Clk,ClkTx,Reset,Sample,StartTx;
  input [DinLENGTH-1:0] DataIn;
  output reg TxDone=0,TxBusy=0;
  output reg [SBITI-1:0] Dout;
  reg done=1'b1;//for 1 more clk active

  reg [DinLENGTH-1:0] Din=0;
  reg[DinLENGTH-1:0] i=0;

  initial
    Dout<={SBITI{1'bz}};

  always@(posedge Reset)
    begin
      done<=1'b1;
      Din<=0;
      TxDone<=1'b0;
      TxBusy<=1'b0;
      Dout<={SBITI{1'bz}};
      i<=0;
    end

  always@(posedge Clk)
    if(~Reset)
      begin
        if(Sample)
          Din<=DataIn;
        else
          begin
            if(StartTx && !TxDone)//transfer begins
              TxBusy<=1'b1;
            else//transfer done
              begin
                if(done)//1 more clk active
                  TxDone<=1'b0;
                done<=1'b1;
                TxBusy<=1'b0;
                Dout<={SBITI{1'bz}};
              end
          end
      end

  always@(posedge ClkTx)
    begin 
      if(i*SBITI>DinLENGTH)//done
        begin
          i=0;
          TxDone<=1'b1;
          //TxBusy<=1'b0;
          //Dout<={SBITI{1'bz}};
        end
      if(StartTx&~Sample&~TxDone)//on going
        begin
          done<=1'b0;
          TxBusy<=1'b1;
          {Dout,Din}<={Dout,Din}<<SBITI;
          i=i+1;
        end
      else//finished
        begin
          TxBusy<=1'b0;
          Dout<={SBITI{1'bz}};
        end
    end

endmodule
