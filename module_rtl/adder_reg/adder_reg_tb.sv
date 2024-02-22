`timescale 1ns/1ns

`include "adder_reg.v"

module adder_reg_tb ();

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [`BITWIDTH-1 : 0] iData0;
    logic [`BITWIDTH-1 : 0] iData1;
    logic [`BITWIDTH : 0] oData;

    adder_reg u_adder_reg (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(iData0),
        .iData1(iData1),
        .oData(oData)
    );

    // clk define
    always #5 iClk = ~iClk;

    initial begin
        $dumpfile("adder_reg.vcd"); $dumpvars;
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
        #100;
        iClr = 1;
        #400;
        $finish;
    end

endmodule
