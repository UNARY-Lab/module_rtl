`timescale 1ns/1ns

`include "multiplier_32b_reg_pp.v"

module multiplier_32b_reg_pp_tb ();
    
    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [32-1 : 0] iData0;
    logic [32-1 : 0] iData1;
    logic [2*32-1 : 0] oData;

    // This code is used to delay the expected output
    parameter PPCYCLE = 1;
    parameter OBITWIDTH = 2*32;
    logic [OBITWIDTH-1 : 0] result [PPCYCLE-1:0];
    logic result_correct;

    genvar i;
    generate
        for (i = 1; i < PPCYCLE; i = i + 1) begin
            always@(posedge iClk) begin
                result[i] <= result[i-1];
            end
        end
    endgenerate

    always@(posedge iClk) begin
        result[0] <= iData0 * iData1;
    end
    assign result_correct = (oData == result[PPCYCLE-1]);
    // end here

    multiplier_32b_reg_pp u_multiplier_32b_reg_pp (
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
        $dumpfile("multiplier_32b_reg_pp.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        iData0 = 'd0;
        iData1 = 'd0;
        
        #15;
        iRstN = 1;
        repeat (100) 
        #10 {iData0, iData1} = {$urandom(), $urandom()}; 
        iClr = 1;
        #100;
        $finish;
    end

endmodule
