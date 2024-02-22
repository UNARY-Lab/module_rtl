`timescale 1ns/1ns

`include "cntwithen.v"

module cntwithen_tb ();

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [`BITWIDTH-1:0] oCnt;

    cntwithen u_cntwithen(
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .oCnt(oCnt)
        );

    // clk define
    always #5 iClk = ~iClk;

    initial begin
        $dumpfile("cntwithen.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        
        #15;
        iRstN = 1;
        #100;
        iClr = 1;
        #100;
        $finish;
    end

endmodule
