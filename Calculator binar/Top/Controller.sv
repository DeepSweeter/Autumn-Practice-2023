module DecInputKey(
    input inputKey,
    input validCmd,
    input reset,
    input clk,
    output reg active,
    output reg mode
);
    reg [4:0] mem;

    //Folosit pentru a determina cand a fost terminata introducerea secventei secrete
        //si a primului input de mode  
    reg [2:0] i = 3'd0;

    always@(posedge clk or posedge reset)begin
        if(reset) begin
            mem = 5'b0;
            i = 3'b0;
            active = 1'b0;
            mode = 1'b0;
        end
        else begin
            if(validCmd) begin
                if(i < 5)begin // Daca i == 5 a fost introduse secventa secreta si trebuie verificata
                   mem[i] = inputKey;
                   i = i + 1;
                end
            end
            if(i == 5) begin
                if(mem[3:0]==4'b0101) begin // Verificare secventa
                    active <= 1'b1;
                    mode <= mem[4]; //A fost introdus modul in mem pentru a putea fi activat simultan cu active
                    //altfel ar fi existat un delay de un clk intre ele
                    if(validCmd)
                        mode <= inputKey; // Daca validCmd = 1 atunci mode va deveni inputKey la fiecare clk.
                end

                end
        end
    end

endmodule

module Control_RW_Flow (
    input validCmd,
    input RW,
    input reset,
    input clk,
    input txDone,
    input active,
    input mode,
    output reg AccessMem,
    output reg RWMem,
    output reg SampleData,
    output reg TxData,
    output reg Busy  
);

reg [2:0] cs, ns;
wire [4:0] in;

//Datele de intrare dupa care se modifica starile
assign in = {validCmd, active, mode, RW, txDone}; 

//Pentru graful de fluenta vezi documentatia.
parameter s0 = 3'b000;
parameter s1 = 3'b001;
parameter s2 = 3'b010;
parameter s3 = 3'b011;
parameter s4 = 3'b100;
parameter s5 = 3'b101;
parameter s6 = 3'b110;


always@(posedge clk or posedge reset) begin
    if(reset)
        cs <= s0;
    else
        cs <= ns;
end

always @(cs or in)
    casex({cs,in})
    8'b000_0xxxx: ns <= s0; // Mode 1 Read 
    8'b000_1110x: ns <= s1;
    8'b001_x1100: ns <= s2;
    8'b010_x1x00: ns <= s3;
    8'b011_x1x00: ns <= s3;
    8'b011_x1x01: ns <= s0;

    8'b000_1111x: ns <= s4; //Mode 1 Write
    8'b100_1111x: ns <= s4;
    8'b100_1110x: ns <= s0;

    8'b000_110xx: ns <= s5; //Mode 0
    8'b101_x1000: ns <= s6;
    8'b110_x1000: ns <= s6;
    8'b110_x1001: ns <= s0;

    endcase
    
    always@(cs)
        case(cs)
            3'b000: {AccessMem, RWMem, SampleData, TxData, Busy} <= 5'b0;
            3'b001: {AccessMem, RWMem, SampleData, TxData, Busy} <= 5'b10001; 
            3'b010: {AccessMem, RWMem, SampleData, TxData, Busy} <= 5'b00101; 
            3'b011: {AccessMem, RWMem, SampleData, TxData, Busy} <= 5'b00011; 
            3'b100: {AccessMem, RWMem, SampleData, TxData, Busy} <= 5'b11001; 
            3'b101: {AccessMem, RWMem, SampleData, TxData, Busy} <= 5'b00101; 
            3'b110: {AccessMem, RWMem, SampleData, TxData, Busy} <= 5'b00011; 

        endcase

endmodule


module Controller(
    input inputKey,
    input validCmd,
    input clk,
    input reset,
    input RW,
    input txDone,
    output active,
    output mode,
    output AccessMem,
    output RWMem,
    output SampleData,
    output TxData,
    output Busy
);

    wire activeOut, modeOut;
    assign activeOut = active;
    assign modeOut = mode;

    DecInputKey decInKey(.inputKey(inputKey), .validCmd(validCmd), .reset(reset), .clk(clk),
                            .active(active), .mode(mode));

    Control_RW_Flow crwf(.validCmd(validCmd), .RW(RW), .reset(reset), .clk(clk), .txDone(txDone), .active(activeOut), .mode(modeOut),
                    .AccessMem(AccessMem), .RWMem(RWMem), .SampleData(SampleData), .TxData(TxData), .Busy(Busy));


endmodule