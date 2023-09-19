module DecInputKey (Clk,
                    InputKey,
                    ValidCmd,
                    Active,
                    Mode,
                    Reset);
  input Clk,Reset,ValidCmd;
  input InputKey;
  output reg Active=0,Mode=0;
  
  `define NextState state+1
  `define IN0 3'h0
  `define IN1 3'h1
  `define IN2 3'h2
  `define IN3 3'h3
  `define IN4 3'h4
  `define VERIFY 3'h5
  `define ACTIVE 3'h6

  reg [2:0]state=0;
  reg [4:0]key=0;

  always@(posedge Reset)
    begin
      state<=0;
      Active<=0;
      Mode<=0;
    end

  always@(posedge Clk)
    begin
      if(!Reset && ValidCmd)
        case(state)
          `IN0,`IN1,`IN2,`IN3,`IN4:
            begin
              key<={key[3:0],InputKey};
              state<=`NextState;
            end
          `VERIFY:
            begin
              if(key[4:1] === 4'b1010)
                begin
                  state<=`ACTIVE;
                  Active<=1'b1;
                  Mode<=key[0];
                end
              else
                begin
                  state<=`IN0;
                  key<=0;
                end
            end
          `ACTIVE:begin
            Mode=InputKey;
            state<=`ACTIVE;
          end
          default:
            state<=`IN0;
        endcase
    end

endmodule
