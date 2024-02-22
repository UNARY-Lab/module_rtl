`ifndef mod_doubler_reg
`define mod_doubler_reg

`include "mod_doubler_reg.def"

module mod_doubler_reg (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [`BITWIDTH-1 : 0] iData,
    input wire [`BITWIDTH-1 : 0] iQ,
    output reg [`BITWIDTH-1 : 0] oData
);

    wire [`BITWIDTH : 0] oSum;

    assign oSum = {iData, 1'b0};
    
    always@(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            oData <= 0;
        end else begin
            if (iClr) begin
                oData <= 0;
            end else begin
                if (iEn) begin
                    oData <= (oSum < iQ) ? oSum[`BITWIDTH-1 : 0] : (oSum - iQ);
                end else begin
                    oData <= oData;
                end
            end
        end
    end

endmodule

`endif
