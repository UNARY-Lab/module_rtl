`ifndef adder
`define adder

module adder #(
    parameter BITWIDTH=32
) (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [BITWIDTH-1 : 0] iData0,
    input wire [BITWIDTH-1 : 0] iData1,
    output reg [BITWIDTH : 0] oData
);

    wire [BITWIDTH : 0] oSum
    assign oSum = iData0 + iData1;

    REGISTER #(
        .BITWIDTH(BITWIDTH+1)
    ) u_REGISTER(
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData(oSum),
        .oData(oData)
    );
    
endmodule


module REGISTER #(
    parameter BITWIDTH=32
) (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [BITWIDTH-1 : 0] iData,
    output reg [BITWIDTH-1 : 0] oData
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
