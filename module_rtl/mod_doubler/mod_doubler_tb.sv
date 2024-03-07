`timescale 1ns/1ns

`include "mod_doubler.v"

module mod_doubler_tb ();
    parameter BITWIDTH = 32;

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [BITWIDTH-1 : 0] iData;
    logic [BITWIDTH-1 : 0] iMod;
    logic [BITWIDTH-1 : 0] oData;

    logic result_correct;
    logic [BITWIDTH-1 : 0] result;
    logic [BITWIDTH : 0] sum;
    assign sum = iData * 2;
    assign result = sum % iMod;
    assign result_correct = (oData == result);

    mod_doubler #(
        .BITWIDTH(BITWIDTH)
    )u_mod_doubler (
        .iData(iData),
        .iMod(iMod),
        .oData(oData)
    );

    // clk define
    always #5 iClk = ~iClk;

    initial begin
        $dumpfile("mod_doubler.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        iData = 'd0;
        iMod = 'd23;

        #205;
        iRstN = 1;
        repeat (100)
        #10 {iData} = {$urandom_range(iMod-1)};
        iClr = 1;
        #100;
        $finish;
    end

endmodule
