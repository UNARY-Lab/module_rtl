`ifndef multiplier_64b_reg_pp
`define multiplier_64b_reg_pp

// this module takes 3 cycles to finish
module multiplier_64b_reg_pp (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [64-1 : 0] iData0,
    input wire [64-1 : 0] iData1,
    output reg [2*64-1 : 0] oData
);

    // cycle 1
    reg [64-1:0] prod_ll;
    reg [64-1:0] prod_hl;
    reg [64-1:0] prod_lh;
    reg [64-1:0] prod_hh;

    // cycle 2
    reg [32-1:0] prod_ll_l;
    reg [32-1:0] prod_hh_h;
    reg [64-1+2:0] sum_mid;

    wire [32-1+1:0] sum_hh_mid;
    assign sum_hh_mid = prod_hh_h + sum_mid[64-1+2:64];

    always@(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            prod_ll <= 0;
            prod_hl <= 0;
            prod_lh <= 0;
            prod_hh <= 0;

            prod_ll_l <= 0;
            prod_hh_h <= 0;
            sum_mid <= 0;
            
            oData <= 0;
        end else begin
            if (iClr) begin
                prod_ll <= 0;
                prod_hl <= 0;
                prod_lh <= 0;
                prod_hh <= 0;

                prod_ll_l <= 0;
                prod_hh_h <= 0;
                sum_mid <= 0;

                oData <= 0;
            end else begin
                if (iEn) begin
                    // cycle 1
                    prod_ll <= iData0[32-1:0] * iData1[32-1:0];
                    prod_hl <= iData0[64-1:32] * iData1[32-1:0];
                    prod_lh <= iData0[32-1:0] * iData1[64-1:32];
                    prod_hh <= iData0[64-1:32] * iData1[64-1:32];
                    
                    // cycle 2
                    prod_ll_l <= prod_ll[32-1:0];
                    prod_hh_h <= prod_hh[64-1:32];
                    sum_mid <= prod_hl + prod_lh + {prod_hh[32-1:0], prod_ll[64-1:32]};
                    
                    // cycle 3
                    oData <= {sum_hh_mid[32-1:0], sum_mid[64-1:0], prod_ll_l};
                end else begin
                    prod_ll <= prod_ll;
                    prod_hl <= prod_hl;
                    prod_lh <= prod_lh;
                    prod_hh <= prod_hh;

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
