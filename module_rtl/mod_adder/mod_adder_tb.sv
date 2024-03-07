`timescale 1ns/1ns

`include "mod_adder.v"

module mod_adder_tb ();
    parameter BITWIDTH = 32;

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [BITWIDTH-1 : 0] iData0;
    logic [BITWIDTH-1 : 0] iData1;
    logic [BITWIDTH-1 : 0] iMod;
    logic [BITWIDTH-1 : 0] oData;

    logic result_correct;
    logic [BITWIDTH-1 : 0] result;
    logic [BITWIDTH : 0] sum;
    assign sum = iData0 + iData1;
    assign result = sum % iMod;
    assign result_correct = (oData == result);

    mod_adder #(
        .BITWIDTH(BITWIDTH)
    ) u_mod_adder (
        .iData0(iData0),
        .iData1(iData1),
        .iMod(iMod),
        .oData(oData)
    );

    // clk define
    always #5 iClk = ~iClk;

    initial begin
        $dumpfile("mod_adder.vcd"); $dumpvars;
    end

    
    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        iData0 = 'd0;
        iData1 = 'd0;
        iMod = 'd23;

        #205;
        iRstN = 1;
        repeat (100)
        #10 {iData0, iData1} = {$urandom_range(iMod-1), $urandom_range(iMod-1)};
        iClr = 1;
        #100;
        $finish;
    end

endmodule
