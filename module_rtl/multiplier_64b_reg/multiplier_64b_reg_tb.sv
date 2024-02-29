`timescale 1ns/1ns

`include "multiplier_64b_reg.v"

module multiplier_64b_reg_tb ();
    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [64-1 : 0] iData0;
    logic [64-1 : 0] iData1;
    logic [2*64-1 : 0] oData;
    logic [2*64-1 : 0] result [3:0];
    logic result_correct;

    multiplier_64b_reg u_multiplier_64b_reg (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(iData0),
        .iData1(iData1),
        .oData(oData)
    );

    always@(posedge iClk) begin
        result[3] <= result[2];
        result[2] <= result[1];
        result[1] <= result[0];
        result[0] <= iData0 * iData1;
    end
    assign result_correct = (oData == result[3]);

    // clk define
    always #5 iClk = ~iClk;

    initial begin
        $dumpfile("multiplier_64b_reg.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        iData0 = 64'b0;
        iData1 = 64'b0;
        
        #15;
        iRstN = 1;
        repeat (100) 
        #40 {iData0, iData1} = {$urandom(), $urandom(), $urandom(), $urandom()}; 
        iClr = 1;
        #400;
        $finish;
    end

endmodule
