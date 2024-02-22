`timescale 1ns/1ns

`include "accumulator.v"

module accumulator_tb ();

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [`BITWIDTH-1 : 0] iData;
    logic [`BITWIDTH : 0] oData;

    accumulator u_accumulator (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData(iData),
        .oData(oData)
    );

    // clk define
    always #5 iClk = ~iClk;

    initial begin
        $dumpfile("accumulator.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        iData = 'd10;
        
        #15;
        iRstN = 1;
        #400;
        iClr = 1;
        #400;
        $finish;
    end

endmodule
