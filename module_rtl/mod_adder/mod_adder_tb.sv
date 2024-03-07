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
    logic [BITWIDTH-1 : 0] iQ;
    logic [BITWIDTH-1 : 0] oData;
    logic [BITWIDTH-1 : 0] result;

    mod_adder #(
        .BITWIDTH(BITWIDTH)
    ) u_mod_adder (
        .iData0(iData0),
        .iData1(iData1),
        .iQ(iQ),
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
        iData0 = 'd10;
        iData1 = 'd20;
        iQ = 'd23;
        result = (iData0 + iData1) % iQ;

        #15;
        iRstN = 1;
        #10;
        iQ = 'd24;
        result = (iData0 + iData1) % iQ;
        #10;
        iQ = 'd25;
        result = (iData0 + iData1) % iQ;
        #10;
        iQ = 'd26;
        result = (iData0 + iData1) % iQ;
        #10;
        iQ = 'd27;
        result = (iData0 + iData1) % iQ;
        #10;
        iQ = 'd28;
        result = (iData0 + iData1) % iQ;
        #10;
        iQ = 'd29;
        result = (iData0 + iData1) % iQ;
        #10;
        iQ = 'd30;
        result = (iData0 + iData1) % iQ;
        #10;
        iQ = 'd31;
        result = (iData0 + iData1) % iQ;
        #10;
        iQ = 'd32;
        result = (iData0 + iData1) % iQ;
        #400;
        $finish;
    end

endmodule
