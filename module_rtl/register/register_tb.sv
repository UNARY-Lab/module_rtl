`timescale 1ns/1ns

`include "register.v"

module register_tb ();
    parameter BITWIDTH = 32;

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [BITWIDTH-1 : 0] iData;
    logic [BITWIDTH-1 : 0] oData;

    register #(
        .BITWIDTH(BITWIDTH)
    ) u_register (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData(iData),
        .oData(oData)
    );

    // clk define
    always #5 iClk = ~iClk;

    initial begin
        $dumpfile("register.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        iData = 0;
        
        #15;
        iRstN = 1;
        #10;
        iData = 'd10;
        #10;
        iData = 'd100;
        #10;
        iData = 'd1000;
        #10;
        iData = 'd10000;
        #10;
        iClr = 1;
        #400;
        $finish;
    end

endmodule
