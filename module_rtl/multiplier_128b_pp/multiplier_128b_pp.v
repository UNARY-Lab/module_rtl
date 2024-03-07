`ifndef multiplier_128b_pp
`define multiplier_128b_pp

`include "multiplier_64b_pp.v"

// this module takes 5 cycles to finish
module multiplier_128b_pp (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [128-1 : 0] iData0,
    input wire [128-1 : 0] iData1,
    output reg [2*128-1 : 0] oData
);

    wire [128-1:0] prod_ll;
    wire [128-1:0] prod_hl;
    wire [128-1:0] prod_lh;
    wire [128-1:0] prod_hh;

    // 3 cycles in parallel
    multiplier_64b_pp u_multiplier_64b_pp_ll (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(iData0[64-1:0]),
        .iData1(iData1[64-1:0]),
        .oData(prod_ll)
    );

    // 3 cycles in parallel
    multiplier_64b_pp u_multiplier_64b_pp_hl (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(iData0[128-1:64]),
        .iData1(iData1[64-1:0]),
        .oData(prod_hl)
    );

    // 3 cycles in parallel
    multiplier_64b_pp u_multiplier_64b_pp_lh (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(iData0[64-1:0]),
        .iData1(iData1[128-1:64]),
        .oData(prod_lh)
    );

    // 3 cycles in parallel
    multiplier_64b_pp u_multiplier_64b_pp_hh (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(iData0[128-1:64]),
        .iData1(iData1[128-1:64]),
        .oData(prod_hh)
    );

    // cycle 4
    reg [64-1:0] prod_ll_l;
    reg [64-1:0] prod_hh_h;
    reg [128-1+2:0] sum_mid;

    wire [64-1+1:0] sum_hh_mid;
    assign sum_hh_mid = prod_hh_h + sum_mid[128-1+2:128];

    always@(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            prod_ll_l <= 0;
            prod_hh_h <= 0;
            sum_mid <= 0;
            
            oData <= 0;
        end else begin
            if (iClr) begin
                prod_ll_l <= 0;
                prod_hh_h <= 0;
                sum_mid <= 0;

                oData <= 0;
            end else begin
                if (iEn) begin
                    // cycle 4
                    prod_ll_l <= prod_ll[64-1:0];
                    prod_hh_h <= prod_hh[128-1:64];
                    sum_mid <= prod_hl + prod_lh + {prod_hh[64-1:0], prod_ll[128-1:64]};
                    
                    // cycle 5
                    oData <= {sum_hh_mid[64-1:0], sum_mid[128-1:0], prod_ll_l};
                end else begin
                    prod_ll_l <= prod_ll_l;
                    prod_hh_h <= prod_hh_h;
                    sum_mid <= sum_mid;

                    oData <= oData;
                end
            end
        end
    end
    
endmodule


`endif
