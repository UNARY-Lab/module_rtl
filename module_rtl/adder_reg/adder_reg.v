`ifndef adder_reg
`define adder_reg

`include "adder_reg.def"

module adder_reg (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [`BITWIDTH-1 : 0] iData0,
    input wire [`BITWIDTH-1 : 0] iData1,
    output reg [`BITWIDTH : 0] oData
);

    always@(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            oData <= 0;
        end else begin
            if (iClr) begin
                oData <= 0;
            end else begin
                if (iEn) begin
                    oData <= iData0 + iData1;
                end else begin
                    oData <= oData;
                end
            end
        end
    end
    
endmodule

`endif
