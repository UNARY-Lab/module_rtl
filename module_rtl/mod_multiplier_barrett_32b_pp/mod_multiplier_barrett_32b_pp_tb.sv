`timescale 1ns/1ns

`include "mod_multiplier_barrett_32b_pp.v"

module mod_multiplier_barrett_32b_pp_tb ();

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
    
    // This code is used to delay the expected output
    parameter PPCYCLE = 6;
    parameter OBITWIDTH = 32;
    // dont change code below
    logic [OBITWIDTH-1 : 0] result [PPCYCLE-1:0];
    logic result_correct;
    logic [2*OBITWIDTH-1 : 0] prod;
    logic [OBITWIDTH-1 : 0] result_expected;
    assign prod = iData0 * iData1;
    assign result_expected = prod % iMod;

    genvar i;
    generate
        for (i = 1; i < PPCYCLE; i = i + 1) begin
            always@(posedge iClk or negedge iRstN) begin
                if (~iRstN) begin
                    result[i] <= 0;
                end else begin
                    result[i] <= result[i-1];
                end
            end
        end
    endgenerate

    always@(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            result[0] <= 0;
        end else begin
            result[0] <= result_expected;
        end
    end
    assign result_correct = (oData == result[PPCYCLE-1]);
    // end here

    mod_multiplier_barrett_32b_pp u_mod_multiplier_barrett_32b_pp (
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

    initial begin
        $dumpfile("mod_multiplier_barrett_32b_pp.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        // (2^32)^2 / iMod
        // iK = 'd13;
        // iU = 'd8736;
        // iData0 = 'd1467;
        // iData1 = 'd2489;
        // iMod = 'd7681;

        iK = 'b100000;
        iU = 'b100000000000000000000000000000001;
        iData0 = 'd0;
        iData1 = 'd0;
        iMod = 32'b11111111111111111111111111111111;
        
        #205;
        iRstN = 1;
        repeat (100)
        #10 {iData0, iData1} = {$urandom(), $urandom()};
        iClr = 1;
        #100;
        $finish;
    end

endmodule
