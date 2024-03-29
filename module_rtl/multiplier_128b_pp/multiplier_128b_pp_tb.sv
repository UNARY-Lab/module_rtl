`timescale 1ns/1ns

`include "multiplier_128b_pp.v"

module multiplier_128b_pp_tb ();
    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [128-1 : 0] iData0;
    logic [128-1 : 0] iData1;
    logic [2*128-1 : 0] oData;
    
    // This code is used to delay the expected output
    parameter PPCYCLE = 5;
    parameter OBITWIDTH = 2*128;
    // dont change code below
    logic [OBITWIDTH-1 : 0] result [PPCYCLE-1:0];
    logic result_correct;

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
            result[0] <= iData0 * iData1;
        end
    end
    assign result_correct = (oData == result[PPCYCLE-1]);
    // end here

    multiplier_128b_pp u_multiplier_128b_pp (
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
        $dumpfile("multiplier_128b_pp.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        iData0 = 'd0;
        iData1 = 'd0;
        
        #200;
        iRstN = 1;
        repeat (100) 
        #10 {iData0, iData1} = {$urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom(), $urandom()}; 
        iClr = 1;
        #100;
        $finish;
    end

endmodule
