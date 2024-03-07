`timescale 1ns/1ns

`include "adder.v"

module adder_tb ();
    parameter BITWIDTH = 32;

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [BITWIDTH-1 : 0] iData0;
    logic [BITWIDTH-1 : 0] iData1;
    logic [BITWIDTH : 0] oData;

    adder #(
        .BITWIDTH(BITWIDTH)
    ) u_adder (
        .iData0(iData0),
        .iData1(iData1),
        .oData(oData)
    );

    // clk define
    always #5 iClk = ~iClk;

    initial begin
        $dumpfile("adder.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        iData0 = 'd10;
        iData1 = 'd20;
        
        #15;
        iRstN = 1;
        #400;
        $finish;
    end

endmodule
