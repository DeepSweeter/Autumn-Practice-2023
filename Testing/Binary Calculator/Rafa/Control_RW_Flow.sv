module Control_RW_Flow(Clk,
                       RW,
                       ValidCmd,
                       Active,
                       Mode,
                       AccessMem,
                       RWMem,
                       SampleData,
                       TxData,
                       Busy,
                       TxDone,
                       Reset);
  input Clk,Reset,ValidCmd,RW,TxDone,Active,Mode;
  output reg AccessMem=0,RWMem=0,SampleData=0,TxData=0,Busy=0;

  `define IDLE 3'h0
  `define READMEM 3'h1
  `define SAMPLE1 3'h2
  `define TRANSFER 3'h3
  `define WRITEMEM 3'h4
  `define SAMPLE0 3'h5

  reg [2:0]state=`IDLE;

  always@(posedge Reset)
    begin
      AccessMem <=0;
      RWMem <=0;
      SampleData <=0;
      TxData<=0;
      Busy <= 0;
      state<=0;
    end

  always@(posedge Clk)
    if(!Reset)
      case({state})
        `IDLE:
          begin
            if(ValidCmd && Active && Mode && !RW)
              begin
                state<=`READMEM;
                AccessMem<=1'b1;
                RWMem<=1'b0;
                Busy<=1'b1;
              end
            if(ValidCmd && Active && Mode && RW)
              begin
                state<=`WRITEMEM;
                AccessMem<=1'b1;
                RWMem<=1'b1;
                Busy<=1'b1;
              end
            if(ValidCmd && Active && !Mode)
              begin
                state<=`SAMPLE0;
                SampleData<=1'b1;
                Busy<=1'b1;
              end
          end
        `READMEM:
          if(Active && Mode && !TxDone)
            begin
              state<=`SAMPLE1;
              SampleData<=1'b1;
            end
        `SAMPLE1:
          if(Active && !TxDone)
            begin
              state<=`TRANSFER;
              SampleData<=1'b0;
              TxData<=1'b1;
            end
        `TRANSFER:
          if(TxDone)
            begin
              state<=`IDLE;
              TxData<=0;
              Busy<=0;
              SampleData<=0;
              RWMem<=1'b0;
              AccessMem<=1'b0;
            end
        `WRITEMEM:begin
          state<=`IDLE;
          TxData<=0;
          Busy<=0;
          SampleData<=0;
          RWMem<=1'b0;
          AccessMem<=1'b0;
        end
        `SAMPLE0:
          if(Active && !Mode && !TxDone)
            begin
              state<=`TRANSFER;
              SampleData<=1'b0;
              TxData<=1'b1;
            end
        default:state<=`IDLE;
      endcase

endmodule
