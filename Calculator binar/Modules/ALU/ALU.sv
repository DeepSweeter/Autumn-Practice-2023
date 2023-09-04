module ALU(
  input [7:0] inA,
  input [7:0] inB,
  input [3:0] sel_tmp,
  output reg [7:0] dout,
  output reg [3:0] flags
);
  always@(*)
    begin
        flags = 4'b0;
        case(sel_tmp)
            4'h0: begin //ADD
            if(inA + inB >= 256)
                begin
                flags[2] = 1'b1;
                end
            if(inA + inB == 0)
                begin
                flags[0] = 1'b1;
                end
            dout = inA + inB;
            end
            4'h1:begin //SUB
            if(inA < inB)
                begin
                flags[3] = 1'b1;
                end
            if(inA-inB == 0)
                begin
                flags[0] = 1'b1;
                end
            dout = inA-inB;
            end
            4'h2:begin //MUL
            if(inA * inB >= 256)
                begin
                flags[2] = 1'b1;
                end
            if(inA * inB == 0)
                begin
                flags[0] = 1'b1;
                end
            dout = inA * inB;
            end
            4'h3:begin //DIV
                if(inB == 0)
                    begin
                        flags[2] = 1'b1;
                    end
                if(inA < inB)
                    begin
                        flags[3] = 1'b1;
                    end
                dout = inA / inB;

            end
            4'h4:begin //SHL
            if(inB >= 8)
                begin
                    flags[0] = 1'b1;
                    dout = 8'b0;
                end
            else
                begin
                    dout = inA << inB;
                    flags[1] = inA[7- inB + 1];
                    if(dout == 8'b0)
                        flags[0] = 1'b1;
                end
            end
            4'h5:begin //SHR
                if(inB >= 8)
                    begin
                        flags[0] = 1'b1;
                        dout = 8'b0;
                    end
                else
                    begin
                        dout = inA>>inB;
                        flags[1] = inA[inB-1];
                        if(dout == 8'b0)
                            flags[0] = 1'b1;
                    end
            end
            4'h6:begin //AND
                dout = inA & inB;
                if(dout == 8'b0)
                    flags[0] = 1'b1;
            end
            4'h7:begin //OR
                dout = inA | inB;
                if(dout == 8'b0)
                    flags[0] = 1'b1;
            end
            4'h8:begin //XOR
                dout = inA ^ inB;
                if(dout == 8'b0)
                    flags[0] = 1'b1;
            end
            4'h9:begin //NXOR
                dout = inA ~^ inB;
                if(dout == 8'b0)
                    flags[0] = 1'b1;
            end
            4'ha:begin //NAND
                dout = inA ~& inB;
                if(dout == 8'b0)
                    flags[0] = 1'b1;
            end
            4'hb:begin //NOR
                dout = inA ~| inB;
                if(dout == 8'b0)
                    flags[0] = 1'b1;
            end
            4'hc, 4'hd, 4'he, 4'hf:begin //Default
                dout = 8'b0;
                flags = 4'b0;
            end
      endcase
        
    end


endmodule