`timescale 1ns/1ns

`include "adder_reg.v"

module adder_reg_tb ();
    parameter BITWIDTH = 32;

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [BITWIDTH-1 : 0] iData0;
    logic [BITWIDTH-1 : 0] iData1;
    logic [BITWIDTH : 0] oData;

    // This code is used to delay the expected output
    parameter PPCYCLE = 1;
    parameter OBITWIDTH = BITWIDTH+1;
    // dont change code below
    logic [OBITWIDTH-1 : 0] result [PPCYCLE-1:0];
    logic result_correct;
    logic [OBITWIDTH-1 : 0] result_expected;
    assign result_expected = iData0 + iData1;

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

    adder_reg #(
        .BITWIDTH(BITWIDTH)
    ) u_adder_reg (
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
        iData0 = 'd0;
        iData1 = 'd0;
        
        #205;
        iRstN = 1;
        repeat (100)
        #10 {iData0, iData1} = {$urandom(), $urandom()};
        iClr = 1;
        #100;
        $finish;
    end

endmodule
