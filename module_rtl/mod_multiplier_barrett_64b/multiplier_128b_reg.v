`ifndef multiplier_128b_reg
`define multiplier_128b_reg

`include "multiplier_64b_reg.v"

// this module take 7 cycles to finish
module multiplier_128b_reg (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [128-1 : 0] iData0,
    input wire [128-1 : 0] iData1,
    output wire [2*128-1 : 0] oData
);

    wire [128-1:0] prod_ll;
    wire [128-1:0] prod_hl;
    wire [128-1:0] prod_lh;
    wire [128-1:0] prod_hh;

    // 4 cycles in parallel
    multiplier_64b_reg u_multiplier_64b_reg_ll (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(iData0[64-1:0]),
        .iData1(iData1[64-1:0]),
        .oData(prod_ll)
    );

    // 4 cycles in parallel
    multiplier_64b_reg u_multiplier_64b_reg_hl (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(iData0[128-1:64]),
        .iData1(iData1[64-1:0]),
        .oData(prod_hl)
    );

    // 4 cycles in parallel
    multiplier_64b_reg u_multiplier_64b_reg_lh (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(iData0[64-1:0]),
        .iData1(iData1[128-1:64]),
        .oData(prod_lh)
    );

    // 4 cycles in parallel
    multiplier_64b_reg u_multiplier_64b_reg_hh (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(iData0[128-1:64]),
        .iData1(iData1[128-1:64]),
        .oData(prod_hh)
    );

    reg [128-1+1:0] sum_hl_lh;
    reg [128-1+2:0] sum_mid;
    reg [64-1+1:0] sum_hh_mid;

    assign oData = {sum_hh_mid[64-1:0], sum_mid[128-1:0], prod_ll[64-1:0]};

    always@(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            sum_hl_lh <= 0;
            sum_mid <= 0;
            sum_hh_mid <= 0;
        end else begin
            if (iClr) begin
                sum_hl_lh <= 0;
                sum_mid <= 0;
                sum_hh_mid <= 0;
            end else begin
                if (iEn) begin
                    // 1 cycle
                    sum_hl_lh <= prod_hl + prod_lh;
                    // 1 cycle
                    sum_mid <= sum_hl_lh + {prod_hh[64-1:0], prod_ll[128-1:64]};
                    // 1 cycle
                    sum_hh_mid <= prod_hh[128-1:64] + sum_mid[128-1+2:128];
                end else begin
                    sum_hl_lh <= sum_hl_lh;
                    sum_mid <= sum_mid;
                    sum_hh_mid <= sum_hh_mid;
                end
            end
        end
    end
    
endmodule


`endif
