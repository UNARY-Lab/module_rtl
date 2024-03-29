`timescale 1ns/1ns

`include "sobolrng.v"

module sobolrng_tb ();

    logic   iClk;
    logic   iRstN;
    logic   iEn;
    logic   iClr;
    logic   [`BITWIDTH-1:0]sobolSeq;

    sobolrng u_sobolrng(
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .sobolSeq(sobolSeq)
        );

    // clk define
    always #5 iClk = ~iClk;

    initial begin
        $dumpfile("sobolrng.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        
        #15;
        iRstN = 1;
        #400;
        iClr = 1;
        #400;
        $finish;
    end

endmodule
