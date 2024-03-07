`timescale 1ns/1ns

`include "mod_quadrupler_reg.v"

module mod_quadrupler_reg_tb ();
    parameter BITWIDTH = 32;

    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [BITWIDTH-1 : 0] iData;
    logic [BITWIDTH-1 : 0] iMod;
    logic [BITWIDTH-1 : 0] oData;
    
    // This code is used to delay the expected output
    parameter PPCYCLE = 1;
    parameter OBITWIDTH = BITWIDTH;

    logic [OBITWIDTH-1 : 0] result [PPCYCLE-1:0];
    logic result_correct;
    logic [OBITWIDTH-1 : 0] result_expected;
    logic [OBITWIDTH : 0] sum;
    assign sum = iData * 4;
    assign result_expected = sum % iMod;

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

    mod_quadrupler_reg #(
        .BITWIDTH(BITWIDTH)
    ) u_mod_quadrupler_reg (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData(iData),
        .iMod(iMod),
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
        iData = 'd0;
        iMod = 'd23;

        #205;
        iRstN = 1;
        repeat (100)
        #10 {iData} = {$urandom_range(iMod-1)};
        iClr = 1;
        #100;
        $finish;
    end

endmodule
