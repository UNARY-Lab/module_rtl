`timescale 1ns/1ns

`include "mod_accumulator.v"

module mod_accumulator_tb ();

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [`BITWIDTH-1 : 0] iData;
    logic [`BITWIDTH-1 : 0] iQ;
    logic [`BITWIDTH-1 : 0] oData;

    mod_accumulator u_mod_accumulator (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData(iData),
        .iQ(iQ),
        .oData(oData)
    );

    // clk define
    always #5 iClk = ~iClk;

    initial begin
        $dumpfile("mod_accumulator.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        iData = 'd10;
        iQ = 13;
        
        #15;
        iRstN = 1;
        #400;
        iClr = 1;
        #400;
        $finish;
    end

endmodule
