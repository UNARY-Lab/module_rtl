`timescale 1ns/1ns

`include "mod_multiplier_barrett_64b.v"

module mod_multiplier_barrett_64b_tb ();

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [6 : 0] iK;
    logic [2*64-1 : 0] iU;
    logic [64-1 : 0] iData0;
    logic [64-1 : 0] iData1;
    logic [64-1 : 0] iMod;
    logic [64-1 : 0] oData;
    logic [64-1 : 0] result [15:0];
    logic result_correct;

    mod_multiplier_barrett_64b u_mod_multiplier_barrett_64b (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iK(iK),
        .iU(iU),
        .iData0(iData0),
        .iData1(iData1),
        .iMod(iMod),
        .oData(oData)
    );

    // clk define
    always #5 iClk = ~iClk;

    always@(posedge iClk) begin
        result[15] <= result[14];
        result[14] <= result[13];
        result[13] <= result[12];
        result[12] <= result[11];
        result[11] <= result[10];
        result[10] <= result[9];
        result[9] <= result[8];
        result[8] <= result[7];
        result[7] <= result[6];
        result[6] <= result[5];
        result[5] <= result[4];
        result[4] <= result[3];
        result[3] <= result[2];
        result[2] <= result[1];
        result[1] <= result[0];
        result[0] <= (iData0 * iData1) % iMod;
    end
    assign result_correct = (oData == result[15]);

    initial begin
        $dumpfile("mod_multiplier_barrett_64b.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        // (2^64)^2 / iMod
        iK = 'd13;
        iU = 'd8736;
        iData0 = 'd1467;
        iData1 = 'd2489;
        iMod = 'd7681;
        
        #15;
        iRstN = 1;
        #320;
        iK = 'b1000000;
        iU = 'b10000000000000000000000000000000000000000000000000000000000000001;
        iData0 = 'd0;
        iData1 = 'd0;
        iMod = 64'b1111111111111111111111111111111111111111111111111111111111111111;
        #160;
        repeat (10)
        #160 {iData0, iData1} = {$urandom(), $urandom(), $urandom(), $urandom()}; 
        iClr = 1;
        #40;
        $finish;
    end

endmodule
