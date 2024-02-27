`ifndef multiplier_64b_reg
`define multiplier_64b_reg

// this module take 4 cycles to finish
module multiplier_64b_reg (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [64-1 : 0] iData0,
    input wire [64-1 : 0] iData1,
    output wire [2*64-1 : 0] oData
);

    reg [64-1:0] prod_ll;
    reg [64-1:0] prod_hl;
    reg [64-1:0] prod_lh;
    reg [64-1:0] prod_hh;

    reg [64-1+1:0] sum_hl_lh;
    reg [64-1+2:0] sum_mid;
    reg [32-1+1:0] sum_hh_mid;

    assign oData = {sum_hh_mid[32-1:0], sum_mid[64-1:0], prod_ll[32-1:0]};

    always@(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            prod_ll <= 0;
            prod_hl <= 0;
            prod_lh <= 0;
            prod_hh <= 0;

            sum_hl_lh <= 0;
            sum_mid <= 0;
            sum_hh_mid <= 0;
        end else begin
            if (iClr) begin
                prod_ll <= 0;
                prod_hl <= 0;
                prod_lh <= 0;
                prod_hh <= 0;

                sum_hl_lh <= 0;
                sum_mid <= 0;
                sum_hh_mid <= 0;
            end else begin
                if (iEn) begin
                    prod_ll <= iData0[32-1:0] * iData1[32-1:0];
                    prod_hl <= iData0[64-1:32] * iData1[32-1:0];
                    prod_lh <= iData0[32-1:0] * iData1[64-1:32];
                    prod_hh <= iData0[64-1:32] * iData1[64-1:32];
                    
                    sum_hl_lh <= prod_hl + prod_lh;
                    sum_mid <= sum_hl_lh + {prod_hh[32-1:0], prod_ll[64-1:32]};
                    sum_hh_mid <= prod_hh[64-1:32] + sum_mid[64-1+2:64];
                end else begin
                    prod_ll <= prod_ll;
                    prod_hl <= prod_hl;
                    prod_lh <= prod_lh;
                    prod_hh <= prod_hh;

                    sum_hl_lh <= sum_hl_lh;
                    sum_mid <= sum_mid;
                    sum_hh_mid <= sum_hh_mid;
                end
            end
        end
    end
    
endmodule


`endif
