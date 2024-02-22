`timescale 1ns/1ns

`include "outerprodrc.v"

module outerprodrc_tb ();

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [`ROWNUM * `BITWIDTH - 1 : 0] iData0; // input vector from row
    logic [`COLNUM * `BITWIDTH - 1 : 0] iData1; // input vector from col
    logic [`ROWNUM * `COLNUM * `OUTBITWIDTH - 1 : 0] oData;

    outerprodrc u_outerprodrc(
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
        $dumpfile("outerprodrc.vcd"); $dumpvars;
    end

    integer i;
    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 0;
        iClr = 0;

        // only test 2x2 array, bitwidth 4
        iData0[3:0] = {1'b0, 3'b010};
        iData0[7:4] = {1'b1, 3'b110};

        iData1[3:0] = {1'b1, 3'b100};
        iData1[7:4] = {1'b0, 3'b100};
        // iData0[`BITWIDTH-1:0] = {1'b0, {{`BITWIDTH-1}{1'b0}}};
        // iData0[2*`BITWIDTH-1:`BITWIDTH] = {1'b1, {{`BITWIDTH-2}{1'b0}}, 1'b1};
        // iData0[3*`BITWIDTH-1:2*`BITWIDTH] = {1'b0, {{`BITWIDTH-3}{1'b0}}, 2'b10};
        // iData0[4*`BITWIDTH-1:3*`BITWIDTH] = {1'b1, {{`BITWIDTH-4}{1'b0}}, 3'b11};

        // iData1[`BITWIDTH-1:0] = {1'b0, {{`BITWIDTH-1}{1'b0}}};
        // iData1[2*`BITWIDTH-1:`BITWIDTH] = {1'b1, {{`BITWIDTH-2}{1'b0}}, 1'b1};
        // iData1[3*`BITWIDTH-1:2*`BITWIDTH] = {1'b1, {{`BITWIDTH-3}{1'b0}}, 2'b10};
        // iData1[4*`BITWIDTH-1:3*`BITWIDTH] = {1'b0, {{`BITWIDTH-4}{1'b0}}, 3'b11};

        #15;
        iRstN = 1;

        #10;
        iEn = 1;
        #1000;
        $finish;
    end

endmodule

