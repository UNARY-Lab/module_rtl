`timescale 1ns/1ns

`include "shift_register.v"

module shift_register_tb ();
    parameter BITWIDTH = 32;
    parameter DEPTH = 8;
    
    logic iClk;
    logic iRstN;
    logic iEn;
    logic iClr;
    logic [BITWIDTH-1 : 0] iData;
    logic [BITWIDTH-1 : 0] oData;

    // This code is used to delay the expected output
    parameter PPCYCLE = DEPTH;
    parameter OBITWIDTH = BITWIDTH;
    // dont change code below
    logic [OBITWIDTH-1 : 0] result [PPCYCLE-1:0];
    logic result_correct;
    logic [OBITWIDTH-1 : 0] result_correct;
    assign result_correct = iData;

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
            result[0] <= result_correct;
        end
    end
    assign result_correct = (oData == result[PPCYCLE-1]);
    // end here

    shift_register #(
        .BITWIDTH(BITWIDTH),
        .DEPTH(DEPTH)
    ) u_shift_register (
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
        $dumpfile("shift_register.vcd"); $dumpvars;
    end

    initial
    begin
        iClk = 1;
        iRstN = 0;
        iEn = 1;
        iClr = 0;
        iData = 'd0;
        
        #200;
        iRstN = 1;
        repeat (100)
        #10 {iData} = $urandom();
        iClr = 1;
        #100;
        $finish;
    end

endmodule
