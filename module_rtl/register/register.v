`ifndef register
`define register

`include "register.def"

module register (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [`BITWIDTH-1 : 0] iData,
    output reg [`BITWIDTH-1 : 0] oData
);

    always@(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            oData <= 0;
        end else begin
            if (iClr) begin
                oData <= 0;
            end else begin
                if (iEn) begin
                    oData <= iData;
                end else begin
                    oData <= iData;
                end
            end
        end
    end

endmodule

`endif
