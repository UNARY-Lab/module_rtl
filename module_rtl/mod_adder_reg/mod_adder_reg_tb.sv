`timescale 1ns/1ns

`include "mod_adder_reg.v"

module mod_adder_reg_tb ();
    parameter BITWIDTH = 32;

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [BITWIDTH-1 : 0] iData0;
    logic [BITWIDTH-1 : 0] iData1;
    logic [BITWIDTH-1 : 0] iQ;
    logic [BITWIDTH-1 : 0] oData;

    // This code is used to delay the expected output
    parameter PPCYCLE = 1;
    parameter OBITWIDTH = BITWIDTH;
    // dont change code below
    logic [OBITWIDTH-1 : 0] result [PPCYCLE-1:0];
    logic result_correct;
    logic [OBITWIDTH-1 : 0] result_expected;
    logic [OBITWIDTH : 0] sum;
    assign sum = iData0 + iData1;
    assign result_expected = sum % iQ;

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

    mod_adder_reg #(
        .BITWIDTH(BITWIDTH)
    ) u_mod_adder_reg (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(iData0),
        .iData1(iData1),
        .iQ(iQ),
        .oData(oData)
    );

    // clk define
    always #5 iClk = ~iClk;

    initial begin
        $dumpfile("mod_adder_reg.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        iData0 = 'd0;
        iData1 = 'd0;
        iQ = 'd23;

        #205;
        iRstN = 1;
        repeat (100)
        #10 {iData0, iData1} = {$urandom_range(iQ-1), $urandom_range(iQ-1)};
        iClr = 1;
        #100;
        $finish;
    end

endmodule
