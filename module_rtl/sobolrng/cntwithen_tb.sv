`timescale 1ns/1ns
`include "cntwithen.v"

module cntwithen_tb ();

    logic iClk;
    logic iRstN;
    logic iEn;
    logic [`BITWIDTH-1:0] oCnt;

    cntwithen u_cntwithen(
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
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
        
        #15;
        iRstN = 1;
        #400;
        $finish;
    end

endmodule
