`timescale 1ns/1ns

`include "mod_quadrupler_reg.v"

module mod_quadrupler_reg_tb ();

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [`BITWIDTH-1 : 0] iData;
    logic [`BITWIDTH-1 : 0] iQ;
    logic [`BITWIDTH-1 : 0] oData;
    logic [`BITWIDTH-1 : 0] result;

    mod_quadrupler_reg u_mod_quadrupler_reg (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData(iData),
        .iQ(iQ),
        .oData(oData)
    );

    // clk define
    always #5 iClk = ~iClk;

    initial begin
        $dumpfile("mod_quadrupler_reg.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        iData = 'd10;
        iQ = 'd23;
        result = (iData * 4) % iQ;

        #15;
        iRstN = 1;
        #10;
        iQ = 'd22;
        result = (iData * 4) % iQ;
        #10;
        iQ = 'd21;
        result = (iData * 4) % iQ;
        #10;
        iQ = 'd20;
        result = (iData * 4) % iQ;
        #10;
        iQ = 'd19;
        result = (iData * 4) % iQ;
        #10;
        iQ = 'd18;
        result = (iData * 4) % iQ;
        #10;
        iQ = 'd17;
        result = (iData * 4) % iQ;
        #10;
        iQ = 'd16;
        result = (iData * 4) % iQ;
        #10;
        iQ = 'd15;
        result = (iData * 4) % iQ;
        #10;
        iQ = 'd14;
        result = (iData * 4) % iQ;
        #400;
        $finish;
    end

endmodule
