module Serial_Transceiver #(
    parameter LENGTH = 4
)
(
    input[31:0] din,
    input sample,
    input startTx,
    input reset,
    input clk,
    input clkTx,
    output reg txDone,
    output reg txBusy,
    output reg [LENGTH-1:0] dout
);
    reg [31:0] mem;

    // Variabila folosita pentru a calcula cate transferuri trebuie facute
    // De preferat sa fie divizor a lui 32 altfel e posibil sa apara rezultate neasteptate
    // Exemplu pentru valoarea default 4: 32/4 = 8 => 8 transferuri de 4 biti pana cand se termina transferul
    reg[5:0] i = 32 / LENGTH;  

    always@(posedge clk or posedge reset) begin
        if(reset)begin
            mem = 32'b0;
            txDone = 1'b0;
            txBusy = 1'b0;
            dout = 0;
        end
        else begin
            if(clk) begin
                if(sample && ~startTx)begin
                    mem <= din;
                    i <= 32/LENGTH;
                    dout <= 0;
                    txDone <= 1'b0; // txDone se modifica la clk
                end
                else if(~sample && startTx)begin
                    txBusy <= 1'b1;
                    txDone <= 1'b0;
                end
                if(i == 0)begin
                    txDone <= 1'b1;
                    dout <= 0;
                end
            end

        end
    end

    //Probleme cunoscute:
    //Transferul incepe la un ciclu de clkTx dupa ce startTx este 1
    //La finalul transferului daca datele de intrare nu se modifica
        //intra intr-o bucla infinita in care i se modifica constant. Nu afecteaza DataOut

    always@(posedge clkTx)begin
        if(i != 0 && txBusy == 1'b1) begin
            dout <= mem[31:32-LENGTH];
            mem <= mem << LENGTH;
            i = i - 1;
        end
        if(txDone == 1'b1)begin
            txBusy <= 1'b0; //txBusy trece in 0 doar la clkTx
            dout<= 0;
        end
    end
    
endmodule