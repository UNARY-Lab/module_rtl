`timescale 1ns/1ns

`include "mod_multiplier_barrett_32b.v"

module mod_multiplier_barrett_32b_tb ();

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [5 : 0] iK;
    logic [2*32-1 : 0] iU;
    logic [32-1 : 0] iData0;
    logic [32-1 : 0] iData1;
    logic [32-1 : 0] iMod;
    logic [32-1 : 0] oData;
    logic [32-1 : 0] result [9:0];
    logic result_correct;

    mod_multiplier_barrett_32b u_mod_multiplier_barrett_32b (
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
    assign result_correct = (oData == result[9]);

    initial begin
        $dumpfile("mod_multiplier_barrett_32b.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        // (2^32)^2 / iMod
        iK = 'd13;
        iU = 'd8736;
        iData0 = 'd1467;
        iData1 = 'd2489;
        iMod = 'd7681;
        
        #15;
        iRstN = 1;
        #200;
        iK = 'b100000;
        iU = 'b100000000000000000000000000000001;
        iData0 = 'd0;
        iData1 = 'd0;
        iMod = 32'b11111111111111111111111111111111;
        #100;
        repeat (10)
        #100 {iData0, iData1} = {$urandom(), $urandom()}; 
        iClr = 1;
        #40;
        $finish;
    end

endmodule
