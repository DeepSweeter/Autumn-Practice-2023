`include "ALU.sv"
`include "Concatenator.sv"
`include "Controller.sv"
`include "Frequency_Divider.sv"
`include "Memory.sv"
`include "MUX.sv"
`include "Serial_Transceiver.sv"

module top(
    input clk,
    input reset,
    input [7:0] inA,
    input [7:0] inB,
    input [3:0] aluOp,
    input inputKey,
    input RW,
    input validCmd,
    input [7:0] ADDR,
    input[31:0] freqDivInput,
    input configDiv,
    output  calcBusy,
    output  DoutValid,
    output  DataOut, //trebuie modificat in functie de parametrul LENGTH de la Serial_Transceiver
    output  clkTxOut
);

    //Transfer between module variables
    //Muxes
    wire [7:0] m1_out, m2_out;
    wire [3:0] m3_out;
    wire [31:0] m4_out;

    //ALU
    wire [7:0] alu_out;
    wire [3:0] alu_flags;

    //Concatenator
    wire [31:0] concat_out;

    //Memory
    wire [31:0] mem_out;

    //Frequency_Divider
    wire clkTx;
    assign clkTx = clkTxOut;

    //Controller
    wire c_active, c_rwmem, c_accessmem, c_sample, c_txdata, c_mode;

    //Serial_Transceiver
    wire st_txdone;

    //ANDs
    wire resetTmp, RWTmp;

    assign resetTmp = reset & ~c_active;
    assign RWTmp = RW & c_active;



    //Instances

    MUX #(.LENGTH(8)) M1 (.inA(inA), .inB(8'b0), .sel(resetTmp), .dout(m1_out));
    MUX #(.LENGTH(8)) M2 (.inA(inB), .inB(8'b0), .sel(resetTmp), .dout(m2_out));
    MUX #(.LENGTH(4)) M3 (.inA(aluOp), .inB(4'b0), .sel(resetTmp), .dout(m3_out));

    MUX #(.LENGTH(32)) M4 (.inA(concat_out), .inB(mem_out), .sel(c_mode), .dout(m4_out));

    ALU alu(.inA(m1_out), .inB(m2_out), .sel_tmp(m3_out), .dout(alu_out), .flags(alu_flags));

    Concatenator concat(.a(m1_out), .b(m2_out), .c(alu_out), .d(aluOp), .e(alu_flags), .dout(concat_out));

    Frequency_Divider fd(.din(freqDivInput), .configDiv(configDiv), .reset(resetTmp), .clk(clk), .enable(c_active), .clkOut(clkTxOut));

    Memory #(.WIDTH(32), .DEPTH(8)) mem(.din(concat_out), .addr(ADDR), .RW(c_rwmem), .valid(c_accessmem), .reset(resetTmp), .clk(clk), .dout(mem_out));

    //Daca se modifica parametrul length atunci DataOut trebuie modificat si el sa corespunda cu dimensiunea noua.
    Serial_Transceiver #(.LENGTH(1)) st(.din(m4_out), .sample(c_sample), .startTx(c_txdata), .reset(resetTmp), .clk(clk), .clkTx(clkTx), .txDone(st_txdone), .txBusy(DoutValid), .dout(DataOut));
    

    Controller con(.inputKey(inputKey), .validCmd(validCmd), .clk(clk), .reset(reset), .RW(RWTmp), .txDone(st_txdone),
                 .active(c_active), .mode(c_mode), .AccessMem(c_accessmem), .RWMem(c_rwmem), .SampleData(c_sample), .TxData(c_txdata), .Busy(calcBusy));


endmodule